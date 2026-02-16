vim.api.nvim_create_autocmd('FileType', {
  pattern = 'zig',
  callback = function(ev)
    vim.lsp.start({
      name = 'zls',
      cmd = { '/opt/homebrew/bin/zls' },
      root_dir = vim.fs.root(ev.buf, {'build.zig', '.git'}),
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      settings = {
        zls = {
          enable_autofix = false,
          enable_snippets = true,
          enable_ast_check_diagnostics = true,
          enable_import_embedding = true,
          enable_semantic_tokens = true,
        }
      }
    })
  end,
})
