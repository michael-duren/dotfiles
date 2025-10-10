local utils = require("helpers.utils")

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = {
			buffer = ev.buf,
		}
		local lspMaps = {
			-- LSP - Basic Navigation
			{
				key = "gd",
				command = "<cmd>lua vim.lsp.buf.definition()<CR>",
				opts = { desc = "LSP go to definition" },
			},
			{
				key = "gD",
				command = "<cmd>lua vim.lsp.buf.declaration()<CR>",
				opts = { desc = "LSP go to declaration" },
			},
			{
				key = "gr",
				command = "<cmd>lua vim.lsp.buf.references()<CR>",
				opts = { desc = "LSP find references" },
			},
			{
				key = "gi",
				command = "<cmd>lua vim.lsp.buf.implementation()<CR>",
				opts = { desc = "LSP go to implementation" },
			},
			{
				key = "K",
				command = "<cmd>lua vim.lsp.buf.hover()<CR>",
				opts = { desc = "LSP hover" },
			},

			-- LSP - Leader Menu
			{
				key = "<leader>lf",
				command = "<cmd>lua vim.lsp.buf.format()<CR>",
				opts = { desc = "LSP format" },
			},
			{
				key = "<leader>lr",
				command = "<cmd>lua vim.lsp.buf.rename()<CR>",
				opts = { desc = "Rename" },
			},
			{
				key = "<leader>la",
				command = "<cmd>lua vim.lsp.buf.code_action()<CR>",
				opts = { desc = "Code action" },
			},
			{
				key = "<leader>ll",
				command = "<cmd>lua vim.lsp.codelens.run()<cr>",
				opts = { desc = "CodeLens Action" },
			},
			{
				key = "<leader>li",
				command = "<cmd>LspInfo<cr>",
				opts = { desc = "Info" },
			},
			{
				key = "<leader>lI",
				command = "<cmd>Mason<cr>",
				opts = { desc = "Mason Info" },
			},
			{
				key = "<leader>lq",
				command = "<cmd>lua vim.diagnostic.setloclist()<cr>",
				opts = { desc = "Quickfix" },
			},
			{
				key = "<leader>ls",
				command = "<cmd>Telescope lsp_document_symbols<cr>",
				opts = { desc = "Document Symbols" },
			},
			{
				key = "<leader>lS",
				command = "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
				opts = { desc = "Workspace Symbols" },
			},
			{
				key = "<leader>le",
				command = "<cmd>Telescope quickfix<cr>",
				opts = { desc = "Telescope Quickfix" },
			},
			{
				key = "<leader>R",
				command = "<cmd>LspRestart<CR>",
				opts = { desc = "Restart LSP" },
			},

			-- Diagnostics
			{
				key = "<leader>kj",
				command = function()
					vim.diagnostic.jump({ count = 1 })
				end,
				opts = {
					desc = "go to next error",
				},
			},
			{
				key = "<leader>kk",
				command = function()
					vim.diagnostic.jump({ count = -1 })
				end,
				opts = {
					desc = "go to previous error",
				},
			},
			{
				key = "<leader>ca",
				command = "<cmd>lua vim.lsp.buf.code_action()<CR>",
				opts = { desc = "Code action" },
			},
		}
		utils.mapKeys(lspMaps)
	end,
})
require("lsp.gopls")
require("lsp.zls")
require("lsp.luals")
require("lsp.tailwind")
require("lsp.roslyn")
