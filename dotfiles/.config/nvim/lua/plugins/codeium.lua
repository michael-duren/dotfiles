if true then
	return {}
end

-- issues with oil.nvim and this plugin
return {
	"Exafunction/windsurf.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("codeium").setup({})
	end,
	keys = {
		{
			"<leader>cc",
			function()
				require("codeium").toggle()
			end,
			desc = "Codeium",
		},
		{
			"<leader>cC",
			function()
				vim.cmd("Codeium Chat")
			end,
			desc = "Codeium Accept",
		},
	},
}
