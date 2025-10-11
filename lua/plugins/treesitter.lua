local utils = require("helpers.utils")

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"go",
			"gomod",
			"gowork",
			"gosum",
			"hyprlang",
			"css",
			"c_sharp",
			"razor",
			"typescript",
			"javascript",
			"json",
			"zig",
		},
		auto_install = not utils.is_windows(),
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
	},
}
