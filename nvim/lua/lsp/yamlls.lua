vim.api.nvim_create_autocmd("FileType", {
	pattern = "yaml",
	callback = function(ev)
		vim.lsp.start({
			name = "yamlls",
			cmd = { "yaml-language-server", "--stdio" },
			root_dir = vim.fs.root(ev.buf, { ".git" }) or vim.fn.getcwd(),
			settings = {
				yaml = {
					schemas = {
						["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/all.json"] = "*.yaml",
						-- ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
						-- ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
						-- ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
						-- ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
					},
					validate = true,
					completion = true,
					hover = true,
				},
			},
		})
	end,
})
