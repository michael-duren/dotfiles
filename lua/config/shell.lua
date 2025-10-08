if vim.fn.has("win32") == 1 then
	vim.opt.shell = "pwsh"
	vim.opt.shellcmdflag = "-nologo -ExecutionPolicy RemoteSigned -command"
	vim.opt.shellxquote = ""
end
