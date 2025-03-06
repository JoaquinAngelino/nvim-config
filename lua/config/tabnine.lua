require('tabnine').setup({
    disable_auto_comment = true,
    accept_keymap = "<A-y>",
    dismiss_keymap = "<C-]>",
    -- next_keymap = "<A-o>", -- Go to the next suggestion
    -- prev_keymap = "<A-i>", -- Go to the previous suggestion
    debounce_ms = 800,
    suggestion_color = { gui = "#808080", cterm = 244 },
    exclude_filetypes = { "TelescopePrompt", "NvimTree" },
    log_file_path = nil, -- absolute path to Tabnine log file
    ignore_certificate_errors = false,
})
