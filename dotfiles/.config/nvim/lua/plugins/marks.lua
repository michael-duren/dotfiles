return {
	"chentoast/marks.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		-- Show marks in the sign column (next to line numbers)
		default_mappings = true,
		-- Show built-in marks (', ., <, >, etc.) in the sign column
		builtin_marks = {},
		-- Cycle to the next/prev mark on the same line
		cyclic = true,
		-- Force write marks to a shada file even when deleting a buffer
		force_write_shada = false,
		-- Refresh interval for the sign column display (ms)
		refresh_interval = 250,
		-- Sign priority (higher = shown on top when multiple signs on same line)
		sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
		-- Disable marks in these filetypes
		excluded_filetypes = {
			"qf",
			"NvimTree",
			"neo-tree",
			"aerial",
			"help",
			"oil",
		},
		-- Disable marks in these buftypes
		excluded_buftypes = { "nofile", "nowrite", "quickfix", "terminal", "prompt" },
		-- Bookmark groups (signs shown for each bookmark group)
		bookmark_0 = {
			sign = "⚑",
			virt_text = "",
			annotate = false,
		},
		mappings = {},
	},
}
