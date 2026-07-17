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
				return client.config.root_dir == config.root_dir
			end,
		})
	end,
})
