vim.api.nvim_create_autocmd("FileType", {
	pattern = { "asm", "nasm", "vmasm" },
	callback = function(ev)
		vim.lsp.start({
			name = "asm_lsp",
			cmd = { "asm-lsp" },
			root_dir = vim.fs.root(ev.buf, { "Makefile", ".git" }),
		})
	end,
})
