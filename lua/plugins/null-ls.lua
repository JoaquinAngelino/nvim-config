return {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    local format_on_save_enabled = true     -- Add a flag to control format-on-save

    null_ls.setup({
      sources = {
        -- Utiliza prettier solo si no hay un archivo de configuración de ESLint en el proyecto
        null_ls.builtins.formatting.prettier.with({
          condition = function(utils)
            return not utils.root_has_file({ ".eslintrc.js", ".eslintrc.json", ".eslintrc" })
          end,
        }),

        -- Usa eslint_d solo si existe un archivo de configuración de ESLint
        null_ls.builtins.formatting.eslint_d.with({
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json", ".eslintrc" })
          end,
        }),

        -- Opcional: Añadir soporte de diagnóstico para eslint_d
        null_ls.builtins.diagnostics.eslint_d.with({
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json", ".eslintrc" })
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
              if format_on_save_enabled then
                vim.lsp.buf.format({ bufnr = bufnr })
              end
            end,
          })
        end

        -- Add a keybinding to toggle format-on-save
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>tf", "", {
          callback = function()
            format_on_save_enabled = not format_on_save_enabled
            print("Format on save: " .. (format_on_save_enabled and "ENABLED" or "DISABLED"))
          end,
          noremap = true,
          silent = true,
          desc = "Toggle format on save",
        })
      end,
    })
  end,
}
