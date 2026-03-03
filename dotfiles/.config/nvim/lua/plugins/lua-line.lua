return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",

	config = function()
		local icons = require("config.icons")

		-- Git-relative path function for use in lualine winbar.
		-- If you want to ditch dropbar.nvim and use lualine's winbar instead,
		-- uncomment the winbar/inactive_winbar sections below.
		--
		-- local function git_relative_path()
		-- 	local bufname = vim.api.nvim_buf_get_name(0)
		-- 	if bufname == "" then
		-- 		return "[No Name]"
		-- 	end
		-- 	local full_path = vim.fn.fnamemodify(bufname, ":p")
		-- 	local gs = vim.b.gitsigns_status_dict
		-- 	if gs and gs.root then
		-- 		local root = vim.fn.fnamemodify(gs.root, ":p")
		-- 		if full_path:sub(1, #root) == root then
		-- 			return full_path:sub(#root + 1)
		-- 		end
		-- 	end
		-- 	return vim.fn.fnamemodify(bufname, ":~:.")
		-- end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "everforest",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					{
						"diff",
						symbols = {
							added = icons.git.added,
							modified = icons.git.modified,
							removed = icons.git.removed,
						},
					},
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
					},
				},
				lualine_c = {},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			-- Uncomment below (and the git_relative_path function above) to use
			-- lualine's winbar instead of dropbar.nvim for showing the file path
			-- at the top of each window.
			--
			-- winbar = {
			-- 	lualine_c = {
			-- 		{ git_relative_path },
			-- 	},
			-- },
			-- inactive_winbar = {
			-- 	lualine_c = {
			-- 		{ git_relative_path },
			-- 	},
			-- },
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		})
	end,
}
