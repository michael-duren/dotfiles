local root_markers = {
	"pyproject.toml",
	"setup.py",
	"setup.cfg",
	"requirements.txt",
	"Pipfile",
	"uv.lock",
	".git",
}

---Resolve the interpreter for a given project root. basedpyright only sees
---third-party packages if it is pointed at the venv that holds them; without
---this every non-stdlib import reports as unresolved.
local function python_path(root)
	local venv = vim.env.VIRTUAL_ENV
	if venv and venv ~= "" then
		return venv .. "/bin/python"
	end
	for _, dir in ipairs({ ".venv", "venv" }) do
		local candidate = root .. "/" .. dir .. "/bin/python"
		if vim.uv.fs_stat(candidate) then
			return candidate
		end
	end
	return vim.fn.exepath("python3")
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function(ev)
		local root = vim.fs.root(ev.buf, root_markers) or vim.fn.getcwd()

		vim.lsp.start({
			name = "basedpyright",
			cmd = { "basedpyright-langserver", "--stdio" },
			root_dir = root,
			settings = {
				python = {
					pythonPath = python_path(root),
				},
				basedpyright = {
					-- ruff owns imports and lint fixes, so don't duplicate them
					disableOrganizeImports = true,
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "openFilesOnly",
						-- basedpyright defaults to "recommended", which is far
						-- stricter than upstream pyright and floods untyped code
						typeCheckingMode = "standard",
					},
				},
			},
		})

		vim.lsp.start({
			name = "ruff",
			cmd = { "ruff", "server" },
			root_dir = root,
			init_options = {
				settings = {
					lineLength = 88,
				},
			},
			on_attach = function(client)
				-- basedpyright owns hover; two providers means duplicate popups
				client.server_capabilities.hoverProvider = false
			end,
		})
	end,
})
