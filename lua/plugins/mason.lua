return {{
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
        require("mason").setup({
            PATH = "prepend",
            registries = { -- additional registries required for rosyln
            "github:mason-org/mason-registry", "github:Crashdummyy/mason-registry"}
        })
    end
}, {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {"lua_ls", "gopls", "csharp_ls", "zls"}
        })
    end
}}
