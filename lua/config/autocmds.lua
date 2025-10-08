-- set tab size to 2 for json, css, html files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "json,css,html,typescript,javascript,typescriptreact,javascriptreact,scss,sass,lua,yaml",
	callback = function()
		vim.opt.tabstop = 2
		vim.opt.softtabstop = 2
		vim.opt.shiftwidth = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "mdx",
	callback = function()
		-- turn on spell checking for markdown files
		vim.cmd("setlocal spell spelllang=en_us")
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "mmd",
	callback = function()
		-- turn on spell checking for markdown files
		vim.cmd("setlocal spell spelllang=en_us")
	end,
})
