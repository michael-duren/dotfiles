return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
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
			{ "<leader>dO", desc = "Step Out" },
			{ "<leader>do", desc = "Step Over" },
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
			{
				"<leader>td",
				function()
					---@diagnostic disable-next-line: missing-fields
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "Debug Nearest",
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local utils = require("helpers.utils")

			-- Adapter configurations
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"
			local delve_path = vim.fn.stdpath("data") .. "/mason/packages/delve/dlv"

			local netcoredbg_adapter = {
				type = "executable",
				command = mason_path,
				args = { "--interpreter=vscode" },
			}

			local delve_adapter = {
				type = "server",
				port = "${port}",
				executable = {
					command = delve_path,
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			}

			dap.adapters.netcoredbg = netcoredbg_adapter
			dap.adapters.coreclr = netcoredbg_adapter
			dap.adapters.go = delve_adapter

			-- Language configurations
			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "launch - netcoredbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
					end,
				},
			}

			dap.configurations.go = {
				{
					type = "go",
					name = "Debug",
					request = "launch",
					program = "${file}",
				},
				{
					type = "go",
					name = "Debug (arguments)",
					request = "launch",
					program = "${file}",
					args = function()
						local args_string = vim.fn.input("Arguments: ")
						return vim.split(args_string, " +")
					end,
				},
				{
					type = "go",
					name = "Debug Package",
					request = "launch",
					program = "${workspaceFolder}",
				},
				{
					type = "go",
					name = "Attach to Process",
					mode = "local",
					request = "attach",
					processId = function()
						return require("dap.utils").pick_process()
					end,
				},
				{
					type = "go",
					name = "Debug test",
					request = "launch",
					mode = "test",
					program = "${file}",
				},
				{
					type = "go",
					name = "Debug test (go.mod)",
					request = "launch",
					mode = "test",
					program = "./${relativeFileDirname}",
				},
			}

			-- Keymaps
			local keys = {
				{
					key = "<leader>dB",
					command = function()
						require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
					end,
					opts = { desc = "Breakpoint Condition" },
				},
				{
					key = "<leader>db",
					command = function()
						require("dap").toggle_breakpoint()
					end,
					opts = { desc = "Toggle Breakpoint" },
				},
				{
					key = "<leader>dc",
					command = function()
						require("dap").continue()
					end,
					opts = { desc = "Run/Continue" },
				},
				{
					key = "<leader>da",
					command = function()
						require("dap").continue({ before = utils.get_args })
					end,
					opts = { desc = "Run with Args" },
				},
				{
					key = "<leader>dC",
					command = function()
						require("dap").run_to_cursor()
					end,
					opts = { desc = "Run to Cursor" },
				},
				{
					key = "<leader>dg",
					command = function()
						require("dap").goto_()
					end,
					opts = { desc = "Go to Line (No Execute)" },
				},
				{
					key = "<leader>di",
					command = function()
						require("dap").step_into()
					end,
					opts = { desc = "Step Into" },
				},
				{
					key = "<leader>dj",
					command = function()
						require("dap").down()
					end,
					opts = { desc = "Down" },
				},
				{
					key = "<leader>dk",
					command = function()
						require("dap").up()
					end,
					opts = { desc = "Up" },
				},
				{
					key = "<leader>dl",
					command = function()
						require("dap").run_last()
					end,
					opts = { desc = "Run Last" },
				},
				{
					key = "<leader>do",
					command = function()
						require("dap").step_out()
					end,
					opts = { desc = "Step Out" },
				},
				{
					key = "<leader>dO",
					command = function()
						require("dap").step_over()
					end,
					opts = { desc = "Step Over" },
				},
				{
					key = "<leader>dP",
					command = function()
						require("dap").pause()
					end,
					opts = { desc = "Pause" },
				},
				{
					key = "<leader>dr",
					command = function()
						require("dap").repl.toggle()
					end,
					opts = { desc = "Toggle REPL" },
				},
				{
					key = "<leader>ds",
					command = function()
						require("dap").session()
					end,
					opts = { desc = "Session" },
				},
				{
					key = "<leader>dt",
					command = function()
						require("dap").terminate()
					end,
					opts = { desc = "Terminate" },
				},
				{
					key = "<leader>dw",
					command = function()
						require("dap.ui.widgets").hover()
					end,
					opts = { desc = "Widgets" },
				},
				{
					key = "<F5>",
					command = "<Cmd>lua require'dap'.continue()<CR>",
					opts = { desc = "DAP Continue" },
				},
				{
					key = "<F6>",
					command = "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>",
					opts = { desc = "Debug Test" },
				},
				{
					key = "<F9>",
					command = "<Cmd>lua require'dap'.toggle_breakpoint()<CR>",
					opts = { desc = "Toggle Breakpoint" },
				},
				{
					key = "<F10>",
					command = "<Cmd>lua require'dap'.step_over()<CR>",
					opts = { desc = "Step Over" },
				},
				{
					key = "<F11>",
					command = "<Cmd>lua require'dap'.step_into()<CR>",
					opts = { desc = "Step Into" },
				},
				{
					key = "<F8>",
					command = "<Cmd>lua require'dap'.step_out()<CR>",
					opts = { desc = "Step Out" },
				},
			}

			utils.mapKeys(keys)

			-- DAP UI listeners
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Setup DAP UI
			dapui.setup()
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		lazy = true,
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"Issafalcon/neotest-dotnet",
		},
		adapters = {
			require("neotest-dotnet"),
		},
		keys = {
			{ "<leader>t", "", desc = "+test" },
			{
				"<leader>tt",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run File (Neotest)",
			},
			{
				"<leader>tT",
				function()
					require("neotest").run.run(vim.uv.cwd())
				end,
				desc = "Run All Test Files (Neotest)",
			},
			{
				"<leader>tr",
				function()
					require("neotest").run.run()
				end,
				desc = "Run Nearest (Neotest)",
			},
			{
				"<leader>tl",
				function()
					require("neotest").run.run_last()
				end,
				desc = "Run Last (Neotest)",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle Summary (Neotest)",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end,
				desc = "Show Output (Neotest)",
			},
			{
				"<leader>tO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle Output Panel (Neotest)",
			},
			{
				"<leader>tS",
				function()
					require("neotest").run.stop()
				end,
				desc = "Stop (Neotest)",
			},
			{
				"<leader>tw",
				function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end,
				desc = "Toggle Watch (Neotest)",
			},
		},
		config = function(opts)
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						-- Replace newline and tab characters with space for more compact diagnostics
						local message =
							diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)

			if opts.adapters then
				local adapters = {}
				for name, config in pairs(opts.adapters or {}) do
					if type(name) == "number" then
						if type(config) == "string" then
							config = require(config)
						end
						adapters[#adapters + 1] = config
					elseif config ~= false then
						local adapter = require(name)
						if type(config) == "table" and not vim.tbl_isempty(config) then
							local meta = getmetatable(adapter)
							if adapter.setup then
								adapter.setup(config)
							elseif adapter.adapter then
								adapter.adapter(config)
								adapter = adapter.adapter
							elseif meta and meta.__call then
								adapter = adapter(config)
							else
								error("Adapter " .. name .. " does not support setup")
							end
						end
						adapters[#adapters + 1] = adapter
					end
				end
				opts.adapters = adapters
			end

			require("neotest").setup(opts)
		end,
	},
	{
		"Issafalcon/neotest-dotnet",
		lazy = true,
	},
}
