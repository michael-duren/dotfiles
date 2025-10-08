return {
    "zaldih/themery.nvim",
    lazy = false,
    keys = {{
        "<leader>ct",
        ":Themery<CR>",
        desc = "Choose Theme"
    }},
    config = function()
        require("themery").setup({
            themes = {"blue", "catppuccin", "catppuccin-frappe", "catppuccin-latte", "catppuccin-macchiato",
                      "catppuccin-mocha", "darkblue", "decay", "decay-dark", "decay-default", "decayce", "default",
                      "delek", "desert", "edge", "elflord", "evening", "everforest", "gruvbox", "habamax", "industry",
                      "kanagawa", "kanagawa-dragon", "kanagawa-lotus", "kanagawa-paper", "kanagawa-paper-canvas",
                      "kanagawa-paper-ink", "kanagawa-wave", "koehler", "lunaperche", "morning", "murphy", "neobones",
                      "neon", "onedark", "onedark_dark", "onedark_vivid", "pablo", "peachpuff", "quiet", "retrobox",
                      "ron", "shine", "slate", "sorbet", "torte", "wildcharm", "zaibatsu", "zenbones", "zellner"},
            livePreview = true
        })
    end
}
