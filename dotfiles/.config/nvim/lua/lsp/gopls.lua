vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'gomod', 'gowork', 'gotmpl' },
  callback = function(ev)
    -- Intentionally omit '.git' as a root anchor — in bare repo / git worktree
    -- setups, .git resolves to the bare repo root rather than the worktree,
    -- which causes gopls to attach to the wrong root or reuse a stale instance
    -- across worktrees.
    local root = vim.fs.root(ev.buf, { 'go.work', 'go.mod' })

    if not root then
      return
    end

    vim.lsp.start({
      name = 'gopls',
      cmd = { 'gopls' },
      root_dir = root,
      -- Each unique root_dir gets its own gopls instance. This is critical for
      -- worktrees: without it, Neovim may try to reuse a server whose root no
      -- longer matches, causing gopls to silently stop responding.
      reuse_client = function(client, config)
        return client.config.root_dir == config.root_dir
      end,
      settings = {
        gopls = {
          -- Needed when working across multiple modules / worktrees
          experimentalWorkspaceModule = false,
          -- Avoid gopls trying to walk up into the bare repo
          directoryFilters = { '-vendor' },
        },
      },
    })
  end,
})
