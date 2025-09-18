require("config.init")

-- Disable swap file
vim.opt.swapfile = false

-- Tab and indentation settings
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Folding settings
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
