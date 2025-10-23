require("config.opts")
-- check if db.lua exists
if vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/config/db.lua") == 1 then
	require("config.db")
end
require("config.keymaps")
require("config.autocmds")
