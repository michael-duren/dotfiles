vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'html', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  callback = function(ev)
    vim.lsp.start({
      name = 'tailwindcss',
      cmd = { 'tailwindcss-language-server', '--stdio' },
      root_dir = vim.fs.root(ev.buf, { 'tailwind.config.js', 'tailwind.config.ts' }),
    })
  end,
})
