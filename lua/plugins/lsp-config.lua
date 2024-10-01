-- LSP configuration
return {
  'neovim/nvim-lspconfig',
  config = function()
    local lspconfig = require('lspconfig')

    -- Define `on_attach` function for keybindings and other settings
    local on_attach = function(client, bufnr)
      local buf_map = function(mode, lhs, rhs)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Keybindings for LSP
      buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
      buf_map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
      buf_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
      buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
      buf_map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>')
      buf_map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
      buf_map('n', '<A-S-f>', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>')

      -- Additional LSP settings can be added here, such as enabling specific features
    end

    -- Servers to configure
    lspconfig.lua_ls.setup {
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = { globals = { 'vim' } },
        },
      },
    }

    lspconfig.pyright.setup { on_attach = on_attach }
    lspconfig.ts_ls.setup { on_attach = on_attach }
  end,
}
