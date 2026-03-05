vim.api.nvim_create_autocmd("FileType", {
	pattern = "dockerfile",
	callback = function(ev)
		vim.lsp.start({
			name = "dockerls",
			cmd = { "docker-langserver", "--stdio" },
			root_dir = vim.fs.root(ev.buf, { "Dockerfile", ".git" }) or vim.fn.getcwd(),
		})
	end,
})
