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
            numhl = false,             -- Disable number highlighting
            linehl = false,            -- Disable line highlighting
            watch_gitdir = {
                interval = 1000,       -- Watch for changes in git repo
            },
            current_line_blame = true, -- Disable inline blame by default
            sign_priority = 6,         -- Priority of signs
            update_debounce = 100,     -- Time to wait before updating signs
            status_formatter = nil,    -- Use default status formatting
            max_file_length = 40000,   -- Disable signs for large files
        })
    end,
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Function to make mapping easier
        local function map(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Gitsigns key mappings

        -- Navigation between hunks
        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, { expr = true })

        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, { expr = true })

        -- Stage current hunk
        map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')

        -- Undo stage hunk
        map('n', '<leader>hu', gs.undo_stage_hunk)

        -- Reset current hunk
        map('n', '<leader>hr', gs.reset_hunk)

        -- Reset entire buffer
        map('n', '<leader>hR', gs.reset_buffer)

        -- Preview current hunk
        map('n', '<leader>hp', gs.preview_hunk)

        -- Blame current line
        map('n', '<leader>hb', function() gs.blame_line { full = true } end)

        -- Toggle deleted lines
        map('n', '<leader>hd', gs.toggle_deleted)

        -- Other optional mappings (if needed)
        -- Stage entire buffer
        map('n', '<leader>hS', gs.stage_buffer)

        -- Diff current file against the last commit
        map('n', '<leader>hd', ':Gitsigns diffthis<CR>')
    end
}
