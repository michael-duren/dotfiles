return {
	"lervag/vimtex",
	lazy = false, -- vimtex docs say don't lazy-load
	ft = { "tex", "plaintex", "latex" },
	init = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_quickfix_mode = 0 -- don't auto-open quickfix on warnings
		vim.g.vimtex_mappings_enabled = 1
		vim.g.vimtex_indent_enabled = 1
		vim.g.vimtex_syntax_conceal_disable = 1 -- proofs read better with raw source
	end,
}
