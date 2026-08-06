vim.g.mapleader = " "

local mise_go = vim.fn.expand("~/.local/share/mise/installs/go/latest/bin")
local mise_shims = vim.fn.expand("~/.local/share/mise/shims")
vim.env.PATH = mise_go .. ":" .. mise_shims .. ":" .. vim.env.PATH
vim.env.GOBIN = nil

-- Lazy Config
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Custom plugins
require("custom-plugins")

-- Init Config
require("config")
require("lsp")
require("lazy").setup("plugins")

vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:block,o:block"

require("colorscheme")
