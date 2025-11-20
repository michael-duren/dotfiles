vim.lsp.config("roslyn", {})

-- Disable formatting capability
-- NOTE: Come back and figure out how to setup prettier with razor plugin
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Disable formatting capability for rzls
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.name == "rzls" then
			client.server_capabilities.documentFormattingProvider = false
		end
	end,
})
