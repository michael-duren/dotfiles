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
			{ "<leader>4", desc = "Terminal 4 (float)" },
			{ "<leader>5", desc = "Terminal 5 (tab)" },
			{ "<leader>ot", desc = "Terminal (buffer dir)" },
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

		-- <c-/> sends \x1b[45~ via Ghostty keybind
		vim.api.nvim_set_keymap("n", "<leader>4", "<cmd>4ToggleTerm direction=float<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("t", "<leader>4", "<cmd>4ToggleTerm direction=float<CR>", { noremap = true, silent = true })

		-- <c-s-/> sends \x1b[46~ via Ghostty keybind
		vim.api.nvim_set_keymap("n", "<leader>5", "<cmd>5ToggleTerm direction=tab<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("t", "<leader>5", "<cmd>5ToggleTerm direction=tab<CR>", { noremap = true, silent = true })

			-- open terminal in current buffer's directory
			vim.keymap.set("n", "<leader>ot", function()
				local buf_dir = vim.fn.expand("%:p:h")
				require("toggleterm.terminal").Terminal
					:new({ dir = buf_dir, direction = "horizontal", id = 6 })
					:toggle()
			end, { noremap = true, silent = true, desc = "Terminal (buffer dir)" })
		end,
	},
}
