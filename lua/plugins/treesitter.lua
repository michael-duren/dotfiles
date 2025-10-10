utils = require("helpers.utils")

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
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
				"typescript",
				"javascript",
				"json",
				"markdown",
				"zig",
			},
			auto_install = not utils.isWindows(),
			highlight = {
				enable = true,
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},
			indent = {
				enable = true,
			},
		})
	end,
}
