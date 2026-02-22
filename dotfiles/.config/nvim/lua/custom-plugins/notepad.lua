local M = {}

---@class NotepadOpts
---@field width? number Percentage of screen width (0.0-1.0)
---@field height? number Percentage of screen height (0.0-1.0)
---@field border? string Border style for floating window
---@field notes_dir? string Directory to store notes
---@field keymap? string|false Keymap to toggle notepad

local fmt = string.format

M.config = {
	width = 0.6,
	height = 0.7,
	border = "rounded",
	notes_dir = vim.fn.stdpath("data") .. "/notes",
	keymap = "<leader>nn",
}

-- Track the floating window state
---@type number|nil
local win_id = nil
---@type number|nil
local buf_id = nil

---Get the notes file path for the current project
---@return string The full path to the notes file
M.get_notes_path = function()
	local root = vim.fn.getcwd()
	local name = vim.fn.fnamemodify(root, ":t")
	local hash = vim.fn.sha256(root):sub(1, 8)
	vim.fn.mkdir(M.config.notes_dir, "p")
	return M.config.notes_dir .. "/" .. name .. "-" .. hash .. ".md"
end

---Create the floating window
---@return number win The window ID
---@return number buf The buffer number
local function create_float(buf)
	local width = math.floor(vim.o.columns * M.config.width)
	local height = math.floor(vim.o.lines * M.config.height)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = M.config.border,
		title = " repository notepad ",
		title_pos = "center",
	})

	vim.api.nvim_set_option_value("winblend", 0, { win = win })
	vim.api.nvim_set_option_value("winhighlight", "Normal:Normal,FloatBorder:FloatBorder", { win = win })

	return win, buf
end

---@param files string[]
M.select_and_delete_note = function(files)
	vim.ui.select(files, {
		prompt = "Select note to delete:",
		format_item = function(path)
			return vim.fn.fnamemodify(path, ":t:r")
		end,
	}, function(choice)
		if choice then
			if not vim.fn.filereadable(choice) then
				vim.notify(fmt("Chosen file: %s does not exist", choice), vim.log.levels.WARN)
				return
			end

			local result = vim.fn.delete(choice, "")
			if result == 0 then
				vim.notify(fmt("File: %s successfully deleted", choice), vim.log.levels.INFO)
			else
				vim.notify(fmt("Unable to delete file: %s", choice), vim.log.levels.ERROR)
			end
		end
	end)
end

---@param files string[]
M.select_and_open_note = function(files)
	vim.ui.select(files, {
		prompt = "Select note:",
		format_item = function(path)
			return vim.fn.fnamemodify(path, ":t:r")
		end,
	}, function(choice)
		if choice then
			-- Open selected note in float
			buf_id = vim.fn.bufnr(choice, true)
			vim.api.nvim_buf_call(buf_id, function()
				vim.cmd("edit " .. vim.fn.fnameescape(choice))
			end)
			buf_id = vim.fn.bufnr(choice)
			win_id = create_float(buf_id)
		end
	end)
end

---Toggle the notepad floating window
M.toggle = function()
	-- If window is open, close it
	if win_id and vim.api.nvim_win_is_valid(win_id) then
		vim.api.nvim_win_close(win_id, true)
		win_id = nil
		return
	end

	local notes_path = M.get_notes_path()

	-- Reuse existing buffer if it's still valid
	if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
		win_id = create_float(buf_id)
	else
		-- Create a new buffer and load the file
		buf_id = vim.api.nvim_create_buf(false, false)
		if vim.fn.filereadable(notes_path) == 1 then
			vim.api.nvim_buf_call(buf_id, function()
				vim.cmd("edit " .. vim.fn.fnameescape(notes_path))
			end)
			buf_id = vim.fn.bufnr(notes_path)
		else
			vim.api.nvim_buf_set_name(buf_id, notes_path)
			vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf_id })
		end
		win_id = create_float(buf_id)
	end

	-- Close on q or Esc
	local close = function()
		-- Auto-save before closing
		if vim.api.nvim_get_option_value("modified", { buf = buf_id }) then
			vim.api.nvim_buf_call(buf_id, function()
				vim.cmd("silent write")
			end)
		end
		if win_id and vim.api.nvim_win_is_valid(win_id) then
			vim.api.nvim_win_close(win_id, true)
		end
		win_id = nil
	end

	vim.keymap.set("n", "q", close, { buffer = buf_id, nowait = true })
	vim.keymap.set("n", "<Esc>", close, { buffer = buf_id, nowait = true })
end

---List all note files
---@return string[]
M.list_files = function()
	local notes_dir = M.config.notes_dir
	if vim.fn.isdirectory(notes_dir) == 0 then
		vim.notify("No notes found", vim.log.levels.INFO)
		return {}
	end

	return vim.fn.globpath(notes_dir, "*.md", false, true)
end

M.list = function()
	local files = M.list_files()
	if #files == 0 then
		vim.notify("No notes found", vim.log.levels.INFO)
		return
	end
	M.select_and_open_note(files)
end

M.delete = function()
	local files = M.list_files()
	if #files == 0 then
		vim.notify("No notes to delete", vim.log.levels.WARN)
		return
	end
	M.select_and_delete_note(files)
end

---@param opts? NotepadOpts
M.setup = function(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	vim.api.nvim_create_user_command("Notepad", function()
		M.toggle()
	end, { desc = "Toggle project notepad" })

	vim.api.nvim_create_user_command("NotepadList", function()
		M.list()
	end, { desc = "List all notes" })

	vim.api.nvim_create_user_command("NotepadDelete", function()
		M.delete()
	end, { desc = "Delete a note" })

	if M.config.keymap then
		vim.api.nvim_create_autocmd("VimEnter", {
			once = true,
			callback = function()
				vim.keymap.set("n", M.config.keymap, M.toggle, { desc = "Toggle project notepad" })
			end,
		})
	end
end

return M
