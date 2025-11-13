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
			require("dbee").install()
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
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"MattiasMTS/cmp-dbee",
				dependencies = {
					{ "kndndrj/nvim-dbee" },
				},
				ft = "sql", -- optional but good to have
				opts = {}, -- needed
			},
		},
		opts = {
			sources = {
				{ "cmp-dbee" },
			},
		},
	},
}
