-- Autocompletion plugins
return {
  'hrsh7th/nvim-cmp',          -- Main autocompletion plugin
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',    -- LSP source for nvim-cmp
    'hrsh7th/cmp-buffer',      -- Buffer source for nvim-cmp
    'hrsh7th/cmp-path',        -- Path source for nvim-cmp
    'hrsh7th/cmp-cmdline',     -- Cmdline source for nvim-cmp
    'L3MON4D3/LuaSnip',        -- Snippet engine
    'saadparwaiz1/cmp_luasnip' -- Snippet source for nvim-cmp
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    cmp.setup({
      snippet = {
        expand = function(args)
          -- Use LuaSnip as the snippet engine
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' }, -- LSP completion source
        { name = 'luasnip' },  -- Snippets source
      }, {
        { name = 'buffer' },   -- Buffer completion source
        { name = 'path' },     -- Path completion source
      }),
    })
  end,
}
