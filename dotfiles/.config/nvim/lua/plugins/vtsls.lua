-- vtsls is installed by mason-tool-installer and excluded from mason-lspconfig's
-- automatic_enable (see plugins/mason.lua), so we define and enable it here
-- with the native vim.lsp.config API. Do NOT call mason-lspconfig setup() again
-- in this file — a second setup() would clobber the opts from plugins/mason.lua.
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
	},
	config = function()
		vim.lsp.config("vtsls", {
			cmd = { "vtsls", "--stdio" },
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
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
		})
		vim.lsp.enable("vtsls")
	end,
}
