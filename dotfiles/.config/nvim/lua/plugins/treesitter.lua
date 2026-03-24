return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- Register the third-party VCL parser (not in the official nvim-treesitter list).
		-- ntsk/tree-sitter-vcl is the only grammar with Neovim-specific documentation.
		-- The new nvim-treesitter main branch uses a plain Lua table; there is no get_parser_configs().
		local parsers = require("nvim-treesitter.parsers")
		parsers.vcl = {
			install_info = {
				url = "https://github.com/ntsk/tree-sitter-vcl",
				branch = "main",
				queries = "queries",
			},
		}
		-- Associate the "vcl" treesitter parser with the "vcl" filetype
		vim.treesitter.language.register("vcl", "vcl")

		-- Install parsers
		require("nvim-treesitter")
			.install({
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
				-- "vcl",
			})
			:wait(300000) -- wait 5 min max

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

					-- Enable folding
					vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo[0][0].foldmethod = "expr"
					vim.wo[0][0].foldlevel = 99 -- Start with all folds open
				end
			end,
		})
	end,
}
