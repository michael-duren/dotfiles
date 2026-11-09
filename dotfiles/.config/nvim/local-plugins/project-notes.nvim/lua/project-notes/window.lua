local M = {}

---@type number|nil
local win_id = nil

---@return ProjectNotesOpts
local function config()
  return require("project-notes").config
end

---Save a buffer if it has unsaved changes
---@param buf number
local function save(buf)
  if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modified then
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent write")
    end)
  end
end

M.close = function()
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    save(vim.api.nvim_win_get_buf(win_id))
    vim.api.nvim_win_close(win_id, true)
  end
  win_id = nil
end

---@param buf number
---@param title string
local function open_float(buf, title)
  -- Reuse the float if one is already open, just swap the buffer
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    save(vim.api.nvim_win_get_buf(win_id))
    vim.api.nvim_win_set_buf(win_id, buf)
    vim.api.nvim_win_set_config(win_id, { title = title, title_pos = "center" })
    vim.api.nvim_set_current_win(win_id)
    return
  end

  local window = config().window
  local width = math.floor(vim.o.columns * window.width)
  local height = math.floor(vim.o.lines * window.height)
  win_id = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = window.border,
    title = title,
    title_pos = "center",
  })
  vim.wo[win_id].winhighlight = "Normal:Normal,FloatBorder:FloatBorder"
  vim.wo[win_id].wrap = true
  vim.wo[win_id].linebreak = true
end

---Open a note using the configured strategy
---@param path string
---@param pos? number[] {line, col} to jump to
M.open = function(path, pos)
  local mode = config().open
  if mode == "float" then
    local buf = vim.fn.bufadd(path)
    vim.fn.bufload(buf)
    vim.bo[buf].buflisted = true
    local rel = vim.fn.fnamemodify(path, ":r")
    local root = config().dir .. "/"
    if rel:sub(1, #root) == root then
      rel = rel:sub(#root + 1)
    end
    local title = " " .. rel .. " "
    open_float(buf, title)
    vim.keymap.set("n", "q", M.close, { buffer = buf, nowait = true, desc = "Close note" })
  else
    local cmd = mode == "vsplit" and "vsplit" or "edit"
    vim.cmd(cmd .. " " .. vim.fn.fnameescape(path))
  end
  if pos then
    pcall(vim.api.nvim_win_set_cursor, 0, pos)
    vim.cmd("normal! zz")
  end
end

return M
