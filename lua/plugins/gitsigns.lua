return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require('gitsigns').setup({
      signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
      },
      numhl = false,               -- Disable number highlighting
      linehl = false,              -- Disable line highlighting
      watch_gitdir = {
        interval = 1000,           -- Watch for changes in git repo
      },
      current_line_blame = true,   -- Disable inline blame by default
      sign_priority = 6,           -- Priority of signs
      update_debounce = 100,       -- Time to wait before updating signs
      status_formatter = nil,      -- Use default status formatting
      max_file_length = 40000,     -- Disable signs for large files
    })
  end,
}
