return {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")

    -- Global toggle for auto-formatting
    local autoformat_enabled = false

    -- Helper function to toggle autoformatting
    function ToggleAutoformat()
      autoformat_enabled = not autoformat_enabled
      print("Autoformat on save: " .. (autoformat_enabled and "Enabled" or "Disabled"))

      -- Re-apply autocmds for all buffers with LSP attached
      vim.lsp.buf_get_clients(0)   -- current buffer only
      for _, client in pairs(vim.lsp.get_active_clients()) do
        if client.supports_method("textDocument/formatting") then
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local bufnr = buf   -- iterate through buffers
            if vim.api.nvim_buf_is_loaded(bufnr) then
              local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
              vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

              if autoformat_enabled then
                vim.api.nvim_create_autocmd("BufWritePre", {
                  group = augroup,
                  buffer = bufnr,
                  callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                  end,
                })
              end
            end
          end
        end
      end
    end

    -- Define your preferred sources
    local sources = {
      -- Formatting
      null_ls.builtins.formatting.prettier,   -- For formatting JS/TS, HTML, CSS, etc.
      null_ls.builtins.formatting.stylua,     -- For formatting Lua

      -- Linting
      null_ls.builtins.diagnostics.eslint,   -- For JavaScript/TypeScript linting

      -- Code actions
      null_ls.builtins.code_actions.gitsigns,   -- Git-related code actions
      null_ls.builtins.formatting.eslint.with({
        command = "./node_modules/.bin/eslint",
        extra_args = { "--config", ".eslintrc.js" },
      }),
      --   null_ls.builtins.diagnostics.eslint.with({
      --     command = "./node_modules/.bin/eslint",
      --   }),
      null_ls.builtins.code_actions.eslint.with({
        command = "./node_modules/.bin/eslint",
      }),
    }

    -- Setup null-ls with ESLint
    null_ls.setup({
      sources = sources,
      debug = false,
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

          -- Only enable auto-formatting if it's enabled
          if autoformat_enabled then
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end
      end,
    })

    -- Create a keymap or command to toggle autoformat
    vim.api.nvim_set_keymap("n", "<leader>af", ":lua ToggleAutoformat()<CR>", { noremap = true, silent = true })
  end,
}
