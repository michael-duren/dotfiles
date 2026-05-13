local utils = require("helpers.utils")

if utils.is_linux() or true then
	return {}
end

return {
	"shortcuts/no-neck-pain.nvim",
	opts = {
		width = 180,
		autocmds = {
			enableOnVimEnter = true,
		},
	},
}
