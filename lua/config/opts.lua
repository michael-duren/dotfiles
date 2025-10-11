local utils = require("helpers.utils")
local icons = require("config.icons")

vim.g.mapleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.clipboard = "unnamedplus"

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

opt.smartcase = true
opt.ignorecase = true

vim.cmd("highlight CursorLineNr ctermfg=white guifg=white")

-- windows work machine is super slow
if utils.is_windows() then
	vim.opt.shell = "pwsh"
	vim.opt.shellcmdflag = "-nologo -noprofile -ExecutionPolicy RemoteSigned -command"
	vim.opt.shellxquote = ""

	vim.opt.fsync = false
	vim.g.loaded_perl_provider = 0
	vim.g.loaded_ruby_provider = 0
	vim.g.loaded_node_provider = 0
	vim.g.python3_host_prog = ""

	-- Disable some built-in plugins
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1
	vim.g.loaded_matchit = 1
	vim.g.loaded_matchparen = 1
	vim.g.loaded_tarPlugin = 1
	vim.g.loaded_zipPlugin = 1
	vim.g.loaded_gzip = 1
	vim.g.loaded_2html_plugin = 1
	vim.g.loaded_tutor_plugin = 1

	vim.lsp.set_log_level("OFF")

	opt.swapfile = false
	opt.backup = false
	opt.writebackup = false

	opt.ttyfast = true

	-- Performance enhancements
	-- Faster syntax highlighting
	-- Experimental, may cause issues with some syntax files
	opt.syntax = "on"
	opt.synmaxcol = 200 -- Don't highlight super long lines
end

-- Setup diagnostic icons
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
			[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
			[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
			[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
		},
		numhl = {
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
	virtual_text = {
		prefix = "●",
	},
	float = {
		border = "rounded",
		header = "",
		prefix = "",
	},
})
