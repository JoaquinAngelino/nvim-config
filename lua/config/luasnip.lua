-- Setup LuaSnip
local luasnip = require("luasnip")

-- Load the snippet collection (if using friendly-snippets)
require("luasnip.loaders.from_vscode").lazy_load()

-- Set up nvim-cmp
local cmp = require("cmp")

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      luasnip.lsp_expand(args.body)  -- Use LuaSnip to expand snippets
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(),  -- Navigate up in the suggestion list
    ["<C-j>"] = cmp.mapping.select_next_item(),  -- Navigate down in the suggestion list
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),  -- Scroll up in documentation
    ["<C-f>"] = cmp.mapping.scroll_docs(4),  -- Scroll down in documentation
    ["<C-Space>"] = cmp.mapping.complete(),  -- Trigger completion
    ["<C-e>"] = cmp.mapping.abort(),  -- Close the completion menu
    ["<CR>"] = cmp.mapping.confirm({ select = true }),  -- Confirm selection
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },  -- LSP completion source
    { name = "luasnip" },   -- Snippet completion source
  },
})
