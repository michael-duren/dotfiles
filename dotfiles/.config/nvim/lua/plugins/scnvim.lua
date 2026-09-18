local function setup()
	local scnvim = require("scnvim")
	local map = scnvim.map
	local map_expr = scnvim.map_expr

	scnvim.setup({
		keymaps = {
			["<leader>Ce"] = map("editor.send_line", { "i", "n" }),
			["<leader>CE"] = {
				map("editor.send_block", { "i", "n" }),
				map("editor.send_selection", "x"),
			},
			["<leader><CR>"] = map("postwin.toggle"),
			["<leader>C<CR>"] = map("postwin.toggle", "i"),
			["<M-L>"] = map("postwin.clear", { "n", "i" }),
			["K"] = map("signature.show", { "n", "i" }),
			["<F12>"] = map("sclang.hard_stop", { "n", "x", "i" }),
			["<leader>Cs"] = map("sclang.start"),
			["<leader>Cr"] = map("sclang.recompile"),
			["<leader>Cb"] = map_expr("s.boot"),
			["<leader>CS"] = map(function()
				vim.cmd("SCNvimStart")
				vim.defer_fn(function()
					require("scnvim").send("s.boot")
				end, 2000)
			end),
			["<F2>"] = map_expr("s.meter"),
		},
		editor = {
			highlight = {
				color = "IncSearch",
			},
		},
		postwin = {
			float = {
				enabled = true,
			},
		},
	})
end

return {
	"davidgranstrom/scnvim",
	lazy = false,
	config = function()
		setup()
	end,
}
