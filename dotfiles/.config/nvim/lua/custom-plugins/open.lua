local utils = require("helpers.utils")
local M = {}

local open_browser = function(path)
	if not path then
		path = vim.fn.expand("%:p")
	end
	if utils.is_windows() then
		vim.fn.system('start msedge "' .. path .. '"')
	elseif utils.is_linux() then
		vim.fn.system("brave-origin " .. path)
	else
		vim.fn.system('open -a "Firefox" "' .. path .. '"')
	end
end

local open_remote = function()
	local remote = vim.trim(vim.fn.system("git remote get-url origin"))
	local url

	if remote:match("@") then
		local host, path = remote:match("^[^@]+@([^:]+):(.+)$")

		if host and path then
			path = path:gsub("%.git$", "")
			url = string.format("https://%s/%s", host, path)
		end
	else
		url = remote:gsub("%.git$", "")
	end

	if url then
		open_browser(url)
	else
		vim.notify("Could not parse git remote: " .. remote, vim.log.levels.ERROR)
	end
end

M.setup = function()
	utils.map_keys({
		{
			key = "<leader>ob",
			command = open_browser,
			opts = { desc = "Open current buffer in Browser" },
		},
		{
			key = "<leader>oB",
			command = open_remote,
			opts = { desc = "Open source repositories remote origin in browser" },
		},
	})
end

return M
