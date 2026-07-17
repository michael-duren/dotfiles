return {
	"ej-shafran/compile-mode.nvim",
	version = "^5.0.0",
	-- lazy-load: the plugin is only needed once one of its commands runs
	cmd = { "Compile", "Recompile" },
	-- you can just use the latest version:
	-- branch = "latest",
	-- or the most up-to-date updates:
	-- branch = "nightly",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- if you want to enable coloring of ANSI escape codes in
		-- compilation output, add:
		{ "m00qek/baleia.nvim", tag = "v1.3.0" },
	},
	-- init (not config) so vim.g.compile_mode is set before the plugin loads
	init = function()
		---@type CompileModeOpts
		vim.g.compile_mode = {
			-- if you use something like `nvim-cmp` or `blink.cmp` for completion,
			-- set this to fix tab completion in command mode:
			-- input_word_completion = true,

			-- to add ANSI escape code support, add:
			-- baleia_setup = true,

			-- to make `:Compile` replace special characters (e.g. `%`) in
			-- the command (and behave more like `:!`), add:
			-- bang_expansion = true,
		}
	end,
}
