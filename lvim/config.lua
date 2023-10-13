-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

--options
lvim.keys.normal_mode["<C-s>"] = ":w<CR>"
lvim.keys.normal_mode["<C-n>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<C-p>"] = ":BufferLineCyclePrev<CR>"
vim.opt.relativenumber = true
vim.g.copilot_assume_mapped = true
lvim.builtin.nvimtree.setup.view.side = "right"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.nvimtree.setup.view.width = 35
vim.keymap.set("n", "Tt", ":TransparentToggle<CR>")

-- keymappings
-- vim.keymap.set("n", "hx", require("harpoon.mark").add_file)
-- vim.keymap.set("n", "hp", require("harpoon.ui").nav_next)
-- vim.keymap.set("n", "hn", require("harpoon.ui").nav_prev)
-- vim.keymap.set("n", "hm", ":Telescope harpoon marks<CR>")
lvim.keys.normal_mode["|"] = ":vsplit<CR>"
lvim.keys.normal_mode["-"] = ":split<CR>"
lvim.keys.normal_mode["<M-w>"] = ":close<CR>"


-- stop vim from autocommenting next line
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
  end,
})

-- linters/formatters
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
  return
end

lspconfig["sqlls"].setup({
  filetypes = { "sql" },
})

lspconfig["emmet_ls"].setup({
  filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

lspconfig["tailwindcss"].setup({
  filetypes = { "html", "typescriptreact", "javascriptreact", "svelte" },
})

--formatting and linting
lvim.log.level = "info"
lvim.format_on_save = {
  enabled = true,
  timeout = 5000,
}

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  { command = "stylua" },
  {
    command = "prettier",
    extra_args = { "--print-width", "100" },
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", ".md", ".css", ".html" },
  },
  {
    command = "csharpier",
    filetypes = { "cs", ".cshtml", ".razor" },
  },
  {
    command = "sql-formatter",
    filetypes = { "sql" },
  },
})
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
  { command = "flake8", filetypes = { "python" } },
  {
    command = "shellcheck",
    args = { "--severity", "warning" },
  },
  {
    only_local = { ".eslintrc.json", ".eslintrc.js", "eslintrc.mjs" },
    command = "eslint_d",
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  },
})


-- plugins
lvim.plugins = {
  { "nvim-lua/plenary.nvim" },
  { "ThePrimeagen/harpoon" },
  { "github/copilot.vim" },
  { "lunarvim/colorschemes" },
  { "folke/tokyonight.nvim" },

  { "rose-pine/neovim" },
  --	auto tags
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  -- tailwind-colors
  {
    "themaxmarchuk/tailwindcss-colors.nvim",
    -- load only on require("tailwindcss-colors")
    -- run the setup function after plugin is loaded
    config = function()
      -- pass config options here (or nothing to use defaults)
      require("tailwindcss-colors").setup()
    end,
  },

  { "norcalli/nvim-colorizer.lua" }, -- colorize hex colors

  { "xiyaowong/nvim-transparent" },  -- toggle transparency

  {
    "jose-elias-alvarez/typescript.nvim",
    config = function()
      require("typescript").setup({
        -- keybinds for navigation in lspsaga window
        scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
        -- use enter to open file with definition preview
        definition = {
          edit = "<CR>",
        },
        ui = {
          colors = {
            normal_bg = "#022746",
          },
        },
      })
    end,
  },
}

-- configs

-- harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

-- vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
-- vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
-- vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
-- vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)

-- require("harpoon").setup({
--   global_settings = {
--     save_on_toggle = false,
--     save_on_change = true,
--     enter_on_sendcmd = false,
--     tmux_autoclose_windows = false,
--     excluded_filetypes = {},
--     mark_branches = true
--   },
--   projects = {
--     ["~/code/"] = {
--       term = {
--         cmds = {
--           "yarn dev",
--         },
--       },
--     },
--   },
-- })

-- use telescope with harpoon
require('telescope').load_extension('harpoon')

require("rose-pine").setup({
  --- @usage 'auto'|'main'|'moon'|'dawn'
  variant = "moon",
  --- @usage 'main'|'moon'|'dawn'
  dark_variant = "main",
  bold_vert_split = false,
  dim_nc_background = false,
  disable_background = false,
  disable_float_background = false,
  disable_italics = false,
  --- @usage string hex value or named color from rosepinetheme.com/palette
  groups = {
    background = "base",
    panel = "base",
    border = "muted",
    comment = "muted",
    link = "iris",
    punctuation = "subtle",
    error = "love",
    hint = "iris",
    info = "foam",
    warn = "gold",

    headings = {
      h1 = "iris",
      h2 = "foam",
      h3 = "rose",
      h4 = "gold",
      h5 = "pine",
      h6 = "foam",
    },
    -- or set all headings at once
    -- headings = 'subtle'
  },
  -- Change specific vim highlight groups
  -- https://github.com/rose-pine/neovim/wiki/Recipes
  highlight_groups = {
    ColorColumn = { bg = "rose" },

    -- Blend colours against the "base" background
    CursorLine = { bg = "foam", blend = 10 },
    StatusLine = { fg = "love", bg = "love", blend = 10 },
  },
})

-- -- set colorscheme after options
-- vim.cmd('colorscheme rose-pine')

--color scheme
lvim.colorscheme = "tokyonight-night"
