vim.api.nvim_create_autocmd("FileType", {
	pattern = "yaml.docker-compose",
	callback = function(ev)
		vim.lsp.start({
			name = "docker_compose_language_service",
			cmd = { "docker-compose-langserver", "--stdio" },
			root_dir = vim.fs.root(ev.buf, { "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml", ".git" })
				or vim.fn.getcwd(),
		})
	end,
})

-- Detect docker-compose files and set the composite filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = {
		"docker-compose.yml",
		"docker-compose.yaml",
		"docker-compose.*.yml",
		"docker-compose.*.yaml",
		"compose.yml",
		"compose.yaml",
		"compose.*.yml",
		"compose.*.yaml",
	},
	callback = function()
		vim.bo.filetype = "yaml.docker-compose"
	end,
})
