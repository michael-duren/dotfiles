---@diagnostic disable: missing-fields
local utils = require("helpers.utils")

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "LazyFile", "VeryLazy" },
	cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
	branch = "main",
	version = false,
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = {
				"hyprlang",
				"vim",
				"lua",
				"vimdoc",
				"html",
				"css",
				"c_sharp",
				"razor",
				"go",
				"gomod",
				"gowork",
				"gosum",
				"typescript",
				"javascript",
				"json",
				"markdown",
				"zig",
			},
			folds = { enable = true },
			auto_install = not utils.is_windows(),
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
		})
	end,
}
