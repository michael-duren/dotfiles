return {
	"alexghergh/nvim-tmux-navigation",
	event = "VeryLazy",
	config = function()
		local nav = require("nvim-tmux-navigation")

		nav.setup({
			disable_when_zoomed = true,
		})

		vim.keymap.set("n", "<C-h>", nav.NvimTmuxNavigateLeft, { desc = "Navigate left (nvim/tmux)", silent = true })
		vim.keymap.set("n", "<C-j>", nav.NvimTmuxNavigateDown, { desc = "Navigate down (nvim/tmux)", silent = true })
		vim.keymap.set("n", "<C-k>", nav.NvimTmuxNavigateUp, { desc = "Navigate up (nvim/tmux)", silent = true })
		vim.keymap.set("n", "<C-l>", nav.NvimTmuxNavigateRight, { desc = "Navigate right (nvim/tmux)", silent = true })
	end,
}
