return {
	"ziglang/zig.vim",
	ft = "zig",
	config = function()
		-- Set zig format on save
		vim.g.zig_fmt_autosave = 1

		-- Set up keybindings for Zig files
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "zig",
			callback = function()
				local opts = { buffer = true, silent = true }

				-- Run current file with zig run
				vim.keymap.set("n", "<leader>zr", function()
					local file = vim.fn.expand("%:p")
					vim.cmd("split | terminal zig run " .. file)
				end, vim.tbl_extend("force", opts, { desc = "Zig: Run current file" }))

				-- Build current file with zig build-exe
				vim.keymap.set("n", "<leader>zb", function()
					vim.cmd("compiler zig_build_exe")
					vim.cmd("make")
				end, vim.tbl_extend("force", opts, { desc = "Zig: Build current file" }))

				-- Test current file with zig test
				vim.keymap.set("n", "<leader>zt", function()
					vim.cmd("compiler zig_test")
					vim.cmd("make")
				end, vim.tbl_extend("force", opts, { desc = "Zig: Test current file" }))

				-- Build project (if build.zig exists)
				vim.keymap.set("n", "<leader>zB", function()
					vim.cmd("compiler zig_build")
					vim.cmd("make")
				end, vim.tbl_extend("force", opts, { desc = "Zig: Build project" }))

				-- Run current file in floating terminal
				vim.keymap.set("n", "<leader>zR", function()
					local file = vim.fn.expand("%:p")
					vim.cmd("terminal zig run " .. file)
				end, vim.tbl_extend("force", opts, { desc = "Zig: Run in terminal" }))

				-- Format current file
				vim.keymap.set("n", "<leader>zf", function()
					vim.cmd("!zig fmt %")
				end, vim.tbl_extend("force", opts, { desc = "Zig: Format file" }))
			end,
		})
	end,
}
