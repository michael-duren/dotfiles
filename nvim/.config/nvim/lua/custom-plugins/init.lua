require("custom-plugins.lines-of-code").setup()
require("custom-plugins.notepad").setup({
	width = 0.8,
	height = 0.8,
	border = "single",
	keymap = "<leader>np",
	notes_dir = vim.fn.stdpath("data") .. "/notes",
})
