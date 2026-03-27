-- Git Worktree Management
-- Manage git worktrees from Neovim with Snacks picker integration
-- Requires: bare repo setup (use `gclone` shell function)
--
-- Workflow:
-- - <leader>gw  → Open worktree picker (switch, create, delete from picker)
-- - <leader>gwc → Create new worktree (new branch)
-- - <leader>gwa → Add worktree from existing remote branch
-- - <leader>gws → Switch worktree (select menu)
-- - <leader>gwd → Delete worktree (select menu with confirmation)

return {
	"imax153/git-worktree.nvim",
	opts = {},
	dependencies = {
		{ "folke/snacks.nvim", optional = true },
	},
	keys = {
		{
			"<leader>gwl",
			function()
				require("git-worktree.snacks").worktrees()
			end,
			desc = "Git Worktrees (picker)",
		},
		{
			"<leader>gwc",
			function()
				require("git-worktree.snacks").create_worktree()
			end,
			desc = "Create Worktree (new branch)",
		},
		{
			"<leader>gwa",
			function()
				-- Fetch latest remote branches
				vim.notify("Fetching remote branches...")
				vim.fn.system("git fetch --all --prune")
				if vim.v.shell_error ~= 0 then
					vim.notify("Failed to fetch remote branches", vim.log.levels.ERROR)
					return
				end

				-- Get remote branches, stripping "origin/" prefix
				local output = vim.fn.systemlist("git branch -r --format='%(refname:short)'")
				if vim.v.shell_error ~= 0 or #output == 0 then
					vim.notify("No remote branches found", vim.log.levels.WARN)
					return
				end

				-- Get existing worktree branches to filter them out
				local worktrees, err = require("git-worktree").list()
				local existing = {}
				if not err and worktrees then
					for _, wt in ipairs(worktrees) do
						if wt.branch then
							existing[wt.branch] = true
						end
					end
				end

				-- Build list of branches not already checked out as worktrees
				local branches = {}
				for _, ref in ipairs(output) do
					-- Strip origin/ prefix and skip HEAD pointer
					local branch = ref:gsub("^origin/", "")
					if branch ~= "HEAD" and not existing[branch] then
						table.insert(branches, branch)
					end
				end

				if #branches == 0 then
					vim.notify("All remote branches already have worktrees", vim.log.levels.INFO)
					return
				end

				vim.ui.select(branches, {
					prompt = "Select branch to add as worktree:",
				}, function(branch)
					if not branch then
						return
					end

					vim.notify("Creating worktree for: " .. branch)
					require("git-worktree").create({
						branch = branch,
						create_branch = false,
						switch = true,
					}, function(wt, create_err)
						if create_err then
							vim.notify("Failed to create worktree: " .. create_err, vim.log.levels.ERROR)
						else
							vim.notify("Switched to worktree: " .. wt.path)
						end
					end)
				end)
			end,
			desc = "Add Worktree (existing branch)",
		},
		{
			"<leader>gws",
			function()
				require("git-worktree.snacks").switch_worktree()
			end,
			desc = "Switch Worktree",
		},
		{
			"<leader>gwd",
			function()
				require("git-worktree.snacks").delete_worktree()
			end,
			desc = "Delete Worktree",
		},
	},
}
