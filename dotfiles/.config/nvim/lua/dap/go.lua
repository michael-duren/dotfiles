---@param dap table The nvim-dap module
return function(dap)
	local delve_path = vim.fn.stdpath("data") .. "/mason/packages/delve/dlv"

	dap.adapters.go = {
		type = "server",
		port = "${port}",
		executable = {
			command = delve_path,
			args = { "dap", "-l", "127.0.0.1:${port}" },
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
end
