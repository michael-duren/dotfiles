return {
	{
		"saghen/blink.cmp",
		version = "*",
		event = "InsertEnter",
		dependencies = { "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets" },
		opts = {
			keymap = {
				preset = "default",
				["<CR>"] = { "accept", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<C-e>"] = { "hide", "fallback" },
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					dbee = {
						name = "dbee",
						module = "helpers.blink-nvim-dbee",
						score_offset = 10,
					},
				},
				per_filetype = {
					sql = { "lsp", "dbee", "path", "snippets", "buffer" },
					mysql = { "lsp", "dbee", "path", "snippets", "buffer" },
					plsql = { "lsp", "dbee", "path", "snippets", "buffer" },
				},
			},
			signature = {
				enabled = true,
				window = { border = "rounded" },
			},
			snippets = {
				preset = "luasnip",
			},
			completion = {
				menu = {
					border = "rounded",
				},
				documentation = {
					window = {
						border = "rounded",
					},
				},
			},
		},
		config = function(_, opts)
			local icons = require("config.icons")

			-- Add kinds icons to opts
			opts.appearance = opts.appearance or {}
			opts.appearance.kind_icons = icons.kinds

			require("blink.cmp").setup(opts)
			-- Load friendly-snippets
			require("luasnip.loaders.from_vscode").lazy_load()
			local snippetPath = vim.fn.stdpath("config") .. "/snippets"
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippetPath } })
		end,
	},
}
