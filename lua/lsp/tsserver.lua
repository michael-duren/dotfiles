vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  callback = function(ev)
    vim.lsp.start({
      name = 'tsserver',
      cmd = { 'typescript-language-server', '--stdio' },
      root_dir = vim.fs.root(ev.buf, {'package.json', 'tsconfig.json', 'jsconfig.json', '.git'}),
    })
  end,
})
