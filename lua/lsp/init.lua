vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = {
			buffer = ev.buf,
		}
		vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>di", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>fr", function()
			require("snacks").picker.lsp_references()
		end, opts)
	end,
})
require("lsp.gopls")
require("lsp.zls")
-- require("lsp.tsserver")
require("lsp.luals")
require("vtsls.lua")
