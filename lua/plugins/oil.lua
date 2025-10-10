return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
		{
			"<C-n>",
			function()
				require("oil").toggle_float()
			end,
			desc = "Open Oil",
		},
	},
	---@module 'oil'
	opts = {
		default_file_explorer = true,
		columns = {
			"icon",
			"size",
		},
		keymaps = {
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<C-s>"] = "actions.select_vsplit",
			["<C-h>"] = "actions.select_split",
			["<C-t>"] = "actions.select_tab",
			["<C-p>"] = "actions.preview",
			["<C-c>"] = "actions.close",
			["<C-l>"] = "actions.refresh",
			["-"] = "actions.parent",
			["_"] = "actions.open_cwd",
			["`"] = "actions.cd",
			["~"] = "actions.tcd",
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["g."] = "actions.toggle_hidden",
			["g\\"] = "actions.toggle_trash",
		},
		use_default_keymaps = true,
		skip_confirm_for_simple_edits = true,
		view_options = {
			show_hidden = true,
			is_hidden_file = function(name)
				return vim.startswith(name, ".")
			end,
			is_always_hidden = function()
				return false
			end,
		},
		float = {
			padding = 2,
			max_width = 120,
			-- max_height = 0,
			border = "rounded",
			win_options = {
				winblend = 0,
			},
		},
	},
}
