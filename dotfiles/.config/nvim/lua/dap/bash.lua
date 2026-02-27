---@param dap table The nvim-dap module
return function(dap)
	local bashdb_path = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter"

	dap.adapters.bashdb = {
		type = "executable",
		command = bashdb_path .. "/bash-debug-adapter",
		name = "bashdb",
	}

	dap.configurations.sh = {
		{
			type = "bashdb",
			request = "launch",
			name = "Debug current file",
			showDebugOutput = true,
			pathBashdb = bashdb_path .. "/extension/bashdb_dir/bashdb",
			pathBashdbLib = bashdb_path .. "/extension/bashdb_dir",
			trace = true,
			file = "${file}",
			program = "${file}",
			cwd = "${workspaceFolder}",
			pathCat = "cat",
			pathBash = "/bin/bash",
			pathMkfifo = "mkfifo",
			pathPkill = "pkill",
			args = {},
			env = {},
			terminalKind = "integrated",
		},
		{
			type = "bashdb",
			request = "launch",
			name = "Debug with arguments",
			showDebugOutput = true,
			pathBashdb = bashdb_path .. "/extension/bashdb_dir/bashdb",
			pathBashdbLib = bashdb_path .. "/extension/bashdb_dir",
			trace = true,
			file = "${file}",
			program = "${file}",
			cwd = "${workspaceFolder}",
			pathCat = "cat",
			pathBash = "/bin/bash",
			pathMkfifo = "mkfifo",
			pathPkill = "pkill",
			args = function()
				local args_string = vim.fn.input("Arguments: ")
				return vim.split(args_string, " +")
			end,
			env = {},
			terminalKind = "integrated",
		},
	}
end
