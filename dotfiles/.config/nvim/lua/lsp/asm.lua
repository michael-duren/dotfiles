-- Nvim's builtin *.s detection scans the first 50 lines and treats a `.ident`
-- directive as VMS Macro-32 (`vmasm`). GCC emits `.ident "GCC: ..."` at the end
-- of every -S output, so gcc assembly gets misdetected. Force GNU as syntax.
vim.filetype.add({
	extension = {
		s = "asm",
		S = "asm",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "asm", "nasm", "vmasm" },
	callback = function(ev)
		if vim.fn.executable("asm-lsp") == 0 then
			return
		end
		vim.lsp.start({
			name = "asm_lsp",
			cmd = { "asm-lsp" },
			root_dir = vim.fs.root(ev.buf, { ".asm-lsp.toml", "Makefile", ".git" })
				or vim.fs.dirname(vim.api.nvim_buf_get_name(ev.buf)),
		})
	end,
})
