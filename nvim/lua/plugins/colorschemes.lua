local themes = {
	-- Existing popular themes
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				transparent = false,
				dimInactive = true,
				colors = {
					palette = {
						sumiInk0 = "#000000",
						sumiInk1 = "#141414",
						sumiInk2 = "#141414",
						sumiInk3 = "#000000",
						sumiInk4 = "#000000",
					},
				},
			})
		end,
	},
	{
		"decaycs/decay.nvim",
		priority = 1000,
		config = function()
			require("decay").setup({
				style = "decayce",
				nvim_tree = {
					contrast = false,
				},
			})
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "moon",
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
				integrations = {
					aerial = true,
					alpha = true,
					cmp = true,
					dashboard = true,
					flash = true,
					gitsigns = true,
					headlines = true,
					illuminate = true,
					indent_blankline = { enabled = true },
					leap = true,
					lsp_trouble = true,
					mason = true,
					markdown = true,
					mini = true,
					native_lsp = {
						enabled = true,
						underlines = {
							errors = { "undercurl" },
							hints = { "undercurl" },
							warnings = { "undercurl" },
							information = { "undercurl" },
						},
					},
					navic = {
						enabled = true,
						custom_bg = "lualine",
					},
					neotest = true,
					neotree = true,
					noice = true,
					notify = true,
					semantic_tokens = true,
					telescope = true,
					treesitter = true,
					treesitter_context = true,
					which_key = true,
				},
			})
		end,
	},
	{
		"shaunsingh/nord.nvim",
		priority = 1000,
	},
	{
		"oxfist/night-owl.nvim",
		priority = 1000,
		config = function()
			require("night-owl").setup()
		end,
	},
	{
		"uloco/bluloco.nvim",
		priority = 1000,
		dependencies = { "rktjmp/lush.nvim" },
		config = function()
			require("bluloco").setup({
				style = "dark",
				italics = true,
				terminal = vim.fn.has("gui_running") == 1,
				guicursor = true,
			})
		end,
	},
	{
		"sho-87/kanagawa-paper.nvim",
		priority = 1000,
		opts = {
			undercurl = true,
			dimInactive = false,
			terminalColors = true,
			commentStyle = { italic = true },
			functionStyle = { italic = false },
			keywordStyle = { italic = false, bold = true },
			statementStyle = { italic = false, bold = false },
			typeStyle = { italic = false },
		},
	},
	{
		"slugbyte/lackluster.nvim",
		priority = 1000,
		config = function()
			local lackluster = require("lackluster")
			local color = lackluster.color
			lackluster.setup({
				tweak_syntax = {
					comment = lackluster.color.gray4,
					string = color.green,
					string_escape = color.red,
				},
				tweak_background = {
					normal = "none",
					telescope = "none",
					menu = lackluster.color.gray3,
					popup = "default",
				},
			})
		end,
	},
	{
		"tiagovla/tokyodark.nvim",
		opts = {
			transparent_background = true,
		},
	},
	{ "navarasu/onedark.nvim" },
	{ "sainnhe/everforest" },
	{ "marko-cerovac/material.nvim" },
	{ "olimorris/onedarkpro.nvim" },
	{ "AlexvZyl/nordic.nvim" },
	{ "sainnhe/edge" },
	{ "mcchrish/zenbones.nvim" },
	{ "rafamadriz/neon" },
	{
		"olivercederborg/poimandres.nvim",
		priority = 1000,
		config = function()
			require("poimandres").setup({
				disable_background = true,
			})
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				variant = "moon",
				dark_variant = "moon",
				dim_inactive_windows = false,
				extend_background_behind_borders = true,
				styles = {
					transparent = true,
				},
			})
		end,
	},
	{
		"metalelf0/black-metal-theme-neovim",
		priority = 1000,
		config = function()
			require("black-metal").setup({
				theme = "dark-funeral",
				transparent = true,
				diagnostics = {
					darker = true,
					undercurl = true,
					background = false,
				},
			})
		end,
	},

	-- NEW THEMES
	{
		"EdenEast/nightfox.nvim",
		priority = 1000,
		config = function()
			require("nightfox").setup({
				options = {
					transparent = true,
				},
			})
		end,
	},
	{
		"scottmckendry/cyberdream.nvim",
		priority = 1000,
		config = function()
			require("cyberdream").setup({
				transparent = true,
				italic_comments = true,
				hide_fillchars = true,
				borderless_telescope = true,
			})
		end,
	},
	{
		"Mofiqul/dracula.nvim",
		priority = 1000,
	},
	{
		"kvrohit/mellow.nvim",
		priority = 1000,
	},
	{
		"ribru17/bamboo.nvim",
		priority = 1000,
	},
}

return themes
