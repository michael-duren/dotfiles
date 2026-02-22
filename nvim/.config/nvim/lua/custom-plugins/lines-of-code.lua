local M = {}

---@param filetype string The file extension (e.g., 'go', 'lua', 'js')
---@return number|nil The number of lines of code, or nil if failed
M.count_lines_of_code = function(filetype)
	-- Validate input
	if not filetype or filetype == "" then
		vim.notify("Filetype cannot be empty", vim.log.levels.ERROR)
		return nil
	end

	local cmd = string.format([[find . -type f -name "*.%s" -exec cat {} + 2>/dev/null | wc -l]], filetype)
	local output = vim.fn.system(cmd)

	if vim.v.shell_error ~= 0 then
		vim.notify(string.format("Failed to count %s lines", filetype), vim.log.levels.ERROR)
		return nil
	end

	local line_count = tonumber(vim.trim(output))
	if not line_count then
		vim.notify("Failed to parse line count", vim.log.levels.ERROR)
		return nil
	end

	if line_count == 0 then
		vim.notify(string.format("No .%s files found", filetype), vim.log.levels.WARN)
	else
		vim.notify(string.format("Total %s lines: %s", filetype, vim.fn.printf("%'d", line_count)), vim.log.levels.INFO)
	end

	return line_count
end

M.setup = function()
	vim.api.nvim_create_user_command("CountLines", function(args)
		M.count_lines_of_code(args.args)
	end, {
		nargs = 1,
		desc = "Count lines of code by file extension",
	})
end

return M
