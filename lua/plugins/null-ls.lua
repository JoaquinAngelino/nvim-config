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
      vim.lsp.buf_get_clients(0) -- current buffer only
      for _, client in pairs(vim.lsp.get_active_clients()) do
        if client.supports_method("textDocument/formatting") then
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local bufnr = buf -- iterate through buffers
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

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.prettier.with({
          disabled_filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
        }),
        null_ls.builtins.formatting.eslint_d.with({
          condition = function(utils)
            -- Only enable ESLint formatting if a config file exists
            return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json", ".eslintrc" })
          end,
          extra_args = function(params)
            local config_file = vim.fn.findfile(".eslintrc.js", params.root)
            return config_file ~= "" and { "--config", config_file } or {}
          end,
        }),
      },
      on_attach = function(client, bufnr)
        if client.server_capabilities.documentFormattingProvider then
          local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    })
  end,
}
