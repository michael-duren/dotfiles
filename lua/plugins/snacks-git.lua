---@class snacks.lazygit.Config: snacks.terminal.Opts
---@field args? string[]
---@field theme? snacks.lazygit.Theme
local config = {
  -- automatically configure lazygit to use the current colorscheme
  -- and integrate edit with the current neovim instance
  configure = true,
  -- extra configuration for lazygit that will be merged with the default
  -- snacks does NOT have a full yaml parser, so if you need `"test"` to appear with the quotes
  -- you need to double quote it: `"\"test\""`
  config = {
    os = { editPreset = "nvim-remote" },
    gui = {
      -- set to an empty string "" to disable icons
      nerdFontsVersion = "3",
    },
  },
  win = {
    style = "lazygit",
  },
}

return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        lazygit = {
            config = config,
        }
    },
    keys = {
      {
        "<leader>gG",
        function()
          Snacks.terminal({ "gitui" })
        end,
        desc = "GitUi (cwd)",
      },
      {
        "<leader>gg",
        function(opts)
            Snacks.lazygit.open(opts)
        end,
        desc = "GitUi (Root Dir)",
      },
  }
}
