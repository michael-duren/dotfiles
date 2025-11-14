return {
	{
		"kndndrj/nvim-dbee",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		build = function()
			-- Install tries to automatically detect the install method.
			-- if it fails, try calling it with one of these parameters:
			--    "curl", "wget", "bitsadmin", "go"
			require("dbee").install("go")
		end,
		keys = {
			{ "<leader>D", "<cmd>Dbee<cr>", desc = "Open Dbee" },
		},
		config = function()
			require("dbee").setup({
				sources = {
					require("dbee.sources").FileSource:new(vim.fn.stdpath("config") .. "/db/sources.json"),
				},
			})
		end,
	},
	{
		"MattiasMTS/cmp-dbee",
		dependencies = { "kndndrj/nvim-dbee" },
		ft = "sql",
		config = function()
			require("cmp-dbee").setup({})
		end,
	},
}
