local M = {}

M.yank_fileinfo = function()
	if vim.fn.mode():match("[vV\22]") then
		vim.cmd('execute "normal! \\<Esc>"')
	end

	local start_line = vim.fn.getpos("'<")[2]
	local end_line = vim.fn.getpos("'>")[2]

	if start_line == 0 or end_line == 0 then
		vim.notify("No visual selection found", vim.log.levels.WARN)
		return
	end

	local abs_path = vim.api.nvim_buf_get_name(0)
	if abs_path == "" then
		vim.notify("Buffer has no file name", vim.log.levels.WARN)
		return
	end
	local path = vim.fn.fnamemodify(abs_path, ":.")

	local ref
	if start_line == end_line then
		ref = string.format("%s:%d", path, start_line)
	else
		ref = string.format("%s:%d-%d", path, start_line, end_line)
	end

	vim.fn.setreg("+", ref)
	vim.fn.setreg('"', ref)
	vim.notify("Yanked: " .. ref, vim.log.levels.INFO)
end

M.setup = function()
	vim.api.nvim_create_user_command("YankFileInfo", function()
		M.yank_fileinfo()
	end, {
		range = true,
		desc = "Yank file path with selected line range",
	})

	vim.keymap.set("x", "Y", function()
		M.yank_fileinfo()
	end, { desc = "Yank file path with line range" })
end

return M
