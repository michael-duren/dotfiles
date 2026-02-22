vim.api.nvim_create_autocmd("FileType", {
	pattern = "yaml",
	callback = function(ev)
		local schemas = require("schemastore").yaml.schemas()
		local filepath = vim.api.nvim_buf_get_name(ev.buf)
		local filename = vim.fn.fnamemodify(filepath, ":t")

		if filename == "sqlc.yaml" then
			-- Use SQLC schema for sqlc.yaml files
			schemas["sqlc"] = "sqlc.yaml"
		end
		if filepath:match("/deployment/") or filename:match("/deployments/") then
			schemas["kubernetes"] = "*.yaml"
		end
		-- Just add K8s schema - no cluster needed

		vim.lsp.start({
			name = "yamlls",
			cmd = { "yaml-language-server", "--stdio" },
			root_dir = vim.fs.root(ev.buf, { ".git" }) or vim.fn.getcwd(),
			settings = {
				yaml = {
					schemaStore = {
						enable = false,
						url = "",
					},
					schemas = schemas,
					validate = true,
				},
			},
		})
	end,
})
