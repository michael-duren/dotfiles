return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			{
				"leoluz/nvim-dap-go",
				opts = {},
			},
		},
		lazy = true, -- Don't load on startup
		-- Load when you actually need debugging
		keys = {
			{ "<leader>dB", desc = "Breakpoint Condition" },
			{ "<leader>db", desc = "Toggle Breakpoint" },
			{ "<leader>dc", desc = "Run/Continue" },
			{ "<leader>da", desc = "Run with Args" },
			{ "<leader>dC", desc = "Run to Cursor" },
			{ "<leader>dg", desc = "Go to Line (No Execute)" },
			{ "<leader>di", desc = "Step Into" },
			{ "<leader>dj", desc = "Down" },
			{ "<leader>dk", desc = "Up" },
			{ "<leader>dl", desc = "Run Last" },
			{ "<leader>do", desc = "Step Out" },
			{ "<leader>dO", desc = "Step Over" },
			{ "<leader>dP", desc = "Pause" },
			{ "<leader>dr", desc = "Toggle REPL" },
			{ "<leader>ds", desc = "Session" },
			{ "<leader>dt", desc = "Terminate" },
			{ "<leader>dw", desc = "Widgets" },
			{ "<F5>", desc = "DAP Continue" },
			{ "<F6>", desc = "Debug Test" },
			{ "<F8>", desc = "Step Out" },
			{ "<F9>", desc = "Toggle Breakpoint" },
			{ "<F10>", desc = "Step Over" },
			{ "<F11>", desc = "Step Into" },
		},
		config = function()
			require("lsp.dap")
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		lazy = true,
		opts = {},
	},
}
