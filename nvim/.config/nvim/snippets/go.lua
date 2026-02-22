local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node

local ts_utils = require("nvim-treesitter.ts_utils")

-- Map of zero values for different types
local zero_values = {
	int = "0",
	int8 = "0",
	int16 = "0",
	int32 = "0",
	int64 = "0",
	uint = "0",
	uint8 = "0",
	uint16 = "0",
	uint32 = "0",
	uint64 = "0",
	float32 = "0",
	float64 = "0",
	complex64 = "0",
	complex128 = "0",
	bool = "false",
	string = '""',
	error = "err",
}

-- Fallback for pointers, interfaces, slices, maps, channels, vars
local function get_zero_value(type_str)
	if zero_values[type_str] then
		return zero_values[type_str]
	end
	-- check for pointers
	if type_str:match("^%*") then
		return "nil"
	end
	-- check for slices/maps/channels which are often just returned as nil if that is the intent,
	-- but strictly, `nil` is safe for any pointer-like or interface type.
	return "nil"
end

local function get_go_return_values()
	local node = ts_utils.get_node_at_cursor()

	while node do
		if
			node:type() == "function_declaration"
			or node:type() == "method_declaration"
			or node:type() == "func_literal"
		then
			break
		end
		node = node:parent()
	end

	if not node then
		return sn(nil, t("return err"))
	end

	-- Better approach: get 'result' field
	local result_nodes = node:field("result")

	if #result_nodes == 0 then
		return sn(nil, t("return err"))
	end

	local result = result_nodes[1]
	local ret_vals = {}

	if result:type() == "parameter_list" then
		for child in result:iter_children() do
			if child:type() == "parameter_declaration" then
				local type_node = child:field("type")[1]
				local name_nodes = child:field("name")
				if type_node then
					local type_text = vim.treesitter.get_node_text(type_node, 0)
					if #name_nodes > 0 then
						-- (x, y int) -> add "0" twice
						for _ = 1, #name_nodes do
							table.insert(ret_vals, type_text)
						end
					else
						-- (int) -> add "0" once
						table.insert(ret_vals, type_text)
					end
				end
			elseif
				child:type() == "type_identifier"
				or child:type() == "pointer_type"
				or child:type() == "qualified_type"
				or child:type() == "map_type"
				or child:type() == "slice_type"
				or child:type() == "array_type"
				or child:type() == "channel_type"
				or child:type() == "interface_type"
				or child:type() == "struct_type"
				or child:type() == "function_type"
			then
				table.insert(ret_vals, vim.treesitter.get_node_text(child, 0))
			end
		end
	else
		-- Single return type directly in result field (e.g., func foo() error)
		table.insert(ret_vals, vim.treesitter.get_node_text(result, 0))
	end

	-- Generate return string
	local parts = {}
	for _, type_str in ipairs(ret_vals) do
		table.insert(parts, get_zero_value(type_str))
	end

	-- If we found nothing (void return?), just return
	if #parts == 0 then
		return sn(nil, t("return err"))
	end

	return sn(nil, t("return " .. table.concat(parts, ", ")))
end

return {
	s({ trig = "ifr", name = "If error not nil" }, {
		t("if err != nil {"),
		t({ "", "\t" }),
		d(1, get_go_return_values, {}),
		t({ "", "}" }),
		i(0),
	}),
}
