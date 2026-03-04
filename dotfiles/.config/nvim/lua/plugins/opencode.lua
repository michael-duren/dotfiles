return {
	"nickjvandyke/opencode.nvim",
	version = "*",
	dependencies = {
		{
			---@module "snacks"
			"folke/snacks.nvim",
			optional = true,
			opts = {
				input = {},
				picker = {
					actions = {
						opencode_send = function(...)
							return require("opencode").snacks_picker_send(...)
						end,
					},
					win = {
						input = {
							keys = {
								["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
							},
						},
					},
				},
			},
		},
	},
	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {}

		vim.o.autoread = true

		-- Ask opencode with current context
		vim.keymap.set({ "n", "x" }, "<leader>aa", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Ask opencode" })

		-- Select from opencode actions (prompts, commands, server controls)
		vim.keymap.set({ "n", "x" }, "<leader>ax", function()
			require("opencode").select()
		end, { desc = "Execute opencode action" })

		-- Toggle opencode terminal
		vim.keymap.set({ "n", "t" }, "<leader>at", function()
			require("opencode").toggle()
		end, { desc = "Toggle opencode" })

		-- Operator to add range to opencode prompt
		vim.keymap.set({ "n", "x" }, "<leader>ao", function()
			return require("opencode").operator("@this ")
		end, { desc = "Add range to opencode", expr = true })

		-- Operator to add current line to opencode prompt
		vim.keymap.set("n", "<leader>aoo", function()
			return require("opencode").operator("@this ") .. "_"
		end, { desc = "Add line to opencode", expr = true })

		-- Scroll opencode messages
		vim.keymap.set("n", "<S-C-u>", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "Scroll opencode up" })

		vim.keymap.set("n", "<S-C-d>", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "Scroll opencode down" })
	end,
}
