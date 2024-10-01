-- Autocompletion plugins
return {
  'hrsh7th/nvim-cmp',            -- Main autocompletion plugin
  'hrsh7th/cmp-nvim-lsp',        -- LSP source for nvim-cmp
  dependencies = {
    'hrsh7th/cmp-buffer',        -- Buffer source for nvim-cmp
    'hrsh7th/cmp-path',          -- Path source for nvim-cmp
    'hrsh7th/cmp-cmdline',       -- Cmdline source for nvim-cmp
    'L3MON4D3/LuaSnip',          -- Snippets
    'saadparwaiz1/cmp_luasnip'   -- Snippets source for nvim-cmp
  },
  config = function()
    local cmp = require('cmp')
    cmp.setup({
      mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
      },
    })
  end,
}
