-- Astro markdown filetype settings

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

-- Spell check for markdown files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		-- turn on spell checking for markdown files
		vim.cmd("setlocal spell spelllang=en_us")
	end,
})
