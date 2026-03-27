-- Git Worktree Management
-- Manage git worktrees from Neovim with Snacks picker integration
-- Requires: bare repo setup (use `gclone` shell function)
--
-- Workflow:
-- - <leader>gw  → Open worktree picker (switch, create, delete from picker)
-- - <leader>gwc → Create new worktree
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
			"<leader>gw",
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
			desc = "Create Worktree",
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
