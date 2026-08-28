local M = {}

---Buffers a client is attached to, as a list.
---@param client vim.lsp.Client
---@return integer[]
local function attached_buffers(client)
	local bufs = {}
	for buf in pairs(client.attached_buffers or {}) do
		if vim.api.nvim_buf_is_loaded(buf) then
			table.insert(bufs, buf)
		end
	end
	return bufs
end

---Re-fire FileType on the given buffers so LSP configs re-attach.
---
---This is the only restart mechanism that works for BOTH kinds of config in
---this setup: servers started by hand with vim.lsp.start() inside our own
---FileType autocmds (lua/lsp/*.lua), and servers started by vim.lsp.enable(),
---which installs its own FileType autocmd. vim.lsp.enable(name) alone cannot
---restart the former — it only registers the name and waits for a future
---FileType event, so a hand-rolled client that was just stopped never comes
---back and the buffer silently loses its LSP until Neovim is restarted.
---@param buffers integer[]
local function refire_filetype(buffers)
	for _, buf in ipairs(buffers) do
		if vim.api.nvim_buf_is_loaded(buf) then
			vim.api.nvim_exec_autocmds("FileType", { buffer = buf, modeline = false })
		end
	end
end

---Stop the given clients, then run `done` once they have all actually exited.
---Re-attaching before exit completes would let a reuse_client predicate hand
---back the dying client instead of spawning a fresh one.
---@param clients vim.lsp.Client[]
---@param done fun()
local function stop_then(clients, done)
	for _, client in ipairs(clients) do
		client:stop()
	end

	local ids = vim.tbl_map(function(c)
		return c.id
	end, clients)

	local waited = 0
	local timer = assert(vim.uv.new_timer())
	timer:start(
		50,
		50,
		vim.schedule_wrap(function()
			waited = waited + 50

			local still_running = false
			for _, id in ipairs(ids) do
				if vim.lsp.get_client_by_id(id) then
					still_running = true
					break
				end
			end

			-- Force-stop anything that ignored the graceful shutdown, then give
			-- up waiting: better a possible duplicate than no server at all.
			if still_running and waited >= 3000 then
				for _, id in ipairs(ids) do
					local c = vim.lsp.get_client_by_id(id)
					if c then
						c:stop(true)
					end
				end
			end

			if not still_running or waited >= 4000 then
				timer:stop()
				timer:close()
				done()
			end
		end)
	)
end

---Restart all LSP clients attached to the current buffer.
function M.restart()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("No LSP clients attached", vim.log.levels.WARN)
		return
	end

	local buffers, seen = {}, {}
	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
		for _, buf in ipairs(attached_buffers(client)) do
			if not seen[buf] then
				seen[buf] = true
				table.insert(buffers, buf)
			end
		end
	end

	stop_then(clients, function()
		refire_filetype(buffers)
		vim.notify("LSP restarted: " .. table.concat(names, ", "), vim.log.levels.INFO)
	end)
end

-- Buffers whose clients the last toggle stopped, so we know what to re-attach.
local disabled_buffers = {}

function M.toggle()
	local clients = vim.lsp.get_clients({ bufnr = 0 })

	if #clients > 0 then
		local buffers, seen = {}, {}
		for _, client in ipairs(clients) do
			for _, buf in ipairs(attached_buffers(client)) do
				if not seen[buf] then
					seen[buf] = true
					table.insert(buffers, buf)
				end
			end
		end
		disabled_buffers = buffers

		-- Notify synchronously: stop_then's callback runs on a timer, so a
		-- notify in there can land after a later toggle's "LSP enabled".
		vim.notify("LSP disabled", vim.log.levels.INFO)
		stop_then(clients, function() end)
	elseif #disabled_buffers > 0 then
		refire_filetype(disabled_buffers)
		disabled_buffers = {}
		vim.notify("LSP enabled", vim.log.levels.INFO)
	else
		vim.notify("No LSP clients to toggle", vim.log.levels.WARN)
	end
end

return M
