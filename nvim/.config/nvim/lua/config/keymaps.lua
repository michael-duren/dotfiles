local utils = require("helpers.utils")
local diagnostics = require("helpers.diagnostics")

---@type KeyMap[]
local keybindings = {
	-- File Operations
	{
		key = "<C-s>",
		command = ":w<CR>",
		opts = { desc = "Save current buffer" },
	},
	{
		key = "<leader>w",
		command = ":w<CR>",
		opts = {
			desc = "Write current buffer",
		},
	},

	-- Quit Operations
	{
		key = "<leader>qq",
		command = "<cmd>qa<cr>",
		opts = { desc = "Quit all" },
	},
	{
		key = "<leader>Q",
		command = "<cmd>qa!<cr>",
		opts = { desc = "Force Quit" },
	},
	{
		key = "<leader>qw",
		command = "<cmd>wqa<cr>",
		opts = { desc = "Save all and quit" },
	},
	-- Saving
	{
		key = "<leader>wa",
		command = "<cmd>wa<cr>",
		opts = { desc = "Save all" },
	},
	-- LSP - Basic Navigation
	{
		key = "K",
		command = "<cmd>lua vim.lsp.buf.hover()<CR>",
		opts = { desc = "LSP hover" },
	},

	-- LSP - Leader Menu
	{
		key = "<leader>lf",
		command = "<cmd>lua vim.lsp.buf.format()<CR>",
		opts = { desc = "LSP format" },
	},
	{
		key = "<leader>lr",
		command = "<cmd>lua vim.lsp.buf.rename()<CR>",
		opts = { desc = "Rename" },
	},
	{
		key = "<leader>la",
		command = "<cmd>lua vim.lsp.buf.code_action()<CR>",
		opts = { desc = "Code action" },
	},
	{
		key = "<leader>ll",
		command = "<cmd>lua vim.lsp.codelens.run()<cr>",
		opts = { desc = "CodeLens Action" },
	},
	{
		key = "<leader>li",
		command = "<cmd>LspInfo<cr>",
		opts = { desc = "Info" },
	},
	{
		key = "<leader>lI",
		command = "<cmd>Mason<cr>",
		opts = { desc = "Mason Info" },
	},
	{
		key = "<leader>lq",
		command = "<cmd>lua vim.diagnostic.setloclist()<cr>",
		opts = { desc = "Quickfix" },
	},
	{
		key = "<leader>ls",
		command = "<cmd>Telescope lsp_document_symbols<cr>",
		opts = { desc = "Document Symbols" },
	},
	{
		key = "<leader>lS",
		command = "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
		opts = { desc = "Workspace Symbols" },
	},
	{
		key = "<leader>le",
		command = "<cmd>Telescope quickfix<cr>",
		opts = { desc = "Telescope Quickfix" },
	},
	{
		key = "<leader>R",
		command = "<cmd>LspRestart<CR>",
		opts = { desc = "Restart LSP" },
	},
	{
		key = "<leader>ld",
		command = function()
			vim.cmd("LspStop")
			vim.notify("LSP disabled", vim.log.levels.INFO)
		end,
		opts = { desc = "Disable LSP" },
	},

	-- Diagnostics
	{
		key = "<leader>kc",
		command = diagnostics.line_diagnostics,
		opts = {
			desc = "go to next error",
		},
	},
	{
		key = "<leader>kj",
		command = diagnostics.goto_next,
		opts = {
			desc = "go to next error",
		},
	},
	{
		key = "<leader>kk",
		command = diagnostics.goto_prev,
		opts = {
			desc = "go to previous error",
		},
	},
	{
		key = "]d",
		command = diagnostics.goto_next,
		opts = {
			desc = "Next Diagnostic",
		},
	},
	{
		key = "[d",
		command = diagnostics.goto_prev,
		opts = {
			desc = "Prev Diagnostic",
		},
	},
	{
		key = "<leader>ca",
		command = "<cmd>lua vim.lsp.buf.code_action()<CR>",
		opts = { desc = "Code action" },
	},

	-- Line Movement
	{
		key = "<A-j>",
		command = ":m .+1<CR>==",
		opts = { desc = "Move line down" },
	},
	{
		key = "<A-k>",
		command = ":m .-2<CR>==",
		opts = { desc = "Move line up" },
	},

	-- Scrolling & Centering
	{
		key = "<C-d>",
		command = "<C-d>zz",
		opts = { desc = "Scroll down and center" },
	},
	{
		key = "<C-u>",
		command = "<C-u>zz",
		opts = { desc = "Scroll up and center" },
	},

	-- Buffer Management
	{
		key = "<leader>bn",
		command = ":enew<CR>",
		opts = { desc = "New Buffer" },
	},
	{
		key = "<leader>bd",
		command = ":bd<CR>",
		opts = { desc = "Delete Buffer" },
	},
	{
		key = "<leader>bq",
		command = ":bd!<CR>",
		opts = { desc = "Force Delete Buffer" },
	},
	{
		key = "<leader>b.",
		command = ":bnext<CR>",
		opts = { desc = "Next Buffer" },
	},
	{
		key = "<S-h>",
		command = ":bprevious<CR>",
		opts = { desc = "Previous Buffer" },
	},
	{
		key = "<S-l>",
		command = ":bnext<CR>",
		opts = { desc = "Next Buffer" },
	},
	{
		key = "<leader>bh",
		command = ":bfirst<CR>",
		opts = { desc = "First Buffer" },
	},
	{
		key = "<leader>bb",
		command = "<cmd>e #<cr>",
		opts = { desc = "Switch to Other Buffer" },
	},

	-- Window Navigation
	{
		key = "<C-h>",
		command = "<C-w>h",
		opts = { desc = "Go to left window" },
	},
	{
		key = "<C-l>",
		command = "<C-w>l",
		opts = { desc = "Go to right window" },
	},
	{
		key = "<C-j>",
		command = "<C-w>j",
		opts = { desc = "Go to bottom window" },
	},
	{
		key = "<C-k>",
		command = "<C-w>k",
		opts = { desc = "Go to top window" },
	},

	-- Window Management
	{
		key = "<leader>wd",
		command = "<C-W>c",
		opts = { desc = "Delete Window" },
	},
	{
		key = "|",
		command = ":vsplit<CR>",
		opts = { desc = "Vertical split" },
	},
	{
		key = "-",
		command = ":split<CR>",
		opts = { desc = "Horizontal split" },
	},
	{
		key = "<M-w>",
		command = ":close<CR>",
		opts = { desc = "Close current split" },
	},

	-- Search & Highlight
	{
		key = "<leader>H",
		command = ":noh<CR>",
		opts = { desc = "Hide search highlight" },
	},
	{
		key = "<Esc><Esc>",
		command = ":noh<CR>",
		opts = { desc = "Hide search highlight" },
	},

	-- LuaSnip Navigation (Insert Mode)
	{
		mode = "i",
		key = "<C-j>",
		command = "<cmd>lua require('luasnip').jump(1)<CR>",
		opts = { desc = "Jump forward" },
	},
	{
		mode = "i",
		key = "<C-k>",
		command = "<cmd>lua require('luasnip').jump(-1)<CR>",
		opts = { desc = "Jump backward" },
	},

	-- LuaSnip Navigation (Select Mode)
	{
		mode = "s",
		key = "<C-j>",
		command = "<cmd>lua require('luasnip').jump(1)<CR>",
		opts = { desc = "Jump forward" },
	},
	{
		mode = "s",
		key = "<C-k>",
		command = "<cmd>lua require('luasnip').jump(-1)<CR>",
		opts = { desc = "Jump backward" },
	},

	-- Terminal Mode
	{
		mode = "t",
		key = "<Esc>",
		command = "<C-\\><C-n>",
		opts = { desc = "Exit terminal mode" },
	},


	-- Git
	{
		key = "<leader>gB",
		command = "<cmd>Gitsigns blame_line<CR>",
		opts = { desc = "Blame line" },
	},

	-- Plugins & Tools
	{
		key = "<leader>mp",
		command = "<cmd>MarkdownPreviewToggle<CR>",
		opts = { desc = "Markdown preview" },
	},
	{
		key = "<leader>U",
		command = "<cmd>Lazy update<CR>",
		opts = { desc = "Lazy update" },
	},
	{
		key = "<leader>W",
		command = "<cmd>set wrap!<CR>",
		opts = { desc = "Toggle wrap" },
	},
	{
		key = "<leader>nd",
		command = "<cmd>Noice dismiss<CR>",
		opts = { desc = "Noice dismiss" },
	},

	-- Config & Settings
	{
		key = "<leader><CR>",
		command = ":so ~/.config/nvim/init.lua<CR>",
		opts = {
			silent = false,
			desc = "Reload init.lua",
		},
	},
	{
		key = "<leader>?",
		command = ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>",
		opts = { desc = "Open settings" },
	},
	-- Misc.
	{
		key = "<leader>ob",
		command = function()
			if utils.is_windows() then
				vim.fn.system('start msedge "' .. vim.fn.expand("%:p") .. '"')
				return
			end
			vim.fn.system('open -a "Google Chrome" "' .. vim.fn.expand("%:p") .. '"')
		end,
		opts = { desc = "Open current buffer in Browser" },
	},
	-- Check perf
	{
		key = "<leader>lp",
		command = "<cmd>Lazy profile<cr>",
		opts = { desc = "Lazy Profile" },
	},
}

utils.map_keys(keybindings)
