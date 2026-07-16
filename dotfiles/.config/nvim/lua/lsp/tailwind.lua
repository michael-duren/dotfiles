-- Tailwind CSS language server (installed via mason as "tailwindcss").
-- Started by hand like the other servers in lua/lsp/ — it's excluded from
-- mason-lspconfig's automatic_enable in plugins/mason.lua.
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"astro",
		"templ",
	},
	callback = function(ev)
		-- Tailwind v3 projects root on a config file.
		local root = vim.fs.root(ev.buf, {
			"tailwind.config.js",
			"tailwind.config.cjs",
			"tailwind.config.mjs",
			"tailwind.config.ts",
		})

		-- Tailwind v4 configures itself in CSS (`@import "tailwindcss"`), so
		-- there may be no config file. Fall back to a package.json that
		-- declares tailwind as a dependency.
		if not root then
			local pkg_root = vim.fs.root(ev.buf, "package.json")
			if pkg_root then
				local ok, pkg = pcall(vim.fn.readfile, pkg_root .. "/package.json")
				if ok and table.concat(pkg, "\n"):find('"tailwindcss"', 1, true) then
					root = pkg_root
				end
			end
		end

		-- No tailwind in this project — don't start the server at all.
		if not root then
			return
		end

		vim.lsp.start({
			name = "tailwindcss",
			cmd = { "tailwindcss-language-server", "--stdio" },
			root_dir = root,
			settings = {
				tailwindCSS = {
					-- tailwind's server doesn't know the templ filetype; treat it as html
					includeLanguages = { templ = "html" },
				},
			},
		})
	end,
})
