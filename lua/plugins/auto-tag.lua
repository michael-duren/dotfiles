return {
	"windwp/nvim-ts-autotag",
	dependencies = "nvim-treesitter/nvim-treesitter",
	ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "tsx", "jsx", "rescript", "xml", "php", "markdown", "astro", "glimmer", "handlebars", "hbs", "svelte" },
	config = function()
		require('nvim-ts-autotag').setup()
	end,
}
