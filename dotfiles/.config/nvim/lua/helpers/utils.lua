local M = {}

---@returns boolean
M.is_windows = function()
	---@diagnostic disable-next-line
	return vim.loop.os_uname().sysname:find("Windows") ~= nil or vim.fn.has("win32") == 1
end

---@returns boolean
M.is_linux = function()
	return vim.loop.os_uname().sysname == "Linux"
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
---@field mode string | nil | string[]
---@field opts KeyMapOptions

---@param keybindings KeyMap[]
---@param global_opts? vim.keymap.set.Opts
M.map_keys = function(keybindings, global_opts)
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

		vim.keymap.set(
			mode,
			bind.key,
			bind.command,
			M.merge_keyed_tables(global_opts or {}, {
				desc = opts.desc,
				noremap = opts.noremap ~= false,
				silent = opts.silent ~= false,
			})
		)
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

M.merge_keyed_tables = function(t1, t2)
	local merged = vim.deepcopy(t1)
	for key, value in pairs(t2) do
		if type(value) == "table" and type(merged[key]) == "table" then
			merged[key] = M.merge_keyed_tables(merged[key], value)
		else
			merged[key] = value
		end
	end
	return merged
end

---@param ... string Paths to join
---@return string The joined path
M.join_path = function(...)
	local separator = M.is_windows() and "\\" or "/"
	local pathList = { ... }
	local cleanPaths = {}

	for _, path in ipairs(pathList) do
		if path ~= "" then
			table.insert(cleanPaths, path)
		end
	end

	return table.concat(cleanPaths, separator)
end

return M
