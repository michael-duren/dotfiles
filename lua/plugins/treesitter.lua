local utils = require("helpers.utils")

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = {
				"hyprlang",
				"vim",
				"lua",
				"vimdoc",
				"html",
				"css",
				"c_sharp",
				"razor",
				"go",
				"typescript",
				"javascript",
				"json",
				"markdown",
				"zig",
			},
			auto_install = not utils.isWindows(),
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
		})
	end,
}
