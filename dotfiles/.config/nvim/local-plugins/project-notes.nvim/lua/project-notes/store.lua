local M = {}

local fmt = string.format

---@return ProjectNotesOpts
local function config()
  return require("project-notes").config
end

---Turn a title into a filename-safe slug
---@param title string
---@return string
M.slugify = function(title)
  local slug = title:lower():gsub("[^%w%s%-_]", ""):gsub("[%s_]+", "-"):gsub("%-+", "-"):gsub("^%-", ""):gsub("%-$", "")
  return slug
end

---Resolve a title like "work/K8s debugging" to an absolute note path
---@param title string
---@param root? string Directory the title is relative to (default: the notes dir)
---@return string path
---@return string name Title without the subdirectory
M.path_for = function(title, root)
  local subdir, name = title:match("^(.*)/([^/]+)$")
  if not subdir then
    subdir, name = nil, title
  end
  local dir = root or config().dir
  if subdir then
    local parts = vim.tbl_map(M.slugify, vim.split(subdir, "/", { trimempty = true }))
    dir = dir .. "/" .. table.concat(parts, "/")
  end
  return fmt("%s/%s%s", dir, M.slugify(name), config().ext), vim.trim(name)
end

---Default note template
---@param title string
---@param project? string
---@return string[]
M.default_template = function(title, project)
  local lines = {
    "---",
    "title: " .. title,
    "created: " .. os.date("%Y-%m-%d"),
  }
  if project then
    table.insert(lines, "project: " .. project)
  end
  vim.list_extend(lines, {
    "tags: []",
    "---",
    "",
    "# " .. title,
    "",
  })
  return lines
end

---Create a note (if missing) and return its path
---@param title string May include subdirectories relative to `root`
---@param project? string Project name recorded in the frontmatter
---@param root? string Directory to create the note in (default: the notes dir)
---@return string|nil path
M.create = function(title, project, root)
  title = vim.trim(title or "")
  if title == "" then
    return nil
  end
  local path, name = M.path_for(title, root)
  if vim.fn.filereadable(path) == 0 then
    vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
    local template = config().template or M.default_template
    vim.fn.writefile(template(name, project), path)
  end
  return path
end

---Path to today's daily note, created if missing
---@return string
M.daily = function()
  local date = os.date("%Y-%m-%d")
  local path = fmt("%s/%s/%s%s", config().dir, config().daily_dir, date, config().ext)
  if vim.fn.filereadable(path) == 0 then
    vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
    vim.fn.writefile({ "# " .. date, "", "" }, path)
  end
  return path
end

---Rename a note, keeping it in the same directory. Loaded buffers follow the file.
---@param path string
---@param new_title string
---@return string|nil new_path
M.rename = function(path, new_title)
  local new_path = vim.fn.fnamemodify(path, ":h") .. "/" .. M.slugify(new_title) .. config().ext
  if vim.fn.filereadable(new_path) == 1 then
    vim.notify(fmt("Note already exists: %s", new_path), vim.log.levels.ERROR)
    return nil
  end
  if vim.fn.rename(path, new_path) ~= 0 then
    vim.notify(fmt("Unable to rename: %s", path), vim.log.levels.ERROR)
    return nil
  end
  local buf = vim.fn.bufnr(path)
  if buf ~= -1 then
    vim.api.nvim_buf_set_name(buf, new_path)
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent! write!")
    end)
  end
  return new_path
end

---Delete a note and wipe its buffer
---@param path string
---@return boolean
M.delete = function(path)
  if vim.fn.delete(path) ~= 0 then
    vim.notify(fmt("Unable to delete: %s", path), vim.log.levels.ERROR)
    return false
  end
  local buf = vim.fn.bufnr(path)
  if buf ~= -1 then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  return true
end

---Read the `title:` and `created:` frontmatter fields of a note
---@param path string
---@return { title?: string, created?: string }
M.frontmatter = function(path)
  local ok, lines = pcall(vim.fn.readfile, path, "", 20)
  if not ok or lines[1] ~= "---" then
    return {}
  end
  local fields = {}
  for i = 2, #lines do
    if lines[i] == "---" then
      break
    end
    local key, value = lines[i]:match("^(%w+):%s*(.-)%s*$")
    if key then
      fields[key] = value
    end
  end
  return fields
end

---Collect tags from `tags: [a, b]` frontmatter lines across all notes
---@return string[]
M.tags = function()
  local lines = vim.fn.systemlist({ "rg", "--no-filename", "--no-line-number", "-o", "^tags:.*$", config().dir })
  local seen, tags = {}, {}
  for _, line in ipairs(lines) do
    for tag in line:gsub("^tags:", ""):gmatch("[%w%-_/]+") do
      if not seen[tag] then
        seen[tag] = true
        table.insert(tags, tag)
      end
    end
  end
  table.sort(tags)
  return tags
end

return M
