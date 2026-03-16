return {
	"pcolladosoto/tinygo.nvim",
	opts = {
		".tingygo.json",
	},
  lazy = false,
  priority = 1000,
	keys = {
		{ "<leader>tp", "<cmd>TinyGoSetTarget pico<CR>", desc = "Tiny go set pico as target" },
	},
}
