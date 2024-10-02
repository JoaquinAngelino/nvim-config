return {
  "mfussenegger/nvim-jdtls",
  dependencies = {
    "mfussenegger/nvim-dap",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local jdtls = require("jdtls")

    local on_attach = function(_, bufnr)
      local buf_map = function(mode, lhs, rhs)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
      buf_map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
      buf_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
      buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
      buf_map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>')
      buf_map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
      buf_map('n', '<A-S-f>', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>')

      buf_map("n", "<leader>oi", "<cmd>lua require('jdtls').organize_imports()<CR>")
      buf_map("n", "<leader>ev", "<cmd>lua require('jdtls').extract_variable()<CR>")
      buf_map("n", "<leader>ec", "<cmd>lua require('jdtls').extract_constant()<CR>")
      buf_map("v", "<leader>em", "<Esc><cmd>lua require('jdtls').extract_method(true)<CR>")

      -- Agrega más mapeos o configuraciones que necesites
    end

    local function setup_jdtls()
      local root_dir = require('jdtls.setup').find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })

      local config = {
        cmd = { "jdtls" },
        root_dir = root_dir,
        on_attach = on_attach,
        settings = {
          java = {
            configuration = {
              runtimes = {
                -- Configura aquí los JDKs adicionales si los tienes
              },
            },
          },
        },
        init_options = {
          bundles = {},
        },
      }

      jdtls.start_or_attach(config)
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        setup_jdtls()
      end,
    })
  end,
}
