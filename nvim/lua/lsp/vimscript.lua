vim.api.nvim_create_autocmd("FileType", {
	pattern = "vim",
	callback = function(ev)
		vim.lsp.start({
			name = "vimls",
			cmd = { "vim-language-server", "--stdio" },
			root_dir = vim.fs.root(ev.buf, { ".vimrc", ".git" }),
		})
	end,
})
