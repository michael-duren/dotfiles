local source = {}

source.new = function()
	local self = setmetatable({}, { __index = source })
	self.dbee = nil
	return self
end

function source:get_trigger_characters()
	return { ".", " " }
end

function source:get_keyword_pattern()
	return [[\k\+]]
end

function source:is_available()
	local ft = vim.bo.filetype
	return (ft == "sql" or ft == "mysql" or ft == "plsql")
end

function source:complete(ctx, callback)
	-- Lazy load dbee
	if not self.dbee then
		local ok, dbee = pcall(require, "dbee")
		if not ok then
			return callback({ items = {} })
		end
		self.dbee = dbee
	end

	local items = {}

	-- Get current connection
	local conn_id = self.dbee.api.ui.get_current_connection()
	if not conn_id then
		return callback({ items = {} })
	end

	-- Get connection structure (tables, columns, etc.)
	local structure = self.dbee.api.core.get_structure(conn_id)
	if not structure then
		return callback({ items = {} })
	end

	-- Parse the structure and create completion items
	for _, schema in ipairs(structure) do
		-- Add schema
		table.insert(items, {
			label = schema.name,
			kind = vim.lsp.protocol.CompletionItemKind.Module,
			detail = "Schema",
		})

		-- Add tables
		if schema.children then
			for _, table in ipairs(schema.children) do
				if table.type == "table" then
					table.insert(items, {
						label = table.name,
						kind = vim.lsp.protocol.CompletionItemKind.Class,
						detail = "Table",
						documentation = schema.name and (schema.name .. "." .. table.name) or nil,
					})

					-- Add columns
					if table.children then
						for _, column in ipairs(table.children) do
							table.insert(items, {
								label = column.name,
								kind = vim.lsp.protocol.CompletionItemKind.Field,
								detail = column.type or "Column",
								documentation = string.format("%s (%s)", table.name, column.type or ""),
							})
						end
					end
				end
			end
		end
	end

	callback({ items = items, is_incomplete = false })
end

return source
