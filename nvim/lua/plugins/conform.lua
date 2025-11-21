local utils = require("helpers.utils")

local timeout_ms = 1500
if utils.is_windows() then
	timeout_ms = 2000
end

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
			astro = { "prettier" },

			go = { "goimports", "gofmt" },
			cs = { "csharpier" },
			lua = { "stylua" },
			razor = { "html" },
			cshtml = { "html" },
		},

		format_on_save = {
			timeout_ms = timeout_ms,
			lsp_fallback = true,
		},
		-- formatters = {
		-- 	csharpier = {
		-- 		command = "csharpier",
		-- 		args = { "--write-stdout" },
		-- 		stdin = true,
		-- 	},
		-- },
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
