local M = {}

---@returns boolean
M.isWindows = function()
	---@diagnostic disable-next-line
	return vim.loop.os_uname().sysname:find("Windows") ~= nil or vim.fn.has("win32") == 1
end

----@param opts LspCommand
function M.execute(opts)
	local params = {
		command = opts.command,
		arguments = opts.arguments,
	}
	if opts.open then
		require("trouble").open({
			mode = "lsp_command",
			params = params,
		})
	else
		return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
	end
end
-- Create code action helper
M.action = setmetatable({}, {
	__index = function(_, action)
		return function()
			vim.lsp.buf.code_action({
				apply = true,
				context = {
					only = { action },
					diagnostics = {},
				},
			})
		end
	end,
})

---@class KeyMapOptions
---@field desc string?
---@field noremap boolean?
---@field silent boolean?

---@class KeyMap
---@field key string
---@field command string | function
---@field mode string?
---@field opts KeyMapOptions

---@param keybindings KeyMap[]
M.mapKeys = function(keybindings)
	for _, bind in ipairs(keybindings) do
		local mode = bind.mode or "n"
		local opts = bind.opts or {}

		if opts.desc == nil then
			opts.desc = bind.key
			if type(bind.command) == "string" then
				---@diagnostic disable-next-line
				opts.desc = bind.command
			end
		end

		vim.keymap.set(mode, bind.key, bind.command, {
			desc = opts.desc,
			noremap = opts.noremap ~= false,
			silent = opts.silent ~= false,
		})
	end
end

M.get_args = function(config)
	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
	local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

	config = vim.deepcopy(config)
	---@cast args string[]
	config.args = function()
		local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
		if config.type and config.type == "java" then
			---@diagnostic disable-next-line: return-type-mismatch
			return new_args
		end
		return require("dap.utils").splitstr(new_args)
	end
	return config
end

return M
