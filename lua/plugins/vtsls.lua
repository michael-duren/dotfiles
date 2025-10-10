return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		require("mason-lspconfig").setup({
			ensure_installed = { "vtsls" },
		})

		vim.lsp.config.vtsls = {
			cmd = { "vtsls", "--stdio" },
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
			settings = {
				typescript = {
					inlayHints = {
						parameterNames = { enabled = "literals" },
						parameterTypes = { enabled = true },
						variableTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
					},
					updateImportsOnFileMove = "always",
				},
				javascript = {
					inlayHints = {
						parameterNames = { enabled = "literals" },
						parameterTypes = { enabled = true },
						variableTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
					},
					updateImportsOnFileMove = "always",
				},
			},
		}

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			callback = function(ev)
				vim.lsp.start({
					name = "vtsls",
					cmd = { "vtsls", "--stdio" },
					root_dir = vim.fs.root(ev.buf, { "package.json", "tsconfig.json", "jsconfig.json", ".git" }),
				})
			end,
		})
	end,
}
