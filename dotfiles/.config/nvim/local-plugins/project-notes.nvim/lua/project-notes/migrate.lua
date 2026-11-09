-- Move notes from the old layout
--   stdpath("data")/project-notes/<sha256>/<timestamp>_<title>.md (+ meta.json)
-- into
--   <dir>/<projects_dir>/<repo>/<slug>.md
local M = {}

local fmt = string.format
local store = require("project-notes.store")

---@return ProjectNotesOpts
local function config()
  return require("project-notes").config
end

---@return string[] Legacy project folders that still contain notes
local function legacy_project_dirs()
  local root = require("project-notes").legacy_dir
  return vim.tbl_filter(function(dir)
    return #vim.fn.glob(dir .. "/*.md", false, true) > 0
  end, vim.fn.glob(root .. "/*", false, true))
end

---@return boolean
M.pending = function()
  return #legacy_project_dirs() > 0
end

---Folder name for a legacy project, from its meta.json
---@param dir string
---@return string folder
---@return string name
local function project_for(dir)
  local ok, meta = pcall(function()
    return vim.fn.json_decode(vim.fn.readfile(dir .. "/meta.json"))
  end)
  if not ok or type(meta) ~= "table" then
    local hash = vim.fn.fnamemodify(dir, ":t"):sub(1, 8)
    return "unknown-" .. hash, "unknown"
  end
  local name, repo
  if meta.remote_url and meta.remote_url ~= "" then
    name, repo = require("project-notes.git").parse_remote(meta.remote_url)
  else
    name = meta.name or "unknown"
    repo = name
  end
  return (repo:gsub("[^%w%.%-_]", "-")), name
end

M.run = function()
  local dirs = legacy_project_dirs()
  if #dirs == 0 then
    vim.notify("project-notes: nothing to migrate", vim.log.levels.INFO)
    return
  end

  local moved, failed = 0, {}
  for _, dir in ipairs(dirs) do
    local folder, name = project_for(dir)
    local dest_dir = table.concat({ config().dir, config().projects_dir, folder }, "/")
    vim.fn.mkdir(dest_dir, "p")

    for _, file in ipairs(vim.fn.glob(dir .. "/*.md", false, true)) do
      local filename = vim.fn.fnamemodify(file, ":t")
      local ts, raw_title = filename:match("^(%d+)_(.*)%.md$")
      local title = raw_title and raw_title:gsub("_", " ") or vim.fn.fnamemodify(filename, ":r")
      local dest = fmt("%s/%s%s", dest_dir, store.slugify(title), config().ext)
      if vim.fn.filereadable(dest) == 1 then
        dest = dest_dir .. "/" .. filename
      end

      local lines = vim.fn.readfile(file)
      if lines[1] ~= "---" then
        local header = {
          "---",
          "title: " .. title,
          "created: " .. os.date("%Y-%m-%d", tonumber(ts) or os.time()),
          "project: " .. name,
          "tags: []",
          "---",
          "",
        }
        lines = vim.list_extend(header, lines)
      end

      if vim.fn.filereadable(dest) == 0 and vim.fn.writefile(lines, dest) == 0 and vim.fn.delete(file) == 0 then
        moved = moved + 1
      else
        table.insert(failed, file)
      end
    end

    -- Drop meta.json and the folder once every note is out
    if #vim.fn.glob(dir .. "/*.md", false, true) == 0 then
      vim.fn.delete(dir, "rf")
    end
  end

  local msg = fmt("project-notes: moved %d note(s) into %s/%s", moved, config().dir, config().projects_dir)
  if #failed > 0 then
    msg = msg .. fmt("\nCould not move %d note(s):\n%s", #failed, table.concat(failed, "\n"))
  end
  vim.notify(msg, #failed > 0 and vim.log.levels.WARN or vim.log.levels.INFO)
end

return M
