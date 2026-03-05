vim.api.nvim_create_autocmd("FileType", {
	pattern = "helm",
	callback = function(ev)
		vim.lsp.start({
			name = "helm_ls",
			cmd = { "helm_ls", "serve" },
			root_dir = vim.fs.root(ev.buf, { "Chart.yaml", "Chart.lock" }) or vim.fn.getcwd(),
			settings = {
				["helm-ls"] = {
					yamlls = {
						path = "yaml-language-server",
					},
				},
			},
		})
	end,
})

-- Detect Helm chart templates and set filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*/templates/*.yaml", "*/templates/*.yml", "*/templates/*.tpl", "*/templates/NOTES.txt" },
	callback = function(ev)
		-- Only set helm filetype if we're inside a Helm chart (Chart.yaml exists in parent)
		if vim.fs.root(ev.buf, { "Chart.yaml" }) then
			vim.bo.filetype = "helm"
		end
	end,
})
