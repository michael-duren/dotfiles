vim.api.nvim_create_autocmd("FileType", {
	pattern = { "templ" },
	callback = function(ev)
		-- Same root strategy as gopls.lua: omit '.git' so bare repo / worktree
		-- setups resolve to the worktree's module, not the bare repo root.
		-- templ's LSP spawns gopls internally, so the same pitfalls apply.
		local root = vim.fs.root(ev.buf, { "go.work", "go.mod" })

		if not root then
			return
		end

		vim.lsp.start({
			name = "templ",
			cmd = { "templ", "lsp" },
			root_dir = root,
			reuse_client = function(client, config)
				-- Must re-check name and is_stopped: vim.lsp.start() runs this
				-- predicate against EVERY running client, and a client stays in
				-- lsp.client._all for two scheduled ticks after it exits.
				-- Matching on root_dir alone attaches Go buffers to whichever
				-- server claimed this root first (templ shares it), and reattaches
				-- to a dying gopls instead of respawning one.
				return client.name == config.name
					and not client:is_stopped()
					and client.config.root_dir == config.root_dir
			end,
		})
	end,
})
