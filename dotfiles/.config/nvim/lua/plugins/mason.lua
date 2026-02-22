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
				"netcoredbg",
			},
			automatic_enable = {
				exclude = {
					"roslyn",
					"lua_ls",
					"gopls",
					"zls",
					"vtsls",
					"tailwindcss",
					"yamlls",
				},
			},
		},
	},
}
