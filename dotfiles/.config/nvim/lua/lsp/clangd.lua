local utils = require("helpers.utils")

local function get_clangd_cmd()
	if utils.is_linux() then
		return "/usr/bin/clangd"
	else
		return "clangd"
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "objc", "objcpp" },
	callback = function(ev)
		vim.lsp.start({
			name = "clangd",
			cmd = { get_clangd_cmd(), "--background-index", "--clang-tidy" },
			root_dir = vim.fs.root(ev.buf, { "compile_commands.json", "Makefile", ".git" }),
		})
	end,
})
