local utils = require("helpers.utils")
local M = {}

local open_browser = function(path)
	if not path then
		path = vim.fn.expand("%:p")
	end
	if utils.is_windows() then
		vim.fn.system('start msedge "' .. path .. '"')
	elseif utils.is_linux() then
		vim.fn.system("zen-browser " .. path)
	else
		vim.fn.system('open -a "Google Chrome" "' .. vim.fn.expand("%:p") .. '"')
	end
end

local open_remote = function()
	local remote = vim.fn.system([[git remote get-url origin]])
	local url = ""
	if string.match(remote, "@") then
		local matches = vim.fn.matchlist(remote, [[git@\(.*\):\(.*\)\/\(.*\)\.git]])
		print(matches)
		url = string.format("https://%s/%s/%s", matches[2], matches[3], matches[4])
	else
		url = string.gsub(remote, "%.git$", "")
	end

	open_browser(url)
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
