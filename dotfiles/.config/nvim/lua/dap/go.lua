---@param dap table
return function(dap)
	-- Generic remote-attach config for any repo running `dlv --headless` in Docker.
	-- Prompts for host:port at debug time instead of hardcoding one per project.
	table.insert(dap.configurations.go or {}, {
		type = "go",
		name = "Attach to Docker (remote delve)",
		request = "launch",
		mode = "exec",
		program = function()
			return vim.fn.input("Path to binary in container: ", "/app/bin/z00hcxgtest-api")
		end,
	})
end
