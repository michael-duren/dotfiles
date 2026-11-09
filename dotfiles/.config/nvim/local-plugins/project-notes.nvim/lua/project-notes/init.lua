local M = {}

---@class ProjectNotesWindowOpts
---@field width? number Float width as percentage of screen (0.0-1.0)
---@field height? number Float height as percentage of screen (0.0-1.0)
---@field border? string Float border style

---@class ProjectNotesOpts
---@field dir? string Root directory for all notes (notebook + project notes)
---@field projects_dir? string Subdirectory of `dir` holding one folder per project
---@field daily_dir? string Subdirectory of `dir` for daily notes
---@field open? "float"|"edit"|"vsplit" How to open notes
---@field template? fun(title: string, project?: string): string[] Lines for a new note
---@field ext? string Note file extension
---@field window? ProjectNotesWindowOpts
---@field sort_by? "modified"|"created"|"title" Sort order in the project browser
---@field mappings? table<string, string> Keys inside the project browser
---@field picker? "auto"|"snacks"|"telescope"

M.config = {
  dir = vim.fn.expand("~/notes"),
  projects_dir = "projects",
  daily_dir = "daily",
  open = "float",
  template = nil,
  ext = ".md",
  window = {
    width = 0.8,
    height = 0.8,
    border = "rounded",
  },
  sort_by = "modified",
  mappings = {
    new_note = "n",
    delete_note = "d",
    edit_note = "<CR>",
    close = "q",
  },
  -- Picker preference: "auto", "snacks", "telescope"
  -- "auto" will use snacks if available, otherwise telescope
  picker = "auto",
}

---Directory used before notes moved under `dir` (sha256-named project folders)
M.legacy_dir = vim.fn.stdpath("data") .. "/project-notes"

---Create a notebook note and open it. Prompts for a title when none is given.
---Titles may include subdirectories: "work/K8s debugging".
---@param title? string
M.new = function(title)
  local function create(t)
    local path = require("project-notes.store").create(t)
    if path then
      require("project-notes.window").open(path)
    end
  end
  if title and vim.trim(title) ~= "" then
    create(title)
  else
    vim.ui.input({ prompt = "New note: " }, function(input)
      if input then
        create(input)
      end
    end)
  end
end

M.daily = function()
  require("project-notes.window").open(require("project-notes.store").daily())
end

M.find = function()
  require("project-notes.picker").find()
end

M.grep = function()
  require("project-notes.picker").grep()
end

M.search = function()
  require("project-notes.picker").search()
end

M.tags = function()
  require("project-notes.picker").tags()
end

M.tree = function()
  require("project-notes.picker").tree()
end

local subcommands = {
  find = M.find,
  grep = M.grep,
  search = M.search,
  new = M.new,
  daily = M.daily,
  tags = M.tags,
  tree = M.tree,
}

---@param opts? ProjectNotesOpts
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  M.config.dir = vim.fn.expand(M.config.dir)
  vim.fn.mkdir(M.config.dir, "p")

  vim.api.nvim_create_user_command("ProjectNotes", function()
    require("project-notes.ui").open_browser()
  end, {})

  vim.api.nvim_create_user_command("ProjectNotesNew", function()
    require("project-notes.notes").create_note()
  end, {})

  vim.api.nvim_create_user_command("ProjectNotesFind", function()
    require("project-notes.picker").find_notes()
  end, {})

  vim.api.nvim_create_user_command("ProjectNotesMigrate", function()
    require("project-notes.migrate").run()
  end, { desc = "Move notes from the old sha256 folders into the notes dir" })

  vim.api.nvim_create_user_command("Notebook", function(cmd)
    local sub = cmd.fargs[1] or "find"
    local fn = subcommands[sub]
    if not fn then
      vim.notify("Notebook: unknown subcommand " .. sub, vim.log.levels.ERROR)
      return
    end
    if sub == "new" then
      fn(table.concat(vim.list_slice(cmd.fargs, 2), " "))
    else
      fn()
    end
  end, {
    nargs = "*",
    desc = "Global notebook",
    complete = function(_, line)
      if #vim.split(line, "%s+") > 2 then
        return {}
      end
      return vim.tbl_keys(subcommands)
    end,
  })

  local migrate = require("project-notes.migrate")
  if migrate.pending() then
    vim.schedule(function()
      -- A :ProjectNotesMigrate run before this fires already handled it
      if not migrate.pending() then
        return
      end
      vim.notify(
        "project-notes: found notes in "
          .. M.legacy_dir
          .. ". Run :ProjectNotesMigrate to move them into "
          .. M.config.dir,
        vim.log.levels.WARN
      )
    end)
  end
end

return M
