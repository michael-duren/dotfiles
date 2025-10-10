local dap = require("dap")
local dapui = require("dapui")
local utils = require("helpers.utils")
local icons = require("config.icons")

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

dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
dap.adapters.coreclr = netcoredbg_adapter -- needed for unit test debugging
dap.adapters.go = delve_adapter

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		program = function()
			-- return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/src/", "file")
			return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
		end,
	},
	{
		type = "coreclr",
		name = "attach - netcoredbg",
		request = "attach",
		processId = function()
			return require("dap.utils").pick_process()
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

---@type KeyMap[]
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
		key = "<leader>du",
		command = function()
			require("dapui").toggle({})
		end,
		opts = {
			desc = "Dap UI",
		},
	},
	{
		mode = { "n", "v" },
		key = "<leader>de",
		command = function()
			require("dapui").eval()
		end,
		opts = {
			desc = "Eval",
		},
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

utils.map_keys(keys)
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- Setup DAP signs
vim.fn.sign_define("DapBreakpoint", {
	text = icons.dap.Breakpoint,
	texthl = "DapBreakpoint",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DapBreakpointCondition", {
	text = icons.dap.BreakpointCondition,
	texthl = "DapBreakpointCondition",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DapBreakpointRejected", {
	text = icons.dap.BreakpointRejected[1],
	texthl = icons.dap.BreakpointRejected[2],
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DapStopped", {
	text = icons.dap.Stopped[1],
	texthl = icons.dap.Stopped[2],
	linehl = icons.dap.Stopped[3],
	numhl = "",
})

vim.fn.sign_define("DapLogPoint", {
	text = icons.dap.LogPoint,
	texthl = "DapLogPoint",
	linehl = "",
	numhl = "",
})

-- default configuration
dapui.setup()
