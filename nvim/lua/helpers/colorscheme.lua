local M = {}

local utils = require("helpers.utils")

--- @param colorscheme string - the colorscheme to set in config
M.change_config_colorscheme = function(colorscheme)
	local colorFilePath = utils.join_path(vim.fn.stdpath("config"), "lua", "colorscheme.lua")
	local colorFile = io.open(colorFilePath, "w")

	if not colorFile then
		error(string.format("Could not write to file %s when updating colorscheme", colorFilePath))
		return
	end

	colorFile:write(string.format('vim.cmd.colorscheme("%s")\n', colorscheme))
	colorFile:close()
end

return M
