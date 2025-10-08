return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
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
        "lua",
        "go",
        "typescript",
         "zig" 
     },
			auto_install = true,
			highlight = {
				enable = true,
			},
		})
	end,
}
