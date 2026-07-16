local M = {}

---Restart all LSP clients attached to the current buffer via the
---native enable-toggle (nvim 0.11.2+), replacing lspconfig's :LspRestart.
function M.restart()
	local names = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		table.insert(names, client.name)
	end
	if #names == 0 then
		vim.notify("No LSP clients attached", vim.log.levels.WARN)
		return
	end
	for _, name in ipairs(names) do
		vim.lsp.enable(name, false)
	end
	-- enable(false) shuts clients down asynchronously; re-enabling
	-- immediately can race the shutdown, so give it a beat
	vim.defer_fn(function()
		for _, name in ipairs(names) do
			vim.lsp.enable(name)
		end
	end, 100)
end

-- names disabled by the last toggle, so we know what to re-enable
local disabled = {}

function M.toggle()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients > 0 then
		disabled = {}
		for _, client in ipairs(clients) do
			table.insert(disabled, client.name)
			vim.lsp.enable(client.name, false)
		end
		vim.notify("LSP disabled", vim.log.levels.INFO)
	elseif #disabled > 0 then
		for _, name in ipairs(disabled) do
			vim.lsp.enable(name)
		end
		disabled = {}
		vim.notify("LSP enabled", vim.log.levels.INFO)
	else
		vim.notify("No LSP clients to toggle", vim.log.levels.WARN)
	end
end

return M
