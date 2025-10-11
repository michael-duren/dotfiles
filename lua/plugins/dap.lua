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
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"Issafalcon/neotest-dotnet",
			"fredrikaverpil/neotest-golang",
		},
		lazy = true, -- Load on demand
		opts = {
			adapters = {
				["neotest-golang"] = {
					-- Here we can set options for neotest-golang, e.g.
					-- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
					dap_go_enabled = true, -- requires leoluz/nvim-dap-go
				},
				["neotest-dotnet"] = {
					-- Here we can set options for neotest-dotnet
				},
			},
		},
		keys = {
			{ "<leader>t", "", desc = "+test" },
			{
				"<leader>tt",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run File",
			},
			{
				"<leader>tT",
				function()
					---@diagnostic disable-next-line: undefined-field
					require("neotest").run.run(vim.uv.cwd())
				end,
				desc = "Run All Test Files",
			},
			{
				"<leader>tr",
				function()
					require("neotest").run.run()
				end,
				desc = "Run Nearest",
			},
			{
				"<leader>td",
				function()
					---@diagnostic disable-next-line: missing-fields
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "Debug Nearest Test",
			},
			{
				"<leader>tl",
				function()
					require("neotest").run.run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle Summary",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end,
				desc = "Show Output",
			},
			{
				"<leader>tO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle Output Panel",
			},
			{
				"<leader>tS",
				function()
					require("neotest").run.stop()
				end,
				desc = "Stop",
			},
			{
				"<leader>tw",
				function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end,
				desc = "Toggle Watch",
			},
		},
		config = function(_, opts)
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						local message =
							diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)

			require("neotest").setup(opts)
		end,
	},
	{
		"Issafalcon/neotest-dotnet",
		lazy = true,
	},
}
