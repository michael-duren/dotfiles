-- Octo.nvim - GitHub PR Review with Inline Comments
-- This plugin complements snacks.nvim GitHub integration by adding:
-- - Inline commenting on PR diffs (the missing feature from snacks!)
-- - Full PR review workflow with suggestions
-- - Thread management and resolution
-- - Local checkout and LSP integration
--
-- Usage:
-- 1. Browse PRs with snacks: <leader>gp
-- 2. When you need to review with inline comments: <leader>or or :Octo pr edit <number>
-- 3. Start review mode: <leader>ors
-- 4. Add inline comments: <localleader>ca (normal or visual mode)
-- 5. Add suggestions: <localleader>sa (visual mode)
-- 6. Submit review: <leader>orr

return {
	"pwntester/octo.nvim",
	cmd = "Octo",
	opts = {
		-- Use snacks picker to match your existing workflow!
		picker = "snacks",
		enable_builtin = true, -- Show command list when just typing :Octo

		-- Suppress some keybindings that conflict with your snacks setup
		mappings_disable_default = false,

		-- Reviews configuration - optimized for inline commenting
		reviews = {
			auto_show_threads = true, -- Automatically show comment threads on cursor move
			focus = "right", -- Focus right buffer when opening diff
		},

		-- Pull request settings
		pull_requests = {
			order_by = {
				field = "UPDATED_AT",
				direction = "DESC",
			},
			always_select_remote_on_create = false,
		},

		-- Issue settings
		issues = {
			order_by = {
				field = "UPDATED_AT",
				direction = "DESC",
			},
		},

		-- File panel for reviewing changed files
		file_panel = {
			size = 10, -- Height of changed files panel
			use_icons = true, -- Use devicons
		},

		-- Custom key mappings for review workflow
		mappings = {
			pull_request = {
				-- Essential PR review mappings
				checkout_pr = { lhs = "<localleader>po", desc = "checkout PR" },
				merge_pr = { lhs = "<localleader>pm", desc = "merge PR" },
				list_commits = { lhs = "<localleader>pc", desc = "list PR commits" },
				list_changed_files = { lhs = "<localleader>pf", desc = "list PR changed files" },
				show_pr_diff = { lhs = "<localleader>pd", desc = "show PR diff" },
				add_reviewer = { lhs = "<localleader>va", desc = "add reviewer" },
				remove_reviewer = { lhs = "<localleader>vd", desc = "remove reviewer" },
				close_issue = { lhs = "<localleader>ic", desc = "close PR" },
				reopen_issue = { lhs = "<localleader>io", desc = "reopen PR" },
				reload = { lhs = "<C-r>", desc = "reload PR" },
				open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
				copy_url = { lhs = "<C-y>", desc = "copy url to clipboard" },
				goto_file = { lhs = "gf", desc = "go to file" },
				add_assignee = { lhs = "<localleader>aa", desc = "add assignee" },
				add_label = { lhs = "<localleader>la", desc = "add label" },
				add_comment = { lhs = "<localleader>ca", desc = "add comment" },
				delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
				next_comment = { lhs = "]c", desc = "next comment" },
				prev_comment = { lhs = "[c", desc = "previous comment" },

				-- Review workflow
				review_start = { lhs = "<localleader>vs", desc = "start review" },
				review_resume = { lhs = "<localleader>vr", desc = "resume review" },
				resolve_thread = { lhs = "<localleader>rt", desc = "resolve thread" },
				unresolve_thread = { lhs = "<localleader>rT", desc = "unresolve thread" },

				-- Reactions
				react_hooray = { lhs = "<localleader>rp", desc = "add/remove 🎉 reaction" },
				react_heart = { lhs = "<localleader>rh", desc = "add/remove ❤️ reaction" },
				react_eyes = { lhs = "<localleader>re", desc = "add/remove 👀 reaction" },
				react_thumbs_up = { lhs = "<localleader>r+", desc = "add/remove 👍 reaction" },
				react_thumbs_down = { lhs = "<localleader>r-", desc = "add/remove 👎 reaction" },
				react_rocket = { lhs = "<localleader>rr", desc = "add/remove 🚀 reaction" },
				react_laugh = { lhs = "<localleader>rl", desc = "add/remove 😄 reaction" },
			},
			review_thread = {
				goto_issue = { lhs = "<localleader>gi", desc = "navigate to issue" },
				add_comment = { lhs = "<localleader>ca", desc = "add comment" },
				add_suggestion = { lhs = "<localleader>sa", desc = "add suggestion" },
				delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
				next_comment = { lhs = "]c", desc = "next comment" },
				prev_comment = { lhs = "[c", desc = "previous comment" },
				select_next_entry = { lhs = "]q", desc = "next changed file" },
				select_prev_entry = { lhs = "[q", desc = "previous changed file" },
				close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
				resolve_thread = { lhs = "<localleader>rt", desc = "resolve thread" },
				unresolve_thread = { lhs = "<localleader>rT", desc = "unresolve thread" },
			},
			submit_win = {
				approve_review = { lhs = "<C-a>", desc = "approve review" },
				comment_review = { lhs = "<C-m>", desc = "comment review" },
				request_changes = { lhs = "<C-r>", desc = "request changes" },
				close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
			},
			review_diff = {
				-- THE KEY FEATURE: Add inline comments on diffs!
				add_review_comment = { lhs = "<localleader>ca", desc = "add review comment", mode = { "n", "x" } },
				add_review_suggestion = { lhs = "<localleader>sa", desc = "add review suggestion", mode = { "n", "x" } },
				submit_review = { lhs = "<localleader>vs", desc = "submit review" },
				discard_review = { lhs = "<localleader>vd", desc = "discard review" },
				focus_files = { lhs = "<localleader>e", desc = "focus changed files panel" },
				toggle_files = { lhs = "<localleader>b", desc = "toggle changed files panel" },
				next_thread = { lhs = "]t", desc = "next thread" },
				prev_thread = { lhs = "[t", desc = "previous thread" },
				select_next_entry = { lhs = "]q", desc = "next changed file" },
				select_prev_entry = { lhs = "[q", desc = "previous changed file" },
				close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
				toggle_viewed = { lhs = "<localleader><space>", desc = "toggle viewed state" },
				goto_file = { lhs = "gf", desc = "go to file" },
			},
			file_panel = {
				submit_review = { lhs = "<localleader>vs", desc = "submit review" },
				discard_review = { lhs = "<localleader>vd", desc = "discard review" },
				next_entry = { lhs = "j", desc = "next changed file" },
				prev_entry = { lhs = "k", desc = "previous changed file" },
				select_entry = { lhs = "<cr>", desc = "show changed file diffs" },
				refresh_files = { lhs = "R", desc = "refresh changed files" },
				toggle_files = { lhs = "<localleader>b", desc = "toggle changed files panel" },
				close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
				toggle_viewed = { lhs = "<localleader><space>", desc = "toggle viewed state" },
			},
		},
	},
	keys = {
		-- Quick access to PR review (complements snacks browsing)
		{
			"<leader>or",
			"<cmd>Octo<cr>",
			desc = "Octo Commands",
		},
		{
			"<leader>ors",
			"<cmd>Octo review start<cr>",
			desc = "Start PR Review",
		},
		{
			"<leader>orr",
			"<cmd>Octo review resume<cr>",
			desc = "Resume PR Review",
		},
		{
			"<leader>orc",
			"<cmd>Octo review comments<cr>",
			desc = "View Review Comments",
		},
		{
			"<leader>ord",
			"<cmd>Octo review discard<cr>",
			desc = "Discard Review",
		},
		{
			"<leader>orv",
			"<cmd>Octo review submit<cr>",
			desc = "Submit Review",
		},
		{
			"<leader>orl",
			"<cmd>Octo pr list<cr>",
			desc = "List PRs (Octo)",
		},
		{
			"<leader>oe",
			function()
				local pr_number = vim.fn.input("PR number: ")
				if pr_number ~= "" then
					vim.cmd("Octo pr edit " .. pr_number)
				end
			end,
			desc = "Edit PR by number",
		},
		-- Quick actions for current PR
		{
			"<leader>op",
			"<cmd>Octo pr checkout<cr>",
			desc = "Checkout PR",
		},
		{
			"<leader>om",
			"<cmd>Octo pr merge<cr>",
			desc = "Merge PR",
		},
		{
			"<leader>oc",
			"<cmd>Octo pr changes<cr>",
			desc = "Show PR changes",
		},
		{
			"<leader>od",
			"<cmd>Octo pr diff<cr>",
			desc = "Show PR diff",
		},
		{
			"<leader>ob",
			"<cmd>Octo pr browser<cr>",
			desc = "Open PR in browser",
		},
		{
			"<leader>oy",
			"<cmd>Octo pr url<cr>",
			desc = "Copy PR URL",
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim", -- Use snacks as picker!
		"nvim-tree/nvim-web-devicons",
	},
}
