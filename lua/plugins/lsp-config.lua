return {
    'neovim/nvim-lspconfig',
    opts = {
        -- Default on_attach to set buffer-local LSP keymaps
        on_attach = function(client, bufnr)
            -- Durable debug log to help diagnose missing mappings
            local function log(msg)
                local ok, f = pcall(io.open, '/tmp/nvim-lsp-debug.log', 'a')
                if not ok or not f then return end
                f:write(msg .. "\n")
                f:close()
            end

            pcall(log, string.format('on_attach called: client=%s bufnr=%d', tostring(client and client.name or 'nil'), bufnr))

            -- Use function-based, buffer-local mappings which are more reliable
            local kb = vim.keymap
            local opts = { noremap = true, silent = true, buffer = bufnr }

            kb.set('n', 'gd', function() vim.lsp.buf.definition() end, vim.tbl_extend('force', opts, { desc = 'LSP: go to definition' }))
            kb.set('n', 'gD', function() vim.lsp.buf.declaration() end, vim.tbl_extend('force', opts, { desc = 'LSP: go to declaration' }))
            kb.set('n', 'gr', function() vim.lsp.buf.references() end, vim.tbl_extend('force', opts, { desc = 'LSP: references' }))
            kb.set('n', 'K', function() vim.lsp.buf.hover() end, vim.tbl_extend('force', opts, { desc = 'LSP: hover' }))
            kb.set('n', '<F2>', function() vim.lsp.buf.rename() end, vim.tbl_extend('force', opts, { desc = 'LSP: rename' }))
            kb.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, vim.tbl_extend('force', opts, { desc = 'LSP: code action' }))
            -- formatting: alt-shift-f can be unreliable in terminals, add a leader fallback
            kb.set('n', '<A-S-f>', function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend('force', opts, { desc = 'LSP: format (alt-shift-f)' }))
            kb.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend('force', opts, { desc = 'LSP: format' }))

            -- Log the actual buffer mappings for 'n' mode (helps confirm mappings exist)
            pcall(function()
                local maps = vim.api.nvim_buf_get_keymap(bufnr, 'n')
                for _, m in ipairs(maps) do
                    if m.lhs and (m.lhs == 'gd' or m.lhs == 'gD' or m.lhs == 'gr' or m.lhs == 'K' or m.lhs == '<F2>' or m.lhs == '<leader>ca' or m.lhs == '<leader>f') then
                        log(string.format('map set: lhs=%s rhs=%s desc=%s', m.lhs, m.rhs or '<func>', tostring(m.desc)))
                    end
                end
            end)
        end,
        servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = { globals = { 'vim' } },
                    },
                },
            },
            eslint = {
                -- Defer requiring lspconfig.util until the plugin is loaded.
                -- Use a function that returns the root_dir value at runtime.
                root_dir = function()
                    local ok, util = pcall(require, 'lspconfig.util')
                    if not ok or not util or not util.root_pattern then
                        -- Fallback: return a function that uses current working directory
                        return function()
                            return vim.loop.cwd()
                        end
                    end
                    -- Return the root-finding function (do not call it here)
                    return util.root_pattern(
                        '.eslintrc',
                        '.eslintrc.json',
                        '.eslintrc.js',
                        '.eslintrc.cjs',
                        '.eslintrc.yaml',
                        '.eslintrc.yml',
                        'eslint.config.js',
                        'package.json'
                    )
                end,
                settings = {
                    workingDirectory = { mode = "auto" },
                },
                on_init = function(client)
                    local root_dir = client.config.root_dir or vim.loop.cwd()
                    local has_eslint_config = vim.fn.glob(root_dir .. '/.eslintrc*') ~= ''
                        or vim.fn.filereadable(root_dir .. '/eslint.config.js') == 1
                        or vim.fn.filereadable(root_dir .. '/package.json') == 1
                    if not has_eslint_config then
                        client.stop()
                    end
                end,
            },
            pyright = {},
            tsserver = {},
        },
        -- `setup` can be a function used by some plugin wrappers. Leave nil to use defaults.
        setup = nil,
    },
    -- Provide a safe config function so lazy.nvim won't try to call the plugin's
    -- module 'setup' field (which changed in newer lspconfig versions).
    config = function(_, opts)
        -- Prefer the new API if available
        local use_new_api = vim and vim.lsp and vim.lsp.config

        local default_on_attach = opts.on_attach

        if use_new_api then
            for name, server_opts in pairs(opts.servers or {}) do
                if name == 'tsserver' then
                    name = 'ts_ls'
                end

                -- Ensure per-server on_attach runs the default on_attach first
                server_opts = server_opts or {}
                do
                    local server_on_attach = server_opts.on_attach
                    if default_on_attach then
                        server_opts.on_attach = function(client, bufnr)
                            default_on_attach(client, bufnr)
                            if type(server_on_attach) == 'function' then
                                server_on_attach(client, bufnr)
                            end
                        end
                    else
                        -- use server's own on_attach if present
                        server_opts.on_attach = server_on_attach
                    end
                end

                -- Register or setup using the new API
                if vim.lsp.config[name] and type(vim.lsp.config[name].setup) == 'function' then
                    vim.lsp.config[name].setup(server_opts)
                else
                    -- Fall back: try to register the server config table
                    if vim.lsp.config[name] then
                        vim.lsp.config[name].default_config = vim.tbl_deep_extend('force', vim.lsp.config[name].default_config or {}, server_opts)
                    end
                end
            end
        else
            -- Fallback for older setups using the lspconfig module
            local ok, lspconfig = pcall(require, 'lspconfig')
            if not ok or not lspconfig then
                return
            end
            for name, server_opts in pairs(opts.servers or {}) do
                if name == 'tsserver' then
                    name = 'ts_ls'
                end
                server_opts = server_opts or {}
                do
                    local server_on_attach = server_opts.on_attach
                    if default_on_attach then
                        server_opts.on_attach = function(client, bufnr)
                            default_on_attach(client, bufnr)
                            if type(server_on_attach) == 'function' then
                                server_on_attach(client, bufnr)
                            end
                        end
                    else
                        server_opts.on_attach = server_on_attach
                    end
                end

                local srv = lspconfig[name]
                if srv and type(srv.setup) == 'function' then
                    srv.setup(server_opts)
                else
                    local okc, configs = pcall(require, 'lspconfig.configs')
                    if okc and configs and configs[name] then
                        configs[name].default_config = vim.tbl_deep_extend('force', configs[name].default_config or {}, server_opts)
                    end
                end
            end
        end
    end,
}
