local M = {}
local git = require("project-notes.git")
local store = require("project-notes.store")

---@return ProjectNotesOpts
local function config()
  return require("project-notes").config
end

---@class ProjectNote
---@field path string
---@field filename string
---@field title string
---@field created number
---@field modified number

-- Get the absolute notes directory for the current project
---@return string|nil dir e.g. "~/notes/projects/dotfiles"
---@return ProjectInfo|nil project
function M.get_project_dir()
  local project = git.get_project()
  if not project then
    return nil
  end
  return table.concat({ config().dir, config().projects_dir, project.folder }, "/"), project
end

---@param path string
---@return ProjectNote
local function read_note(path)
  local filename = vim.fn.fnamemodify(path, ":t")
  local stat = vim.uv.fs_stat(path)
  local modified = stat and stat.mtime.sec or 0
  local fm = store.frontmatter(path)

  -- Notes created before the move to ~/notes are named "<timestamp>_<title>.md"
  local timestamp_str, legacy_title = filename:match("^(%d+)_(.*)%.md$")
  local title = fm.title or (legacy_title or vim.fn.fnamemodify(filename, ":r")):gsub("[_-]", " ")

  local created = tonumber(timestamp_str)
  if not created and fm.created then
    local y, m, d = fm.created:match("^(%d+)-(%d+)-(%d+)")
    if y then
      created = os.time({ year = tonumber(y), month = tonumber(m), day = tonumber(d), hour = 0 })
    end
  end

  return {
    path = path,
    filename = filename,
    title = title,
    created = created or modified,
    modified = modified,
  }
end

-- Get all note files in the project directory
---@return ProjectNote[]
function M.get_notes()
  local notes_dir = M.get_project_dir()
  if not notes_dir then
    return {}
  end

  local notes = {}
  for _, file in ipairs(vim.fn.glob(notes_dir .. "/*" .. config().ext, false, true)) do
    table.insert(notes, read_note(file))
  end

  local sort_by = config().sort_by
  if sort_by == "created" then
    table.sort(notes, function(a, b)
      return a.created > b.created
    end)
  elseif sort_by == "modified" then
    table.sort(notes, function(a, b)
      return a.modified > b.modified
    end)
  elseif sort_by == "title" then
    table.sort(notes, function(a, b)
      return a.title < b.title
    end)
  end

  return notes
end

-- Create a new note
function M.create_note()
  local notes_dir, project = M.get_project_dir()
  if not notes_dir or not project then
    return
  end

  vim.ui.input({ prompt = "Note title: " }, function(title)
    if not title or vim.trim(title) == "" then
      return
    end
    -- store.create treats "/" as a subdirectory separator
    local path = store.create((title:gsub("/", "-")), project.name, notes_dir)
    if path then
      require("project-notes.window").open(path)
      vim.notify("Created note: " .. title, vim.log.levels.INFO)
    end
  end)
end

-- Delete a note
---@param note ProjectNote
---@param on_done? fun()
function M.delete_note(note, on_done)
  vim.ui.select({ "Yes", "No" }, {
    prompt = "Delete note '" .. note.title .. "'?",
  }, function(choice)
    if choice == "Yes" and store.delete(note.path) then
      vim.notify("Deleted note: " .. note.title, vim.log.levels.INFO)
      if on_done then
        on_done()
      end
    end
  end)
end

-- Open a note for editing
---@param note ProjectNote
function M.edit_note(note)
  require("project-notes.window").open(note.path)
end

-- Get project metadata for the browser header
---@return { name: string, remote_url: string }|nil
function M.get_project_meta()
  local project = git.get_project()
  if not project then
    return nil
  end
  return { name = project.name, remote_url = project.remote_url or "" }
end

return M
