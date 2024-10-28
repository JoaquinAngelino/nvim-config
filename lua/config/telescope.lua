local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    file_ignore_patterns = { "node_modules", ".git/" },
    vimgrep_arguments = {
      'rg',
      '--hidden',       -- Include hidden files
      '--follow',       -- Follow symlinks
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--glob', '!.git/',       -- Exclude .git directory
    },
    mappings = {
      i = {
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
        ["<C-o>"] = actions.send_selected_to_qflist + actions.open_qflist
      },
      n = {
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
        ["<C-o>"] = actions.send_selected_to_qflist + actions.open_qflist
      },
    },
    pickers = {
      find_files = {
        find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix', '--hidden', '--follow', '--exclude', '.git' },
      },
    },
  }
}
