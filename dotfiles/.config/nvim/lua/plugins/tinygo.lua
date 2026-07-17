return {
	"pcolladosoto/tinygo.nvim",
	-- The plugin shells out to the `tinygo` binary on load; skip it entirely
	-- when tinygo isn't installed (it printed "tinygo: command not found" on
	-- every startup otherwise).
	cond = function()
		return vim.fn.executable("tinygo") == 1
	end,
	ft = "go",
	opts = {
		".tinygo.json",
	},
	keys = {
		{ "<leader>tp", "<cmd>TinyGoSetTarget pico<CR>", desc = "Tiny go set pico as target" },
	},
}
