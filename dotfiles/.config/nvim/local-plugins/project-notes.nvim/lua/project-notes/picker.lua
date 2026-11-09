local M = {}
local notes_module = require("project-notes.notes")
local store = require("project-notes.store")
local window = require("project-notes.window")

---@return ProjectNotesOpts
local function config()
  return require("project-notes").config
end

-- Detect which picker is available
local function get_picker()
  local picker_pref = config().picker or "auto"

  if picker_pref == "snacks" then
    local ok = pcall(require, "snacks")
    if ok then
      return "snacks"
    end
    vim.notify("Snacks.nvim not found, falling back to telescope", vim.log.levels.WARN)
  end

  if picker_pref == "telescope" then
    local ok = pcall(require, "telescope")
    if ok then
      return "telescope"
    end
    vim.notify("Telescope not found", vim.log.levels.WARN)
    return nil
  end

  -- Auto-detect
  if pcall(require, "snacks") then
    return "snacks"
  end

  if pcall(require, "telescope") then
    return "telescope"
  end

  return nil
end

---Warn when a notebook feature that only exists for Snacks is used without it
---@param feature string
---@return boolean
local function require_snacks(feature)
  if get_picker() == "snacks" then
    return true
  end
  vim.notify("Notebook " .. feature .. " requires snacks.nvim", vim.log.levels.WARN)
  return false
end

-- Snacks.nvim picker implementation
local function find_notes_snacks()
  local snacks = require("snacks")
  local notes = notes_module.get_notes()

  if #notes == 0 then
    vim.notify("No notes found for this project", vim.log.levels.INFO)
    return
  end

  -- Format notes for snacks picker
  local items = {}
  for _, note in ipairs(notes) do
    table.insert(items, {
      text = note.title,
      file = note.path,
      note = note,
    })
  end

  snacks.picker.pick({
    prompt = "Project Notes",
    items = items,
    preview = "file",
    confirm = function(picker, item)
      picker:close()
      if item then
        window.open(item.file)
      end
    end,
    format = function(item)
      return { { item.text } }
    end,
  })
end

-- Telescope picker implementation
local function find_notes_telescope()
  local has_telescope = pcall(require, "telescope.builtin")

  if not has_telescope then
    vim.notify(
      "Telescope is not installed. Install nvim-telescope/telescope.nvim or snacks.nvim to use this feature.",
      vim.log.levels.WARN
    )
    return
  end

  local notes = notes_module.get_notes()

  if #notes == 0 then
    vim.notify("No notes found for this project", vim.log.levels.INFO)
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local previewers = require("telescope.previewers")

  -- Create a list of entries
  local entries = {}
  for _, note in ipairs(notes) do
    table.insert(entries, {
      value = note.path,
      display = note.title,
      ordinal = note.title,
      path = note.path,
      note = note,
    })
  end

  pickers
    .new({}, {
      prompt_title = "Project Notes",
      finder = finders.new_table({
        results = entries,
        entry_maker = function(entry)
          return {
            value = entry.value,
            display = entry.display,
            ordinal = entry.ordinal,
            path = entry.path,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      previewer = previewers.new_buffer_previewer({
        title = "Note Preview",
        define_preview = function(self, entry)
          conf.buffer_previewer_maker(entry.path, self.state.bufnr, {
            bufname = self.state.bufname,
            winid = self.state.winid,
          })
        end,
      }),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          window.open(selection.path)
        end)
        return true
      end,
    })
    :find()
end

-- Main find_notes function that delegates to the appropriate picker
function M.find_notes()
  local picker = get_picker()

  if not picker then
    vim.notify("No picker found. Install snacks.nvim or telescope.nvim to use this feature.", vim.log.levels.WARN)
    return
  end

  if picker == "snacks" then
    find_notes_snacks()
  elseif picker == "telescope" then
    find_notes_telescope()
  end
end

-- Notebook pickers: search the whole notes dir, not just the current project

---Confirm action shared by every notebook picker: open via the note window
local function confirm(picker, item)
  picker:close()
  if item then
    window.open(Snacks.picker.util.path(item), item.pos)
  end
end

---Open the selected telescope entry via the note window
local function telescope_attach(prompt_bufnr)
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  actions.select_default:replace(function()
    actions.close(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    local path = entry.path or entry.filename or entry.value
    if not path:match("^/") then
      path = config().dir .. "/" .. path
    end
    window.open(path, entry.lnum and { entry.lnum, (entry.col or 1) - 1 } or nil)
  end)
  return true
end

---Find notes by filename. <c-n> creates a note from the query,
---<c-r> renames and <c-x> deletes the selected note.
M.find = function()
  local picker = get_picker()
  if picker == "telescope" then
    require("telescope.builtin").find_files({
      prompt_title = "Notebook",
      cwd = config().dir,
      attach_mappings = telescope_attach,
    })
    return
  elseif not require_snacks("find") then
    return
  end

  Snacks.picker.files({
    title = "Notebook",
    cwd = config().dir,
    confirm = confirm,
    actions = {
      notebook_new = function(p)
        local title = p.input:get()
        p:close()
        require("project-notes").new(title)
      end,
      notebook_rename = function(p, item)
        if not item then
          return
        end
        local path = Snacks.picker.util.path(item)
        vim.ui.input({ prompt = "Rename to: ", default = vim.fn.fnamemodify(path, ":t:r") }, function(title)
          if title and title ~= "" and store.rename(path, title) then
            p:find()
          end
        end)
      end,
      notebook_delete = function(p, item)
        if not item then
          return
        end
        local path = Snacks.picker.util.path(item)
        local name = vim.fn.fnamemodify(path, ":t")
        if vim.fn.confirm("Delete " .. name .. "?", "&Yes\n&No", 2) == 1 and store.delete(path) then
          p:find()
        end
      end,
    },
    win = {
      input = {
        keys = {
          ["<c-n>"] = { "notebook_new", mode = { "i", "n" } },
          ["<c-r>"] = { "notebook_rename", mode = { "i", "n" } },
          ["<c-x>"] = { "notebook_delete", mode = { "i", "n" } },
        },
      },
    },
  })
end

---Live ripgrep (regex) across all notes
M.grep = function()
  local picker = get_picker()
  if picker == "telescope" then
    require("telescope.builtin").live_grep({
      prompt_title = "Notebook grep",
      cwd = config().dir,
      attach_mappings = telescope_attach,
    })
    return
  elseif not require_snacks("grep") then
    return
  end

  Snacks.picker.grep({
    title = "Notebook grep",
    cwd = config().dir,
    confirm = confirm,
  })
end

---Fuzzy search every line of every note. ripgrep runs once for all
---non-blank lines, then the picker fuzzy-matches over them.
M.search = function()
  if not require_snacks("search") then
    return
  end
  Snacks.picker.grep({
    title = "Notebook search",
    cwd = config().dir,
    search = "\\S",
    live = false,
    confirm = confirm,
  })
end

---Sidebar file tree rooted at the notes dir. Uses the explorer's own
---confirm so notes open in the main window beside the tree.
---Without snacks, opens the directory itself (netrw, oil, ...).
M.tree = function()
  if get_picker() ~= "snacks" then
    vim.cmd.edit(vim.fn.fnameescape(config().dir))
    return
  end
  Snacks.explorer.open({
    title = "Notebook",
    cwd = config().dir,
  })
end

---Pick a tag, then list the notes tagged with it
M.tags = function()
  if not require_snacks("tags") then
    return
  end
  local tags = store.tags()
  if #tags == 0 then
    vim.notify("No tags found", vim.log.levels.INFO)
    return
  end
  vim.ui.select(tags, { prompt = "Tag:" }, function(tag)
    if not tag then
      return
    end
    Snacks.picker.grep({
      title = "Notebook #" .. tag,
      cwd = config().dir,
      search = "^tags:.*\\b" .. tag .. "\\b",
      live = false,
      confirm = confirm,
    })
  end)
end

return M
