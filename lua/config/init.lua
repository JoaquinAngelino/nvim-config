require("config.options")
require("config.lazy")
require("config.lualine")
require("config.luasnip")
require("config.mappings")
require("config.tabnine")
require("config.telescope")
require("config.terminal")

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
  git = {
    enable = true, -- Show git-ignored files by default
    ignore = false,
  }
})
