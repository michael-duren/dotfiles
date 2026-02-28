-- Ensure mise tools are in PATH before anything loads (needed for Mason)
-- Use actual go binary (not shim) to avoid mise setting GOBIN which breaks Mason
local mise_go = vim.fn.expand("~/.local/share/mise/installs/go/latest/bin")
local mise_shims = vim.fn.expand("~/.local/share/mise/shims")
vim.env.PATH = mise_go .. ":" .. mise_shims .. ":" .. vim.env.PATH
vim.env.GOBIN = nil

-- Hover Styling
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or "rounded"
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

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
