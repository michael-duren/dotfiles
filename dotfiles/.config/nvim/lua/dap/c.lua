---@param dap table The nvim-dap module
return function(dap)
	local codelldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/codelldb"

	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = codelldb_path,
			args = { "--port", "${port}" },
		},
	}

	dap.configurations.c = {
		{
			type = "codelldb",
			name = "Debug",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
		},
		{
			type = "codelldb",
			name = "Debug (arguments)",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			args = function()
				local args_string = vim.fn.input("Arguments: ")
				return vim.split(args_string, " +")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
		},
		{
			type = "codelldb",
			name = "Attach to Process",
			request = "attach",
			pid = function()
				return require("dap.utils").pick_process()
			end,
		},
	}

	-- Reuse for cpp
	dap.configurations.cpp = dap.configurations.c
end
