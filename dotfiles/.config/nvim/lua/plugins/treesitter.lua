return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master", -- Use master for ensure_installed
	lazy = false,
	build = ":TSUpdate",
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
			"gosum", -- "gowork" if it works
			"gowork",
			"css",
			"c_sharp",
			"typescript",
			"javascript",
			"json",
			"zig",
		},
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = { enable = true },
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
