return {
	"grindlemire/go-tui",
	ft = "gsx",
	-- The real Neovim plugin lives in the repo's editor/nvim subdirectory, not the repo
	-- root. lazy only puts the repo root on the runtimepath, so we prepend the subdir
	-- ourselves at startup. This also makes editor/nvim/plugin/gsx.lua (filetype
	-- registration) and the ftdetect/ + queries/ dirs discoverable.
	init = function()
		vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/go-tui/editor/nvim")
	end,
	config = function()
		require("gsx").setup({
			lsp = { enabled = true, cmd = { "tui", "lsp" } },
			-- If nvim can't find `tui` on its PATH (see verification), use an absolute
			-- path instead:
			-- lsp = { cmd = { vim.fn.expand("~/go/bin/tui"), "lsp" } },
		})

		-- Build helper: compile the current file's package (.gsx -> *_gsx.go), async.
		vim.api.nvim_create_user_command("GsxGenerate", function()
			local dir = vim.fn.expand("%:p:h")
			vim.system({ "tui", "generate", dir }, { text = true }, function(o)
				vim.schedule(function()
					if o.code ~= 0 then
						vim.notify("[gsx] generate failed: " .. (o.stderr or ""), vim.log.levels.ERROR)
					else
						vim.notify("[gsx] generated", vim.log.levels.INFO)
					end
				end)
			end)
		end, { desc = "Run `tui generate` for the current .gsx file's package" })

		-- Auto-regenerate on save (quiet on success; only notifies on failure).
		-- Delete this autocmd block if you'd rather generate manually with :GsxGenerate.
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = "*.gsx",
			callback = function(ev)
				local dir = vim.fn.fnamemodify(ev.file, ":h")
				vim.system({ "tui", "generate", dir }, { text = true }, function(o)
					if o.code ~= 0 then
						vim.schedule(function()
							vim.notify("[gsx] generate failed: " .. (o.stderr or ""), vim.log.levels.WARN)
						end)
					end
				end)
			end,
		})
	end,
}
