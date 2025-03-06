local builtin = require('telescope.builtin')

-- Telescope key mappings
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Clipboard key mappings
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>p', '"+P')
vim.keymap.set('v', '<leader>p', '"+P')
vim.keymap.set('n', '<leader>p', '"+p')
vim.keymap.set('v', '<leader>p', '"+p')

vim.api.nvim_set_keymap('n', '<leader>/', 'gcc', { silent = true })
-- Comments
vim.api.nvim_set_keymap('v', '<leader>/', 'gc', { silent = true })

-- Switch buffer with Tab
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { silent = true })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { silent = true })

vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')

vim.keymap.set({ 'n', 'v', 'i' }, '<C-s>', ':w<CR>', { silent = true })
vim.keymap.set('n', '<leader>w', ':bd<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>W', ':%bd<CR>', { silent = true, noremap = true })

--
vim.keymap.set('n', '<A-l>', ':cnext<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<A-h>', ':cprev<CR>', { silent = true, noremap = true })

vim.keymap.set({ 'n', 'v' }, '<leader>e', ':NvimTreeToggle<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>r', ':NvimTreeChangeRootToNode<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>dn', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })

-- Move selected line or block of lines up
vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>', { noremap = true, silent = true })

-- Visual mode mappings for moving blocks of text
vim.api.nvim_set_keymap('v', '<A-k>', ":m '<-2<CR>gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-j>', ":m '>+1<CR>gv", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
