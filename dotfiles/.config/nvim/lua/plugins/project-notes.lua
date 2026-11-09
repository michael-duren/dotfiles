return {
	-- Vendored into this config (local-plugins/) instead of fetched from GitHub
	dir = vim.fn.stdpath("config") .. "/local-plugins/project-notes.nvim",
	name = "project-notes.nvim",
	cmd = { "Notebook", "ProjectNotes", "ProjectNotesNew", "ProjectNotesFind", "ProjectNotesMigrate" },
	opts = {
		dir = "~/notes",
		window = { border = "single" },
	},
	keys = {
		{ "<leader>pn", "<cmd>ProjectNotes<cr>", desc = "Project Notes" },
		{ "<leader>pa", "<cmd>ProjectNotesNew<cr>", desc = "New project note" },
		{ "<leader>pf", "<cmd>ProjectNotesFind<cr>", desc = "Find project note" },
		{ "<leader>Nf", "<cmd>Notebook find<cr>", desc = "Notebook find" },
		{ "<leader>Ns", "<cmd>Notebook search<cr>", desc = "Notebook fuzzy search contents" },
		{ "<leader>Ng", "<cmd>Notebook grep<cr>", desc = "Notebook grep" },
		{ "<leader>Nn", "<cmd>Notebook new<cr>", desc = "Notebook new note" },
		{ "<leader>Nd", "<cmd>Notebook daily<cr>", desc = "Notebook daily note" },
		{ "<leader>Nt", "<cmd>Notebook tags<cr>", desc = "Notebook tags" },
		{ "<leader>Ne", "<cmd>Notebook tree<cr>", desc = "Notebook explorer" },
	},
}
