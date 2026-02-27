local utils = require("helpers.utils")

---@param dap table The nvim-dap module
return function(dap)
	local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg"

	local function get_netcoredbg_path()
		if utils.is_windows() then
			return mason_path .. "/netcoredbg.exe"
		else
			return mason_path .. "/netcoredbg"
		end
	end

	local netcoredbg_adapter = {
		type = "executable",
		command = get_netcoredbg_path(),
		args = { "--interpreter=vscode" },
	}

	dap.adapters.netcoredbg = netcoredbg_adapter
	dap.adapters.coreclr = netcoredbg_adapter

	dap.configurations.cs = {
		{
			type = "coreclr",
			name = "launch - netcoredbg",
			request = "launch",
			program = function()
				return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net10.0/", "file")
			end,
			env = {
				ASPNETCORE_ENVIRONMENT = "Development",
			},
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
end
