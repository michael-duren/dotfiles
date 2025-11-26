return {
	{
		"williamboman/mason.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("mason").setup({
				PATH = "prepend",
				registries = {
					-- additional registries required for rosyln
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			ensure_installed = {
				"lua_ls",
				"gopls",
				"zls",
				"html",
				"cssls",
				"jsonls",
				"yamlls",
				"tailwindcss",
				"eslint",
				"astro",
				"marksman",
			},
			automatic_enable = {
				exclude = {
					"roslyn", -- Custom config in roslyn.lua
					"lua_ls", -- Custom config in lsp/luals.lua
					"gopls", -- Custom config in lsp/gopls.lua
					"zls", -- Custom config in lsp/zls.lua
					"vtsls", -- Custom config in vtsls.lua
					"tailwindcss", -- Custom config in lsp/web.lua
				},
			},
		},
	},
}
