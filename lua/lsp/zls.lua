vim.api.nvim_create_autocmd('FileType', {
  pattern = 'zig',
  callback = function(ev)
    vim.lsp.start({
      name = 'zls',
      cmd = { 'zls' },
      root_dir = vim.fs.root(ev.buf, {'build.zig', '.git'}),
    })
  end,
})
