return {
	"smjonas/inc-rename.nvim",
	keys = {
		{
			"<leader>cr",
			function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end,
			desc = ":IncRename",
			{ expr = true },
		},
	},
	opts = {
		input_buffer_type = "snacks",
	},
}
