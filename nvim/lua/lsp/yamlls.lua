-- TODO: some point adapt this for other filetypes like yml, helm, etc.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "yaml",
	callback = function(ev)
		local schemas = require("schemastore").yaml.schemas()

		schemas["kubernetes"] = "*.yaml"

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
					kubernetes = true,
				},
			},
		})
	end,
})
