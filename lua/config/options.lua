local opt = vim.opt

vim.g.mapleader = " "

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.breakindent = true
opt.smartcase = true
opt.ignorecase = true
opt.inccommand = "split"
opt.foldmethod = "manual"
opt.undofile = true
opt.linebreak = true
opt.wrap = true
opt.splitright = true
opt.splitbelow = true
opt.expandtab = true
opt.conceallevel = 1

-- opt.winborder = "rounded"

vim.opt.scrolloff = 12
vim.lsp.enable("copilot")
