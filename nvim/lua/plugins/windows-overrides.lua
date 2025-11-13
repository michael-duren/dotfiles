local utils = require("helpers.utils")

if not utils.is_windows() then
	return {}
end

return {
	{ "folke/noice.nvim", enabled = false },
	-- { "folke/todo-comments.nvim", enabled = false },
	{ "zaldih/themery.nvim", enabled = false },
	{ "CopilotC-Nvim/CopilotChat.nvim", enabled = false },
}
