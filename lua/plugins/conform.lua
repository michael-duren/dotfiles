return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			-- JavaScript/TypeScript
			typescript = { "prettierd", "prettier" },
			typescriptreact = { "prettierd", "prettier" },
			javascript = { "prettierd", "prettier" },
			javascriptreact = { "prettierd", "prettier" },

			-- Web files
			json = { "prettier" },
			jsonc = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			html = { "prettier" },
			markdown = { "prettier" },
			yaml = { "prettier" },
			vue = { "prettier" },
			svelte = { "prettier" },

			go = { "goimports", "gofmt" },
			cs = { "csharpier" },
			lua = { "stylua" },
		},

		format_on_save = {
			timeout_ms = 1500,
			lsp_fallback = true,
		},
	},
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
}
