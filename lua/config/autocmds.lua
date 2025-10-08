-- go to last loc when opening a buffer
-- vim.api.nvim_create_autocmd("BufReadPost", {
--     group = vim.api.nvim_create_augroup("last_loc"),
--     callback = function(event)
--         local exclude = {"gitcommit"}
--         local buf = event.buf
--         if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
--             return
--         end
--         vim.b[buf].lazyvim_last_loc = true
--         local mark = vim.api.nvim_buf_get_mark(buf, '"')
--         local lcount = vim.api.nvim_buf_line_count(buf)
--         if mark[1] > 0 and mark[1] <= lcount then
--             pcall(vim.api.nvim_win_set_cursor, 0, mark)
--         end
--     end
-- })
-- set tab size to 2 for json, css, html files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "json,css,html,typescript,javascript,typescriptreact,javascriptreact,scss,sass",
    callback = function()
        vim.opt.tabstop = 2
        vim.opt.softtabstop = 2
        vim.opt.shiftwidth = 2
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "mdx",
    callback = function()
        -- turn on spell checking for markdown files
        vim.cmd("setlocal spell spelllang=en_us")
    end
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "mmd",
    callback = function()
        -- turn on spell checking for markdown files
        vim.cmd("setlocal spell spelllang=en_us")
    end
})
