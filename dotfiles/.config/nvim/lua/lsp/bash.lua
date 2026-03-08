vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sh", "zsh" },
	callback = function(ev)
		vim.lsp.start({
			name = "bashls",
			cmd = { "bash-language-server", "start" },
			root_dir = vim.fs.root(ev.buf, { ".git", ".bashrc", ".bash_profile" }),
			settings = {
				bashIde = {
					globPattern = "*@(.sh|.inc|.bash|.command|.zshrc|.zsh|.zshenv|.zprofile|.zlogin|.zlogout)",
				},
			},
		})
	end,
})
