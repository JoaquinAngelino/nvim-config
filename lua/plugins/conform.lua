return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black", "isort" },
                javascript = { "eslint", "prettier", "prettierd" },
                typescript = { "eslint", "prettier", "prettierd" },
                json = { "jq" },
                markdown = { "prettier" },
            },
            formatters = {
                eslint = {
                    command = "eslint", -- o "eslint"
                    args = { "--fix", "--stdin", "--stdin-filename", "$FILENAME" },
                    cwd = require("conform.util").root_file({ ".eslintrc.js", "package.json", ".git" }),
                },
            },
            format_on_save = function(bufnr)
                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return { timeout_ms = 500, lsp_fallback = true }
            end,
        })

        -- Comandos para deshabilitar/habilitar
        vim.api.nvim_create_user_command("FormatDisable", function(args)
            if args.bang then
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, {
            desc = "Disable autoformat-on-save",
            bang = true,
        })

        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, {
            desc = "Re-enable autoformat-on-save",
        })

        -- Toggle por keymap
        function ToggleAutoFormat()
            vim.g.disable_autoformat = not vim.g.disable_autoformat
            print("Autoformat: " .. (vim.g.disable_autoformat and "OFF" or "ON"))
        end

        vim.api.nvim_set_keymap("n", "<leader>tf", ":lua ToggleAutoFormat()<CR>", { noremap = true, silent = true })
    end
}
