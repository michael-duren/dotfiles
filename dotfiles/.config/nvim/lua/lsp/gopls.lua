-- Resolved once; `go env` is slow enough to matter on every buffer open.
local gomodcache
local function modcache()
	if gomodcache == nil then
		local out = vim.fn.system({ "go", "env", "GOMODCACHE" })
		gomodcache = vim.v.shell_error == 0 and vim.trim(out) or ""
	end
	return gomodcache
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "gomod", "gowork", "gotmpl" },
	callback = function(ev)
		local path = vim.api.nvim_buf_get_name(ev.buf)
		local cache = modcache()

		-- Files under GOMODCACHE are 0444 on disk, so an accidental edit can never
		-- be written back — the buffer just stays dirty. gopls sends every open
		-- buffer to `go list` as an overlay, and `go list` rejects any overlay
		-- beneath GOMODCACHE. One dirty dependency buffer therefore fails
		-- packages.Load for the ENTIRE server session: no completion, no hover, no
		-- types, in every project that server serves. Locking the buffer keeps its
		-- content identical to disk so no overlay is ever produced.
		if cache ~= "" and path:sub(1, #cache) == cache then
			vim.bo[ev.buf].modifiable = false
			vim.bo[ev.buf].readonly = true
		end

		-- Intentionally omit '.git' as a root anchor — in bare repo / git worktree
		-- setups, .git resolves to the bare repo root rather than the worktree,
		-- which causes gopls to attach to the wrong root or reuse a stale instance
		-- across worktrees.
		local root = vim.fs.root(ev.buf, { "go.work", "go.mod" })

		if not root then
			return
		end

		-- gopls REPLACES its default filters when this setting is present, so the
		-- built-in '-**/node_modules' must be restated. Projects with large
		-- non-Go trees (container rootfs, build output) can add their own via
		-- vim.g.gopls_directory_filters in a project-local .nvim.lua (:h exrc).
		local filters = { "-**/node_modules", "-vendor" }
		vim.list_extend(filters, vim.g.gopls_directory_filters or {})

		vim.lsp.start({
			name = "gopls",
			cmd = { "gopls" },
			root_dir = root,
			-- Each unique root_dir gets its own gopls instance. This is critical for
			-- worktrees: without it, Neovim may try to reuse a server whose root no
			-- longer matches, causing gopls to silently stop responding.
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
			settings = {
				gopls = {
					directoryFilters = filters,
				},
			},
		})
	end,
})
