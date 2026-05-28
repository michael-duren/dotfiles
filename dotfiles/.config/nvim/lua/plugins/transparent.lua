local utils = require("helpers.utils")

if not utils.is_linux() then
  return {}
end

return {
	"xiyaowong/transparent.nvim",
	lazy = false,
	priority = 1100,
	config = function()
		require("transparent").setup({
			extra_groups = {
				"Normal",
				"NormalNC",
				"NormalFloat",
				"FloatBorder",
				"FloatTitle",
				"SignColumn",
				"EndOfBuffer",
				"LineNr",
				"CursorLineNr",
				"StatusLine",
				"StatusLineNC",
				"WinBar",
				"WinBarNC",
				"MsgArea",
				"Pmenu",
				"TabLine",
				"TabLineFill",
				"WhichKeyFloat",
				"WhichKeyBorder",
				"TelescopeNormal",
				"TelescopeBorder",
				"TelescopePromptNormal",
				"TelescopePromptBorder",
				"TelescopeResultsNormal",
				"TelescopeResultsBorder",
				"TelescopePreviewNormal",
				"TelescopePreviewBorder",
				"NvimTreeNormal",
				"NeoTreeNormal",
				"NeoTreeNormalNC",
				"NeoTreeEndOfBuffer",
				"NoiceCmdlinePopup",
				"NoiceCmdlinePopupBorder",
				"NoicePopup",
				"NoicePopupBorder",
				"NotifyBackground",
			},
		})
		-- require("transparent").clear_prefix("BufferLine")
		require("transparent").clear_prefix("NeoTree")
		-- require("transparent").clear_prefix("Lualine")
		require("transparent").clear_prefix("Dashboard")
		require("transparent").clear_prefix("Snacks")
		vim.cmd("TransparentEnable")
	end,
	keys = {
		{
			"<leader>Tt",
			"<cmd>TransparentToggle<CR>",
			desc = "Toggle transparent view",
		},
	},
}
