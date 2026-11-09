local M = {}

-- Find the .git directory starting from the given path
local function find_git_dir(start_path)
  local path = start_path or vim.fn.getcwd()

  -- Handle empty buffer case
  if path == "" then
    path = vim.fn.getcwd()
  end

  -- If path is a file, get its directory
  if vim.fn.isdirectory(path) == 0 then
    path = vim.fn.fnamemodify(path, ":h")
  end

  -- Walk up the directory tree
  while path ~= "/" do
    local git_path = path .. "/.git"
    if vim.fn.isdirectory(git_path) == 1 or vim.fn.filereadable(git_path) == 1 then
      return git_path
    end
    path = vim.fn.fnamemodify(path, ":h")
  end

  return nil
end

-- Read the remote origin URL from .git/config
local function get_remote_url(git_dir)
  local config_path = git_dir .. "/config"

  -- Handle git worktree case (.git is a file, not a directory)
  if vim.fn.isdirectory(git_dir) == 0 and vim.fn.filereadable(git_dir) == 1 then
    local git_file = vim.fn.readfile(git_dir)
    if #git_file > 0 then
      local gitdir_line = git_file[1]
      local actual_git_dir = gitdir_line:match("gitdir: (.*)")
      if actual_git_dir then
        -- Make it absolute if it's relative
        if not actual_git_dir:match("^/") then
          local parent = vim.fn.fnamemodify(git_dir, ":h")
          actual_git_dir = parent .. "/" .. actual_git_dir
        end
        config_path = actual_git_dir .. "/config"
      end
    end
  end

  if vim.fn.filereadable(config_path) == 0 then
    return nil
  end

  local config = vim.fn.readfile(config_path)
  local in_remote_origin = false

  for _, line in ipairs(config) do
    if line:match('%[remote "origin"%]') then
      in_remote_origin = true
    elseif line:match("^%[") then
      in_remote_origin = false
    elseif in_remote_origin then
      local url = line:match("url%s*=%s*(.*)")
      if url then
        return vim.trim(url)
      end
    end
  end

  return nil
end

-- Split a remote URL into its "owner/repo" display name and "repo" folder name.
-- Handles https (https://github.com/owner/repo.git) and scp-style ssh
-- (git@github.com:owner/repo.git) remotes.
local function parse_remote(url)
  local path = url:gsub("%.git/?$", ""):gsub("/$", "")
  local repo = path:match("([^/:]+)$")
  local owner_repo = path:match("([^/:]+/[^/:]+)$") or repo
  return owner_repo, repo
end

---@class ProjectInfo
---@field name string Display name ("owner/repo", or the directory name without a remote)
---@field folder string Folder name under `projects_dir` (the repo name, filename-safe)
---@field remote_url? string

-- Get the project for the current buffer (or cwd), identified by its git repo
---@return ProjectInfo|nil
function M.get_project()
  local git_dir = find_git_dir(vim.fn.expand("%:p"))

  if not git_dir then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
    return nil
  end

  local remote_url = get_remote_url(git_dir)
  local name, repo
  if remote_url then
    name, repo = parse_remote(remote_url)
  else
    name = vim.fn.fnamemodify(git_dir, ":h:t")
    repo = name
  end

  return {
    name = name,
    folder = repo:gsub("[^%w%.%-_]", "-"),
    remote_url = remote_url,
  }
end

M.parse_remote = parse_remote

return M
