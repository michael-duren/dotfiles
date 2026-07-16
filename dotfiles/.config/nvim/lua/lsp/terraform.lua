-- Map OpenTofu files to the terraform filetype so they get the same
-- treesitter grammar, LSP, snippets, and formatting as .tf files.
vim.filetype.add({
	extension = {
		tofu = "terraform",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "terraform", "terraform-vars" },
	callback = function(ev)
		-- Each directory is a Terraform module; prefer module markers over .git
		-- (same worktree reasoning as gopls.lua) and fall back to the file's dir.
		local root = vim.fs.root(ev.buf, { ".terraform", ".terraform.lock.hcl" })
			or vim.fs.dirname(vim.api.nvim_buf_get_name(ev.buf))

		vim.lsp.start({
			name = "terraformls",
			cmd = { "terraform-ls", "serve" },
			root_dir = root,
			reuse_client = function(client, config)
				return client.config.root_dir == config.root_dir
			end,
			init_options = {
				-- terraform-ls shells out to the terraform binary for version/schema
				-- discovery; point it at tofu since terraform isn't installed.
				terraform = {
					path = vim.fn.exepath("tofu"),
				},
			},
		})
	end,
})
