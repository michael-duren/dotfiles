return {
	-- toggle term
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ "<c-\\>", desc = "Toggle terminal" },
			{ "<leader>1", desc = "Terminal 1" },
			{ "<leader>2", desc = "Terminal 2" },
			{ "<leader>3", desc = "Terminal 3" },
			{ "<c-j>", desc = "Toggle Floating Terminal" },
		},
		config = function()
			require("toggleterm").setup({
				size = 20,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 1,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "horizontal",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved",
					winblend = 3,
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
			})

			-- lower terminals
			for i = 1, 3 do
				vim.api.nvim_set_keymap(
					"n",
					"<leader>" .. i,
					"<cmd> ToggleTerm " .. i .. "<CR>",
					{ noremap = true, silent = false }
				)
			end

			vim.api.nvim_set_keymap(
				"n",
				"<c-\\>",
				"<cmd>ToggleTerm direction=horizontal<CR>",
				{ noremap = true, silent = true }
			)
			vim.api.nvim_set_keymap(
				"t",
				"<c-\\>",
				"<cmd>ToggleTerm direction=horizontal<CR>",
				{ noremap = true, silent = true }
			)

			-- floating terminals
			vim.api.nvim_set_keymap(
				"n",
				"<c-j>",
				"<cmd>4ToggleTerm direction=float<CR>",
				{ noremap = true, silent = true }
			)
			vim.api.nvim_set_keymap(
				"t",
				"<c-j>",
				"<cmd>4ToggleTerm direction=float<CR>",
				{ noremap = true, silent = true }
			)
		end,
	},
}
