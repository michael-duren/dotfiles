-- MDX support (Astro `.mdx` content files)
--
-- nvim-treesitter has no dedicated `mdx` grammar, so we:
--   1. teach Neovim that `.mdx` is its own filetype,
--   2. reuse the already-installed `markdown` parser for highlighting,
--   3. attach marksman (already in mason) for LSP features.

-- 1. Filetype detection. Runs at startup (before any file is opened), the same
--    way roslyn.lua registers .razor/.cshtml.
vim.filetype.add({
	extension = {
		mdx = "mdx",
	},
})

-- 2. Treesitter: map the `mdx` filetype onto the `markdown` parser. The global
--    FileType="*" autocmd in plugins/treesitter.lua calls vim.treesitter.start(),
--    which resolves filetype -> language via this registration. markdown_inline
--    injections come along for free via the markdown parser's injection queries.
vim.treesitter.language.register("markdown", "mdx")

-- 3. LSP + buffer-local settings on the mdx filetype.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "mdx",
	callback = function(ev)
		-- marksman handles markdown/mdx: links, completion, document symbols.
		vim.lsp.start({
			name = "marksman",
			cmd = { "marksman", "server" },
			root_dir = vim.fs.root(ev.buf, { ".marksman.toml", ".git", "package.json" }) or vim.fn.getcwd(),
		})

		-- Prose niceties.
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us"
	end,
})
