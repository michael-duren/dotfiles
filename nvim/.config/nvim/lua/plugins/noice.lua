local utils = require("helpers.utils")

if utils.is_windows() then
	return {}
end

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
	opts = {
		cmdline = {
			enabled = true,
			view = "cmdline_popup",
			opts = {},
		},
		messages = {
			enabled = false,
		},
		popupmenu = {
			enabled = false,
		},
		notify = {
			enabled = false,
		},
		lsp = {
			progress = {
				enabled = false,
			},
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = false,
				["vim.lsp.util.stylize_markdown"] = false,
				["cmp.entry.get_documentation"] = false,
			},
		},
		presets = {
			bottom_search = false,
			command_palette = true,
			long_message_to_split = true,
			inc_rename = true,
		},
	},
	keys = {
		{
			"<leader>nl",
			function()
				require("noice").cmd("history")
			end,
			desc = "Noice Log",
		},
	},
}
