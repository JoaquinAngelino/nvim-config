require('telescope').setup {
    defaults = {
        file_ignore_patterns = { "node_modules", ".git/" },
        vimgrep_arguments = {
            'rg',
            '--hidden',     -- Include hidden files
            '--follow',     -- Follow symlinks
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--glob', '!.git/', -- Exclude .git directory
        },
        pickers = {
            find_files = {
                find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix', '--hidden', '--follow', '--exclude', '.git' },
            },
        },
    }
}
