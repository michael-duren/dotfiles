vim.api.nvim_create_autocmd('FileType', {
    pattern = 'cs',
    callback = function(ev)
        vim.lsp.start({
            name = 'csharp_ls',
            cmd = {'csharp-ls'},
            root_dir = vim.fs.root(ev.buf, {'*.sln', '*.csproj', 'omnisharp.json', 'function.json', '.git'})
        })
    end
})

vim.lsp.config("roslyn", {})
