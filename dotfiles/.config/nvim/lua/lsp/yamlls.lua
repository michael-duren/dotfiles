vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function(ev)
    -- safe require schemastore
    local ok_ss, schemastore = pcall(require, "schemastore")
    if not ok_ss then
      vim.notify("schemastore.nvim not available; please install b0o/SchemaStore.nvim", vim.log.levels.WARN)
      schemastore = nil
    end

    -- build starting schemas from schemastore if available
    local schemas = {}
    if schemastore and schemastore.yaml and schemastore.yaml.schemas then
      schemas = schemastore.yaml.schemas()
    end

    -- your custom overrides / additions
    local filepath = vim.api.nvim_buf_get_name(ev.buf)
    local filename = vim.fn.fnamemodify(filepath, ":t")

    -- SQLC support
    if filename == "sqlc.yaml" then
      schemas["https://json.schemastore.org/sqlc.json"] = "sqlc.yaml"
    end

    -- Kubernetes support for deployment directories
    if filepath:match("/deployment/") or filepath:match("/deployments/") then
      -- keep a clear k8s schema key for picker convenience
      schemas["kubernetes"] = schemas["kubernetes"] or {}
      table.insert(schemas["kubernetes"], "*.yaml")
    end

    -- Concourse Pipeline support (community schema)
    schemas["https://raw.githubusercontent.com/cappyzawa/concourse-pipeline-jsonschema/master/concourse_jsonschema.json"] = {
      "pipeline.yml", "pipeline.yaml", "*/pipeline.yml", "*/pipeline.yaml",
      "*pipeline*.yml", "*pipeline*.yaml", "concourse.yml", "concourse.yaml",
      "*.concourse.yml", "*.concourse.yaml",
    }

    -- Start YAML LSP (your existing approach)
    vim.lsp.start({
      name = "yamlls",
      cmd = { "yaml-language-server", "--stdio" },
      root_dir = vim.fs.root(ev.buf, { ".git" }) or vim.fn.getcwd(),
      settings = {
        yaml = {
          schemaStore = { enable = false, url = "" }, -- we're using schemastore.nvim
          schemas = schemas,
          validate = true,
          completion = true,
          hover = true,
          schemaDownload = { enable = true },
        },
      },
    })

    ------------------------------------------------------------
    -- Helper functions for schema picker & application
    ------------------------------------------------------------
    local function get_yamlls_client(bufnr)
      bufnr = bufnr or ev.buf or vim.api.nvim_get_current_buf()
      for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        if c.name == "yamlls" or c.name:match("^yaml") or c.name:match("yaml%-language%-server") then
          return c
        end
      end
      return nil
    end

    -- normalize to table
    local function as_table(v)
      if v == nil then return {} end
      if type(v) == "string" then return { v } end
      return vim.deepcopy(v)
    end

    -- apply schema by updating the client's settings and notifying the server
    local function apply_schema_to_buf(bufnr, schema_id)
      bufnr = bufnr or ev.buf or vim.api.nvim_get_current_buf()
      local client = get_yamlls_client(bufnr)
      if not client then
        vim.notify("yamlls is not attached to this buffer (wait a moment after opening the file)", vim.log.levels.WARN)
        return
      end

      -- ensure buffer saved
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname == "" then
        vim.notify("Save the buffer (give it a path) before applying a schema.", vim.log.levels.WARN)
        return
      end

      client.config.settings = client.config.settings or {}
      client.config.settings.yaml = client.config.settings.yaml or {}
      client.config.settings.yaml.schemaDownload = client.config.settings.yaml.schemaDownload or { enable = true }

      -- start from current mapping or our initial schemastore mapping
      local current = vim.deepcopy(client.config.settings.yaml.schemas or schemas or {})

      -- ensure entry is table and add the literal filepath so yamlls matches this buffer
      local entry = as_table(current[schema_id])
      -- avoid duplicate
      if not vim.tbl_contains(entry, bufname) then
        table.insert(entry, bufname)
      end
      current[schema_id] = entry

      client.config.settings.yaml.schemas = current

      -- tell the server about the change
      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })

      vim.notify("Applied schema: " .. tostring(schema_id), vim.log.levels.INFO)
    end

    -- insert modeline to top of file if requested
    local function insert_modeline(bufnr, schema_id)
      bufnr = bufnr or ev.buf
      local schema_url = schema_id
      -- if the user selected a schemastore key like "kubernetes", try to convert to a URL if present in schemastore
      if schemastore and schemastore.yaml and schemastore.yaml.schemas then
        local ss = schemastore.yaml.schemas()
        if ss and ss[schema_id] and type(ss[schema_id]) == "string" then
          schema_url = schema_id -- leave as-is; many SS keys are urls already
        end
      end

      -- add modeline: # yaml-language-server: $schema=<url>
      if not schema_url:match("^https?://") then
        -- no URL — nothing to persist as remote schema; still allow custom id
        schema_url = schema_id
      end

      local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
      -- don't duplicate a modeline if present
      if first_line:match("yaml%-language%-server:.*%$schema") then
        vim.notify("Modeline already present at top of file; remove existing if you want to change it.",
          vim.log.levels.INFO)
        return
      end

      vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { "# yaml-language-server: $schema=" .. schema_url })
      vim.notify("Inserted modeline for schema: " .. schema_url, vim.log.levels.INFO)
    end

    ------------------------------------------------------------
    -- Picker UI: curated + full SchemaStore
    ------------------------------------------------------------
    local curated = {
      { label = "Kubernetes (kubernetes-json-schema)", id = "kubernetes" },
      { label = "GitHub Actions (workflow)",           id = "https://json.schemastore.org/github-workflow.json" },
      { label = "GitHub Action (single action)",       id = "https://json.schemastore.org/github-action.json" },
      { label = "Concourse",                           id = "https://raw.githubusercontent.com/cappyzawa/concourse-pipeline-jsonschema/master/concourse_jsonschema.json" },
      { label = "Ansible (roles/tasks)",               id = "https://json.schemastore.org/ansible-stable-2.9.json" },
      { label = "Docker Compose",                      id = "https://json.schemastore.org/docker-compose.json" },
      { label = "Kustomization",                       id = "https://json.schemastore.org/kustomization.json" },
      { label = "Helm Chart",                          id = "https://json.schemastore.org/chart.json" },
      { label = "CircleCI",                            id = "https://json.schemastore.org/circleciconfig.json" },
      { label = "SQLC (sqlc.yaml)",                    id = "https://json.schemastore.org/sqlc.json" },
      { label = "=== All SchemaStore entries ===",     id = "__all_schemastore" },
    }

    local function open_full_schemastore_picker(bufnr)
      bufnr = bufnr or ev.buf
      if not schemastore or not schemastore.yaml or not schemastore.yaml.schemas then
        vim.notify("SchemaStore not available", vim.log.levels.WARN)
        return
      end
      local all = schemastore.yaml.schemas()
      local items = {}
      for url, patt in pairs(all) do
        local name = url
        -- try to prettify name for common urls
        name = name:gsub("^https?://", ""):gsub("/src.*", ""):gsub("%.json$", "")
        table.insert(items, { label = name, id = url })
      end
      table.sort(items, function(a, b) return a.label < b.label end)
      vim.ui.select(items, { prompt = "SchemaStore: select schema", format_item = function(i) return i.label end },
        function(choice)
          if not choice then return end
          -- apply and offer to persist
          apply_schema_to_buf(bufnr, choice.id)
          vim.ui.select({ "No", "Yes - add modeline at top" }, { prompt = "Persist as modeline?" }, function(p)
            if p == "Yes - add modeline at top" then insert_modeline(bufnr, choice.id) end
          end)
        end)
    end

    local function open_schema_picker(bufnr)
      bufnr = bufnr or ev.buf
      vim.ui.select(curated, {
        prompt = "Select YAML schema (curated)",
        format_item = function(item) return item.label end,
      }, function(choice)
        if not choice then return end
        if choice.id == "__all_schemastore" then
          open_full_schemastore_picker(bufnr)
          return
        end
        -- apply and ask whether to persist via modeline
        apply_schema_to_buf(bufnr, choice.id)
        vim.ui.select({ "No", "Yes - add modeline" }, { prompt = "Persist chosen schema as modeline?" }, function(p)
          if p == "Yes - add modeline" then insert_modeline(bufnr, choice.id) end
        end)
      end)
    end

    ------------------------------------------------------------
    -- buffer-local keymap to open the picker and to show current schema
    ------------------------------------------------------------
    local bufnr = ev.buf
    -- ensure it runs after LSP has attached (a tiny delay often helps when start() triggers attach slightly later)
    vim.defer_fn(function()
      -- set buffer-local keymaps
      vim.keymap.set("n", "<leader>ys", function() open_schema_picker(bufnr) end,
        { buffer = bufnr, desc = "YAML: select schema" })
      vim.keymap.set("n", "<leader>yi", function()
        local client = get_yamlls_client(bufnr)
        if not client then
          vim.notify("yamlls not attached yet", vim.log.levels.INFO); return
        end
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local found = nil
        for sid, patt in pairs(client.config.settings.yaml.schemas or {}) do
          for _, p in ipairs(as_table(patt)) do
            if p == bufname then
              found = sid; break
            end
          end
          if found then break end
        end
        if found then
          vim.notify("Active schema: " .. tostring(found), vim.log.levels.INFO)
        else
          vim.notify("No explicit schema mapped for this file (using default detection)", vim.log.levels.INFO)
        end
      end, { buffer = bufnr, desc = "YAML: show current schema" })
    end, 100)
  end,
})
