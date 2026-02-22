local M = {}

local diagnostic_goto = function(next, severity)
	return function()
		vim.diagnostic.jump({
			count = (next and 1 or -1) * vim.v.count1,
			severity = severity and vim.diagnostic.severity[severity] or nil,
			float = true,
		})
	end
end

M.goto_next = diagnostic_goto(true)
M.goto_prev = diagnostic_goto(false)
M.goto_next_error = diagnostic_goto(true, "ERROR")
M.goto_prev_error = diagnostic_goto(false, "ERROR")
M.underline = function()
	vim.diagnostic.config({ underline = not vim.diagnostic.config().underline })
end
M.current_line = function()
	vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
end
M.line_diagnostics = function()
	vim.diagnostic.open_float()
end

return M
