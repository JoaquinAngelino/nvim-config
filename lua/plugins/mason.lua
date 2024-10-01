-- Mason to manage LSP servers, linters, etc.
return {
  {
    'williamboman/mason.nvim',
    build = ":MasonUpdate", -- Optional: auto-update mason packages
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 'lua_ls', 'pyright', 'ts_ls', 'jdtls' }, -- List servers you need
      })
    end,
  }
}
