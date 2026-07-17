return {
	{
		"mason-org/mason.nvim",
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
		"mason-org/mason-lspconfig.nvim",
		lazy = false,
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			-- These servers are configured/started by hand (lua/lsp/ and
			-- plugins/vtsls.lua, plugins/roslyn.lua), so keep mason-lspconfig
			-- from enabling them a second time.
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
					"dockerls",
					"docker_compose_language_service",
					"helm_ls",
					"texlab",
					"terraformls",
				},
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		lazy = false,
		dependencies = { "mason-org/mason.nvim" },
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
				"dockerls",
				"docker_compose_language_service",
				"helm-ls",
				"texlab",
				"terraform-ls",
				-- dap
				"netcoredbg",
				"bash-debug-adapter",
				"codelldb",
				"delve",
				-- formatters / linters
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
