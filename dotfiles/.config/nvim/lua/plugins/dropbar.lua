return {
	"Bekaboo/dropbar.nvim",
	event = "VeryLazy",
	opts = {
		bar = {
			enable = function(buf, win, _)
				local ft = vim.bo[buf].filetype
				local disabled = {
					"toggleterm",
					"oil",
					"snacks_dashboard",
					"snacks_explorer",
					"dap-repl",
					"dapui_console",
					"dapui_watches",
					"dapui_stacks",
					"dapui_breakpoints",
					"dapui_scopes",
				}
				for _, v in ipairs(disabled) do
					if ft == v then
						return false
					end
				end
				return vim.fn.win_gettype(win) == ""
					and vim.bo[buf].buftype == ""
					and vim.api.nvim_buf_get_name(buf) ~= ""
			end,
		},
	},
	keys = {
		{
			"<leader>;",
			function()
				require("dropbar.api").pick()
			end,
			desc = "Dropbar pick",
		},
	},
}
