-- LSP configuration
return {
  'neovim/nvim-lspconfig',
  config = function()
    local lspconfig = require('lspconfig')
    local cmp_nvim_lsp = require('cmp_nvim_lsp')

    -- Capabilities for autocompletion
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Define `on_attach` function for keybindings and other settings
    local on_attach = function(_, bufnr)
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
    end

    -- Lua language server
    lspconfig.lua_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { 'vim' } },
        },
      },
    }

    -- ESLint language server
    lspconfig.eslint.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = lspconfig.util.root_pattern(
        '.eslintrc',
        '.eslintrc.json',
        '.eslintrc.js',
        '.eslintrc.cjs',
        '.eslintrc.yaml',
        '.eslintrc.yml',
        'eslint.config.js',
        'package.json'
      ),
      settings = {
        workingDirectory = { mode = "auto" },
      },
      on_init = function(client)
        local root_dir = client.config.root_dir or vim.loop.cwd()
        local has_eslint_config = vim.fn.glob(root_dir .. '/.eslintrc*') ~= ''
          or vim.fn.filereadable(root_dir .. '/eslint.config.js') == 1
          or vim.fn.filereadable(root_dir .. '/package.json') == 1

        if not has_eslint_config then
          -- Stop the client silently without throwing errors
          client.stop()
        end
      end,
    }

    -- Python language server
    lspconfig.pyright.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    -- TypeScript/JavaScript language server
    lspconfig.ts_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
}