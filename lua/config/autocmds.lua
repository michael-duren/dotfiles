-- set tab size to 2 for json, css, html files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "json,css,html,typescript,javascript,typescriptreact,javascriptreact,scss,sass,lua,yaml,markdown",
	callback = function()
		vim.opt.tabstop = 2
		vim.opt.softtabstop = 2
		vim.opt.shiftwidth = 2
	end,
})

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
})
