return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify", -- Optional but recommended for notification history
	},
	opts = {
		cmdline = {
			enabled = true,
			view = "cmdline_popup", -- Centered popup
			opts = {}, -- cmdline options
		},
		messages = {
			enabled = false, -- Disable other message handling
		},
		popupmenu = {
			enabled = false, -- Use default completion menu
		},
		notify = {
			enabled = true,
		},
		lsp = {
			override = {
				-- Override markdown rendering for hover/signature help
				["vim.lsp.util.convert_input_to_markdown_lines"] = false,
				["vim.lsp.util.stylize_markdown"] = false,
				["cmp.entry.get_documentation"] = false,
			},
		},
		presets = {
			bottom_search = false,
			command_palette = true, -- Center the cmdline
			long_message_to_split = true,
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
