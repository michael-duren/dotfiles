vim.api.nvim_create_autocmd("FileType", {
	pattern = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
	callback = function(ev)
		vim.lsp.start({
			name = "tailwindcss",
			cmd = { "tailwindcss-language-server", "--stdio" },
			root_dir = vim.fs.root(ev.buf, { "tailwind.config.js", "tailwind.config.ts" }),
		})
	end,
})

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

require("lspconfg").astro.setup({})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "html", "razor", "cshtml" },
	callback = function(ev)
		vim.lsp.start({
			name = "html",
			cmd = { "vscode-html-language-server", "--stdio" },
			root_dir = vim.fs.root(ev.buf, { ".git", "package.json" }),
			init_options = {
				provideFormatter = true,
				embeddedLanguages = {
					css = true,
					javascript = true,
				},
			},
		})
	end,
})
