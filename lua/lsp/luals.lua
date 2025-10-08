vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function(ev)
    vim.lsp.start({
      name = 'lua_ls',
      cmd = { 'lua-language-server' },
      root_dir = vim.fs.root(ev.buf, {'.luarc.json', '.luacheckrc', '.git'}),
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })
  end,
})
