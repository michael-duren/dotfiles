return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({})

		-- Install parsers
		local parsers = {
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
			"gosum",
			"gowork",
			"css",
			"c_sharp",
			"typescript",
			"javascript",
			"json",
			"zig",
		}
		require("nvim-treesitter").install(parsers)

		-- Enable treesitter highlighting and indentation for all filetypes
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
