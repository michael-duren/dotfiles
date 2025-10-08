vim.g.mapleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:block,o:block"

opt.clipboard = "unnamedplus"

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

vim.cmd('highlight CursorLineNr ctermfg=white guifg=white')
