vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function(ev)
    local schemastore = require("schemastore")
    local schemas = schemastore.yaml.schemas()

    local filepath = vim.api.nvim_buf_get_name(ev.buf)
    local filename = vim.fn.fnamemodify(filepath, ":t")

    ------------------------------------------------------------------
    -- Custom Schema Overrides
    ------------------------------------------------------------------

    -- SQLC support
    if filename == "sqlc.yaml" then
      schemas["https://json.schemastore.org/sqlc.json"] = "sqlc.yaml"
    end

    -- Kubernetes support for deployment directories
    if filepath:match("/deployment/") or filepath:match("/deployments/") then
      schemas["https://json.schemastore.org/kubernetes.json"] = "*.yaml"
    end

    -- Concourse Pipeline support (community-maintained schema)
    schemas["https://raw.githubusercontent.com/cappyzawa/concourse-pipeline-jsonschema/master/concourse_jsonschema.json"] = {
      "pipeline.yml",
      "pipeline.yaml",
      "*/pipeline.yml",
      "*/pipeline.yaml",
      "*pipeline*.yml",
      "*pipeline*.yaml",
      "concourse.yml",
      "concourse.yaml",
      "*.concourse.yml",
      "*.concourse.yaml",
    }

    ------------------------------------------------------------------
    -- Start YAML LSP
    ------------------------------------------------------------------

    vim.lsp.start({
      name = "yamlls",
      cmd = { "yaml-language-server", "--stdio" },
      root_dir = vim.fs.root(ev.buf, { ".git" }) or vim.fn.getcwd(),
      settings = {
        yaml = {
          schemaStore = {
            enable = false, -- using schemastore.nvim instead
            url = "",
          },
          schemas = schemas,
          validate = true,
          completion = true,
          hover = true,
        },
      },
    })
  end,
})
