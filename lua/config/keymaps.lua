-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Open current buffer in Edge
vim.keymap.set("n", "<leader>ob", function()
	vim.fn.system('start msedge "' .. vim.fn.expand("%:p") .. '"')
end, {
	desc = "Open current buffer in Edge",
})
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", {
	desc = "Quit all",
})
local keybindings = { -- general
	{
		key = "<C-s>",
		command = ":w<CR>",
		description = "Save current buffer",
	},
	{ key = "<leader>qq", command = "<cmd>qa<cr>", description = "Quit all" },
	{ key = "<A-j>", command = ":m .+1<CR>==", description = "Move line down" },
	{ key = "<leader>wd", command = "<C-W>c", description = "Delete Window" },
	{ key = "<leader>bn", command = ":enew<CR>", description = "New Buffer" },
	{ key = "<leader>bd", command = ":bd<CR>", description = "Delete Buffer" },
	{ key = "<leader>bq", command = ":bd!<CR>", description = "Force Delete Buffer" },
	{ key = "<leader>b.", command = ":bnext<CR>", description = "Next Buffer" },
	{ key = "<S-h", command = ":bprevious<CR>", description = "Previous Buffer" },
	{ key = "<S-l>", command = ":bprevious<CR>", description = "Next Buffer" },
	{ key = "<leader>bh", command = ":bfirst<CR>", description = "First Buffer" },
	{ key = "<leader>bb", command = "<cmd>e #<cr>", description = "Switch to Other Buffer" }, -- -- windows
	-- convert these to correct table format
	-- map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
	-- map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
	-- map("n", "<leader>wd", "<C-W>c", { desc = "", remap = true })
	-- Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
	-- Snacks.toggle.zen():map("<leader>uz")
	{
		key = "<leader>wd",
		command = "<C-W>c",
		description = "Delete Window",
	},
	{ key = "<A-k>", command = ":m .-2<CR>==", description = "Move line up" }, -- Center after scrolling
	{ key = "<C-d>", command = "<C-d>zz" },
	{ key = "<C-u>", command = "<C-u>zz" },
	{ key = "<leader>nd", command = "<cmd>Noice dismiss<CR>", description = "Noice dismiss" }, -- windows
	{ key = "<C-h>", command = "<C-w>h", description = "Go to left window" },
	{ key = "<C-l>", command = "<C-w>l", description = "Go to right window" },
	{ key = "<C-j>", command = "<C-w>j", description = "Go to bottom window" },
	{ key = "<C-k>", command = "<C-w>k", description = "Go to top window" },
	{ key = "<leader>H", command = ":noh<CR>", description = "Hide search highlight" }, -- -- Splits
	{ key = "|", command = ":vsplit<CR>", description = "Vertical split" },
	{ key = "-", command = ":split<CR>", description = "Horizontal split" },
	{ key = "<M-w>", command = ":close<CR>", description = "Close current split" }, -- Misc
	{
		key = "<leader><CR>",
		command = ":so ~/.config/nvim/init.lua<CR>",
		options = {
			noremap = true,
			silent = false,
			desc = "Reload init.lua",
		},
	},
	{
		key = "<leader>w",
		command = ":w<CR>",
		options = {
			noremap = true,
			silent = true,
			desc = "Write current buffer",
		},
	},
	{
		key = "<leader>?",
		command = ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>",
		description = "Open settings",
	}, -- LSP
	-- basic
	{ key = "gd", command = "<cmd>lua vim.lsp.buf.definition()<CR>", description = "LSP go to definition" },
	{ key = "gD", command = "<cmd>lua vim.lsp.buf.declaration()<CR>", description = "LSP go to declaration" },
	{ key = "gr", command = "<cmd>lua vim.lsp.buf.references()<CR>", description = "LSP find references" },
	{
		key = "gi",
		command = "<cmd>lua vim.lsp.buf.implementation()<CR>",
		description = "LSP go to implementation",
	},
	{ key = "K", command = "<cmd>lua vim.lsp.buf.hover()<CR>", description = "LSP hover" },
	{ key = "<leader>lf", command = "<cmd>lua vim.lsp.buf.format()<CR>", description = "LSP format" }, -- LSP Menu
	{ key = "<leader>kj", command = vim.diagnostic.goto_next, description = "go to next error" },
	{ key = "<leader>kk", command = vim.diagnostic.goto_prev, description = "go to previous error" },
	{ key = "<leader>lr", command = "<cmd>lua vim.lsp.buf.rename()<CR>", description = "Rename" },
	{ key = "<leader>R", command = "<cmd>LspRestart<CR>", description = "Restart LSP" },
	{ key = "<leader>la", command = "<cmd>lua vim.lsp.buf.code_action()<CR>", description = "Code action" },
	{
		key = "<leader>ld",
		command = "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>",
		description = "Buffer Diagnostics",
	},
	{
		key = "<leader>lD",
		command = "<cmd>Telescope lsp_document_diagnostics bufnr=0 theme=get_ivy<cr>",
		description = "Document Diagnostics",
	},
	{ key = "<leader>ll", command = "<cmd>lua vim.lsp.codelens.run()<cr>", description = "CodeLens Action" },
	{ key = "<leader>li", command = "<cmd>LspInfo<cr>", description = "Info" },
	{ key = "<leader>lI", command = "<cmd>Mason<cr>", description = "Mason Info" },
	{ key = "<leader>lq", command = "<cmd>lua vim.diagnostic.setloclist()<cr>", description = "Quickfix" },
	{
		key = "<leader>ls",
		command = "<cmd>Telescope lsp_document_symbols<cr>",
		description = "Document Symbols",
	},
	{
		key = "<leader>lS",
		command = "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
		description = "Workspace Symbols",
	},
	{ key = "<leader>le", command = "<cmd>Telescope quickfix<cr>", description = "Telescope Quickfix" }, -- luasnip
	{
		mode = "i",
		key = "<C-j>",
		command = "<cmd>lua require('luasnip').jump(1)<CR>",
		description = "Jump forward",
	},
	{
		mode = "i",
		key = "<C-k>",
		command = "<cmd>lua require('luasnip').jump(-1)<CR>",
		description = "Jump backward",
	},
	{
		mode = "s",
		key = "<C-j>",
		command = "<cmd>lua require('luasnip').jump(1)<CR>",
		description = "Jump forward",
	},
	{
		mode = "s",
		key = "<C-k>",
		command = "<cmd>lua require('luasnip').jump(-1)<CR>",
		description = "Jump backward",
	}, -- markdown preview
	{ key = "<leader>mp", command = "<cmd>MarkdownPreviewToggle<CR>", description = "Markdown preview" }, -- toggle term
	{
		mode = "t",
		key = "<Esc>",
		command = "<C-\\><C-n>",
		description = "Exit terminal mode",
	}, -- stop running process in toggle term
	{
		mode = "t",
		key = "<C-c",
		command = "<C-\\><C-n>:stop<CR>",
		description = "Stop running process",
	}, -- copilot
	{ key = "<leader>gB", command = "<cmd>Gitsigns blame_line<CR>", description = "Blame line" },
	{ key = "<leader>U", command = "<cmd>Lazy update<CR>", description = "Lazy update" },
	{ key = "<leader>W", command = "<cmd>set wrap!<CR>", description = "Toggle wrap" },
}
for _, bind in ipairs(keybindings) do
	if bind.mode == nil then
		bind.mode = "n"
	end
	vim.keymap.set(bind.mode, bind.key, bind.command, bind.options or {
		desc = bind.description,
		noremap = true,
		silent = true,
	})
end
