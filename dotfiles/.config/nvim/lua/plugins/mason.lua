return {
	{
		"williamboman/mason.nvim",
		lazy = false,
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
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			automatic_enable = {
				exclude = {
					"roslyn",
					"lua_ls",
					"gopls",
					"zls",
					"vtsls",
					"tailwindcss",
					"yamlls",
					"bashls",
					"clangd",
				},
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		lazy = false,
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				-- lsp
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
				"bashls",
				"vtsls",
				"vim-language-server",
				-- dap
				"netcoredbg",
				"bash-debug-adapter",
				"codelldb",
				"delve",
				-- formatters
				"prettierd",
				"prettier",
				"goimports",
				-- "csharpier",
				"stylua",
				"clang-format",
				-- test
				"gotestsum",
			},
		},
	},
}
