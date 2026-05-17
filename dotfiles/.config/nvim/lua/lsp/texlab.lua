local filetypes = { 'tex', 'plaintex', 'latex', 'bib' }

vim.api.nvim_create_autocmd('FileType', {
  pattern = filetypes,
  callback = function(ev)
    vim.lsp.start({
      name = 'texlab',
      cmd = { 'texlab' },
      root_dir = vim.fs.root(ev.buf, {
        '.latexmkrc', '.texlabroot', 'texlabroot', 'Tectonic.toml', '.git',
      }),
      settings = {
        texlab = {
          build = {
            onSave = false,
            forwardSearchAfter = false,
          },
          forwardSearch = {
            executable = 'zathura',
            args = { '--synctex-forward', '%l:1:%f', '%p' },
          },
          chktex = {
            onOpenAndSave = true,
            onEdit = false,
          },
          diagnosticsDelay = 300,
        },
      },
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = filetypes,
	callback = function()
		-- turn on spell checking for tex files
		vim.cmd("setlocal spell spelllang=en_us")
	end,
})
