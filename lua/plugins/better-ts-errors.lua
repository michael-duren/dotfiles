-- TODO: actually set this up at some point
if true then
	return {}
end
-- stable version
return {
	"OlegGulevskyy/better-ts-errors.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	config = {
		keymaps = {
			toggle = "<leader>dd", -- default '<leader>dd'
			go_to_definition = "<leader>dx", -- default '<leader>dx'
		},
	},
}
