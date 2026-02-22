return {
	"mistweaverco/kulala.nvim",
	ft = "http",
	keys = {
		{ "<leader>rr", "<cmd>lua require('kulala').run()<cr>", desc = "Run request" },
		{ "<leader>rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle result view" },
		{ "<leader>rp", "<cmd>lua require('kulala').jump_prev()<cr>", desc = "Jump to previous request" },
		{ "<leader>rn", "<cmd>lua require('kulala').jump_next()<cr>", desc = "Jump to next request" },
		{ "<leader>ri", "<cmd>lua require('kulala').inspect()<cr>", desc = "Inspect current request" },
		{ "<leader>rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy as cURL" },
	},
	opts = {
		default_view = "body",
		default_env = "dev",
		debug = false,
		-- Disable the broken LSP feature
		enable_lsp = false,
	},
}
