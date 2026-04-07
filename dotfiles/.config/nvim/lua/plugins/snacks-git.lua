-- Snacks.nvim GitHub Integration
-- This file configures Snacks' built-in gh module for GitHub PR and issue management
-- Requires: gh CLI (GitHub CLI) to be installed and authenticated
--
-- Features:
-- - Browse and search PRs/issues with fuzzy finding
-- - View full PR details with comments, reactions, status checks
-- - Review PRs (approve, request changes, comment)
-- - Checkout PR branches locally
-- - View PR diffs with syntax highlighting
-- - Add comments, reactions, labels
-- - Close, reopen, edit, merge PRs

return {
	"folke/snacks.nvim",
	optional = true,
	init = function()
		-- GitHub PR Review Help Function
		local function show_github_help()
			local lines = {
				"",
				"╔══════════════════════════════════════════════════════════════════════════╗",
				"║                   GitHub PR Review Quick Reference                       ║",
				"╚══════════════════════════════════════════════════════════════════════════╝",
				"",
				"┌─ BROWSE (Snacks) ─────────────────────────────────────────────────────┐",
				"│ <leader>gp  │ Browse open PRs                                          │",
				"│ <leader>gP  │ Browse all PRs                                           │",
				"│ <leader>gi  │ Browse open issues                                       │",
				"│ <leader>go  │ Open PR in Octo (for inline comments)                   │",
				"└───────────────────────────────────────────────────────────────────────┘",
				"",
				"┌─ WORKTREES ───────────────────────────────────────────────────────────┐",
				"│ <leader>gw  │ Worktree picker (switch/create/delete)                   │",
				"│ <leader>gwc │ Create new worktree                                      │",
				"│ <leader>gws │ Switch worktree                                          │",
				"│ <leader>gwd │ Delete worktree                                          │",
				"└───────────────────────────────────────────────────────────────────────┘",
				"",
				"┌─ REVIEW (Octo) ───────────────────────────────────────────────────────┐",
				"│ <leader>or  │ Show Octo commands                                       │",
				"│ <leader>oe  │ Edit PR by number                                        │",
				"│ <leader>ors │ Start review (opens diff view)                           │",
				"│ <leader>orv │ Submit review                                            │",
				"│ <leader>op  │ Checkout PR branch (creates worktree)                   │",
				"└───────────────────────────────────────────────────────────────────────┘",
				"",
				"┌─ IN REVIEW MODE ──────────────────────────────────────────────────────┐",
				"│ 💬 INLINE COMMENTS (THE MAIN FEATURE!)                                 │",
				"│ <localleader>ca │ Add comment on line(s)                               │",
				"│ <localleader>sa │ Add code suggestion (visual mode)                    │",
				"│                                                                         │",
				"│ 🧭 NAVIGATION                                                           │",
				"│ ]q / [q         │ Next/Previous changed file                           │",
				"│ ]c / [c         │ Next/Previous comment                                │",
				"│ ]t / [t         │ Next/Previous thread                                 │",
				"│                                                                         │",
				"│ 🎯 ACTIONS                                                              │",
				"│ <localleader>vs │ Submit review                                        │",
				"│ <localleader>rt │ Resolve thread                                       │",
				"│ <localleader>cd │ Delete comment                                       │",
				"│ <localleader>e  │ Focus files panel                                    │",
				"│                                                                         │",
				"│ 😄 REACTIONS                                                            │",
				"│ <localleader>r+ │ 👍  <localleader>r- │ 👎                             │",
				"│ <localleader>re │ 👀  <localleader>rp │ 🎉                             │",
				"│ <localleader>rh │ ❤️   <localleader>rr │ 🚀                             │",
				"└───────────────────────────────────────────────────────────────────────┘",
				"",
				"┌─ SUBMIT REVIEW WINDOW ────────────────────────────────────────────────┐",
				"│ <C-a>  │ Approve PR                                                    │",
				"│ <C-r>  │ Request changes                                               │",
				"│ <C-m>  │ Comment only                                                  │",
				"│ <C-c>  │ Cancel                                                        │",
				"└───────────────────────────────────────────────────────────────────────┘",
				"",
				"┌─ TYPICAL WORKFLOW ────────────────────────────────────────────────────┐",
				"│ 1. <leader>gp           → Browse PRs in snacks                         │",
				"│ 2. <leader>go           → Open in Octo for detailed review            │",
				"│ 3. <leader>ors          → Start review mode (see diffs)               │",
				"│ 4. Navigate with ]q/[q  → Move through changed files                  │",
				"│ 5. <localleader>ca      → Add inline comments on code                 │",
				"│ 6. <localleader>sa      → Add code suggestions (visual mode)          │",
				"│ 7. <localleader>vs      → Submit review                               │",
				"│ 8. <C-a>                → Approve!                                     │",
				"└───────────────────────────────────────────────────────────────────────┘",
				"",
				"┌─ PRO TIPS ────────────────────────────────────────────────────────────┐",
				"│ • Use <leader>op to checkout PR into a worktree with full LSP       │",
				"│ • Visual select lines before <localleader>sa for suggestions          │",
				"│ • Use <leader>orc to preview all comments before submitting           │",
				"│ • Toggle file panel with <localleader>b to focus on code              │",
				"│ • Navigate threads with ]t/[t to review all discussions               │",
				"└───────────────────────────────────────────────────────────────────────┘",
				"",
				"Press 'q' or <Esc> to close",
				"",
			}

			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			vim.api.nvim_buf_set_option(buf, "modifiable", false)
			vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
			vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
			vim.api.nvim_buf_set_option(buf, "filetype", "github-help")

			local width = 78
			local height = #lines
			local row = math.floor((vim.o.lines - height) / 2)
			local col = math.floor((vim.o.columns - width) / 2)

			local win = vim.api.nvim_open_win(buf, true, {
				relative = "editor",
				width = width,
				height = height,
				row = row,
				col = col,
				style = "minimal",
				border = "rounded",
				title = " GitHub PR Review Help ",
				title_pos = "center",
			})

			local close = function()
				vim.api.nvim_win_close(win, true)
			end

			vim.keymap.set("n", "q", close, { buffer = buf, silent = true })
			vim.keymap.set("n", "<Esc>", close, { buffer = buf, silent = true })

			vim.api.nvim_buf_call(buf, function()
				vim.cmd("syntax match GithubHelpBorder /[┌┐└┘│─═║╔╗╚╝]/")
				vim.cmd("syntax match GithubHelpKey /<[^>]*>/")
				vim.cmd("syntax match GithubHelpEmoji /[👍👎👀🎉❤️🚀😄💬🧭🎯]/")
				vim.cmd("syntax match GithubHelpTitle /║.*║/")
				vim.cmd("syntax match GithubHelpSection /┌─.*─┐/")
				vim.cmd("syntax match GithubHelpCommand /│.*│/")

				vim.cmd("highlight GithubHelpBorder guifg=#7aa2f7")
				vim.cmd("highlight GithubHelpKey guifg=#bb9af7 gui=bold")
				vim.cmd("highlight GithubHelpEmoji guifg=#f7768e")
				vim.cmd("highlight GithubHelpTitle guifg=#9ece6a gui=bold")
				vim.cmd("highlight GithubHelpSection guifg=#7dcfff gui=bold")
				vim.cmd("highlight GithubHelpCommand guifg=#c0caf5")
			end)
		end

		-- Add command and keymap
		vim.api.nvim_create_user_command("GitHubHelp", show_github_help, {})
		vim.keymap.set("n", "<leader>g?", show_github_help, { desc = "GitHub PR Review Help" })
	end,
	opts = {
		gh = {
			enabled = true,
			-- Keymaps for GitHub buffers (when viewing a PR or issue)
			keys = {
				select = { "<cr>", "gh_actions", desc = "Select Action" },
				edit = { "i", "gh_edit", desc = "Edit" },
				comment = { "a", "gh_comment", desc = "Add Comment" },
				close = { "c", "gh_close", desc = "Close" },
				reopen = { "o", "gh_reopen", desc = "Reopen" },
			},
			-- Window options for GitHub buffers
			wo = {
				breakindent = true,
				wrap = true,
				showbreak = "",
				linebreak = true,
				number = false,
				relativenumber = false,
				foldexpr = "v:lua.vim.treesitter.foldexpr()",
				foldmethod = "expr",
				concealcursor = "n",
				conceallevel = 2,
				list = false,
			},
			-- Diff display settings
			diff = {
				min = 4, -- minimum number of lines changed to show diff
				wrap = 80, -- wrap diff lines at this length
			},
			-- Scratch buffer settings (for comments, reviews, etc.)
			scratch = {
				height = 15, -- height of scratch window
			},
			-- Icons for GitHub entities
			icons = {
				logo = " ",
				user = " ",
				checkmark = " ",
				crossmark = " ",
				block = "■",
				file = " ",
				checks = {
					pending = " ",
					success = " ",
					failure = "",
					skipped = " ",
				},
				issue = {
					open = " ",
					completed = " ",
					other = " ",
				},
				pr = {
					open = " ",
					closed = " ",
					merged = " ",
					draft = " ",
					other = " ",
				},
				review = {
					approved = " ",
					changes_requested = " ",
					commented = " ",
					dismissed = " ",
					pending = " ",
				},
				merge_status = {
					clean = " ",
					dirty = " ",
					blocked = " ",
					unstable = " ",
				},
				reactions = {
					thumbs_up = "👍",
					thumbs_down = "👎",
					eyes = "👀",
					confused = "😕",
					heart = "❤️",
					hooray = "🎉",
					laugh = "😄",
					rocket = "🚀",
				},
			},
		},
	},
	keys = {
		-- GitHub Pull Requests
		{
			"<leader>gp",
			function()
				vim.cmd([[! git pull --rebase ]])
			end,
			desc = "Git pull",
		},
		{
			"<leader>gP",
			function()
				vim.cmd([[! git push ]])
			end,
			desc = "GitHub PRs (all)",
		},
		-- GitHub Issues
		{
			"<leader>gi",
			function()
				Snacks.picker.gh_issue()
			end,
			desc = "GitHub Issues (open)",
		},
		{
			"<leader>gI",
			function()
				Snacks.picker.gh_issue({ state = "all" })
			end,
			desc = "GitHub Issues (all)",
		},
		-- GitHub PR Review Helpers (using gh CLI directly to avoid API issues)
		{
			"<leader>gra",
			function()
				-- Get PR number from current buffer or prompt
				local pr_number = vim.fn.input("PR number: ")
				if pr_number ~= "" then
					-- Open scratch buffer for review body
					local scratch = Snacks.scratch({
						ft = "markdown",
						title = "Approve PR #" .. pr_number,
						footer = "Save (:w) to approve | Close (:q) to cancel",
						height = 15,
					})

					-- Set up autocmd to submit review on save
					vim.api.nvim_create_autocmd("BufWritePost", {
						buffer = scratch.buf,
						once = true,
						callback = function()
							local lines = vim.api.nvim_buf_get_lines(scratch.buf, 0, -1, false)
							local body = table.concat(lines, "\n")

							-- Submit review
							vim.fn.system(
								string.format('gh pr review %s --approve -b "%s"', pr_number, body:gsub('"', '\\"'))
							)

							if vim.v.shell_error == 0 then
								Snacks.notify.info("PR #" .. pr_number .. " approved!")
								scratch:close()
							else
								Snacks.notify.error("Failed to approve PR", { title = "Review Error" })
							end
						end,
					})
				end
			end,
			desc = "Approve PR (gh cli)",
		},
		{
			"<leader>grr",
			function()
				-- Get PR number from current buffer or prompt
				local pr_number = vim.fn.input("PR number: ")
				if pr_number ~= "" then
					-- Open scratch buffer for review body
					local scratch = Snacks.scratch({
						ft = "markdown",
						title = "Request Changes PR #" .. pr_number,
						footer = "Save (:w) to request changes | Close (:q) to cancel",
						height = 15,
					})

					-- Set up autocmd to submit review on save
					vim.api.nvim_create_autocmd("BufWritePost", {
						buffer = scratch.buf,
						once = true,
						callback = function()
							local lines = vim.api.nvim_buf_get_lines(scratch.buf, 0, -1, false)
							local body = table.concat(lines, "\n")

							-- Submit review
							vim.fn.system(
								string.format(
									'gh pr review %s --request-changes -b "%s"',
									pr_number,
									body:gsub('"', '\\"')
								)
							)

							if vim.v.shell_error == 0 then
								Snacks.notify.info("Changes requested for PR #" .. pr_number)
								scratch:close()
							else
								Snacks.notify.error("Failed to request changes", { title = "Review Error" })
							end
						end,
					})
				end
			end,
			desc = "Request Changes (gh cli)",
		},
		{
			"<leader>grc",
			function()
				-- Get PR number from current buffer or prompt
				local pr_number = vim.fn.input("PR number: ")
				if pr_number ~= "" then
					-- Open scratch buffer for comment
					local scratch = Snacks.scratch({
						ft = "markdown",
						title = "Comment on PR #" .. pr_number,
						footer = "Save (:w) to comment | Close (:q) to cancel",
						height = 15,
					})

					-- Set up autocmd to submit comment on save
					vim.api.nvim_create_autocmd("BufWritePost", {
						buffer = scratch.buf,
						once = true,
						callback = function()
							local lines = vim.api.nvim_buf_get_lines(scratch.buf, 0, -1, false)
							local body = table.concat(lines, "\n")

							-- Submit comment
							vim.fn.system(
								string.format('gh pr review %s --comment -b "%s"', pr_number, body:gsub('"', '\\"'))
							)

							if vim.v.shell_error == 0 then
								Snacks.notify.info("Comment added to PR #" .. pr_number)
								scratch:close()
							else
								Snacks.notify.error("Failed to add comment", { title = "Review Error" })
							end
						end,
					})
				end
			end,
			desc = "Comment on PR (gh cli)",
		},
		-- Quick transition to octo.nvim for detailed review with inline comments
		{
			"<leader>go",
			function()
				-- Try to get PR number from current buffer or prompt
				local pr_number = vim.fn.input("PR number (or press Enter for current branch): ")
				if pr_number == "" then
					-- No number provided, use current branch
					vim.cmd("Octo pr edit")
				else
					-- Open specific PR in octo
					vim.cmd("Octo pr edit " .. pr_number)
				end
			end,
			desc = "Open PR in Octo (for inline comments)",
		},
	},
}
