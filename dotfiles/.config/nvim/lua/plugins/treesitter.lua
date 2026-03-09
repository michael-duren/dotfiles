return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- Install parsers
		require("nvim-treesitter").install({
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
			"dockerfile",
			"yaml",
			"helm",
		})

		-- Enable treesitter features for all installed parsers
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function()
				local ok, _ = pcall(vim.treesitter.start)
				if ok then
					-- Enable syntax highlighting
					vim.treesitter.start()

					-- Enable indentation
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
