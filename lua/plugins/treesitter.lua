--- File: lua/plugins.lua (or wherever your lazy.nvim config is)
return {
  -- Other plugin configurations...
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',  -- Automatically update parsers when installing
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "lua", "vim", "vimdoc", "query", "javascript", "html", "css", "java", "kotlin" },
        auto_install = true,
        highlight = { enable = true, additional_vim_regex_highlighting = false },      -- Enable syntax highlighting
        indent = { enable = true }, -- Enable indentation based on treesitter
        -- Add other modules here if needed
      }
    end,
  },

  -- Add other plugins as needed
}
