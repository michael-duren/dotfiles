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
	build = function()
		-- Patch deprecated GitHub GraphQL milestone fields
		-- GitHub removed openIssueCount and closedIssueCount from Milestone type
		-- See: https://github.com/pwntester/octo.nvim/issues (this is a known issue)
		local plugin_dir = vim.fn.stdpath("data") .. "/lazy/octo.nvim"
		local fragments_file = plugin_dir .. "/lua/octo/gh/fragments.lua"
		local queries_file = plugin_dir .. "/lua/octo/gh/queries.lua"
		local utils_file = plugin_dir .. "/lua/octo/utils.lua"

		-- Read and patch files in Lua (cross-platform)
		local function patch_file_remove_patterns(filepath, patterns)
			if vim.fn.filereadable(filepath) == 0 then
				return
			end
			local lines = vim.fn.readfile(filepath)
			local new_lines = {}
			for _, line in ipairs(lines) do
				local should_keep = true
				for _, pattern in ipairs(patterns) do
					if line:match(pattern) then
						should_keep = false
						break
					end
				end
				if should_keep then
					table.insert(new_lines, line)
				end
			end
			vim.fn.writefile(new_lines, filepath)
		end

		-- Remove deprecated fields from GraphQL queries
		local deprecated_patterns = { "openIssueCount", "closedIssueCount" }
		patch_file_remove_patterns(fragments_file, deprecated_patterns)
		patch_file_remove_patterns(queries_file, deprecated_patterns)

		-- Patch utils.lua to handle missing milestone counts
		if vim.fn.filereadable(utils_file) == 1 then
			local utils_content = vim.fn.readfile(utils_file)
			for i, line in ipairs(utils_content) do
				if line:match("if not milestone or not milestone%.openIssueCount") then
					utils_content[i] = line:gsub("milestone%.openIssueCount", "milestone.title")
				elseif line:match("local open = milestone%.openIssueCount") then
					utils_content[i] = "  local open = 0 -- Patched: GitHub removed openIssueCount field"
				elseif line:match("local closed = milestone%.closedIssueCount") then
					utils_content[i] = "  local closed = 0 -- Patched: GitHub removed closedIssueCount field"
				end
			end
			vim.fn.writefile(utils_content, utils_file)
		end

		vim.notify("Octo.nvim: Patched deprecated milestone fields", vim.log.levels.INFO)
	end,
	init = function()
		-- Ensure proper conceallevel for octo buffers to hide HTML tags
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "octo",
			callback = function()
				vim.opt_local.conceallevel = 2
				vim.opt_local.concealcursor = "nc"
			end,
		})
	end,
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

		-- UI settings for proper markdown rendering
		ui = {
			use_signcolumn = true, -- Show "modified" marks on sign column
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
		-- Checkout PR into a worktree (instead of git checkout)
		{
			"<leader>op",
			function()
				local pr_input = vim.fn.input("PR number (or press Enter for current branch PR): ")

				-- Build gh command to get branch name
				local gh_cmd
				if pr_input == "" then
					-- Get PR for current branch
					gh_cmd = "gh pr view --json headRefName --jq .headRefName"
				else
					gh_cmd = string.format("gh pr view %s --json headRefName --jq .headRefName", pr_input)
				end

				local branch = vim.fn.system(gh_cmd):gsub("%s+$", "")

				if vim.v.shell_error ~= 0 or branch == "" then
					vim.notify("Failed to get PR branch name", vim.log.levels.ERROR)
					return
				end

				-- Check if worktree already exists for this branch
				local worktrees, err = require("git-worktree").list()
				if err then
					vim.notify("Failed to list worktrees: " .. err, vim.log.levels.ERROR)
					return
				end

				for _, wt in ipairs(worktrees) do
					if wt.branch == branch then
						-- Worktree exists, just switch to it
						vim.notify("Switching to existing worktree for " .. branch)
						require("git-worktree").switch(wt.path)
						return
					end
				end

				-- Create new worktree for the PR branch
				vim.notify("Creating worktree for PR branch: " .. branch)
				require("git-worktree").create({
					branch = branch,
					switch = true,
				}, function(wt, create_err)
					if create_err then
						vim.notify("Failed to create worktree: " .. create_err, vim.log.levels.ERROR)
					else
						vim.notify("Switched to PR worktree: " .. wt.path)
					end
				end)
			end,
			desc = "Checkout PR (worktree)",
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
