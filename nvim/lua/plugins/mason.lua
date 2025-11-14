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
				ensure_installed = {
					"netcoredbg",
					"delve",
					"lua_ls",
					"gopls",
					"csharp_ls",
					"csharpier",
					"zls",
					"html",
					"cssls",
					"tsserver",
					"lua-language-server",
					"xmlformatter",
					"csharpier",
					"prettier",
					"stylua",
					"bicep-lsp",
					"html-lsp",
					"eslint-lsp",
					"typescript-language-server",
					"json-lsp",
					"rust-analyzer",
					"tailwind-language-server",
					"roslyn",
					"rzls",
					"markdownlint-cli2",
					"markdown-toc",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {},
	},
}
