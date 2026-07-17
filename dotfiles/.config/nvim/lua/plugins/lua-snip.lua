return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp",
	dependencies = { "rafamadriz/friendly-snippets" },
	-- loaded on demand as a dependency of blink.cmp (InsertEnter)
	lazy = true,
	config = function()
		-- All snippet loading lives here (blink.cmp must not load snippets again):
		-- friendly-snippets (vscode format), custom vscode snippets in
		-- snippets/ (package.json), and custom lua snippets in snippets/*.lua.
		local snippet_path = vim.fn.stdpath("config") .. "/snippets"
		require("luasnip.loaders.from_vscode").lazy_load()
		require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippet_path } })
		require("luasnip.loaders.from_lua").load({ paths = { snippet_path } })
	end,
}
