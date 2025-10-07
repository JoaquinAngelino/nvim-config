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
                -- root_dir must be a function that takes filename and returns root path
                root_dir = function(fname)
                    local util = require('lspconfig.util')
                    return util.root_pattern(
                        '.eslintrc',
                        '.eslintrc.json',
                        '.eslintrc.js',
                        '.eslintrc.cjs',
                        '.eslintrc.yaml',
                        '.eslintrc.yml',
                        'eslint.config.js',
                        'package.json'
                    )(fname) or vim.loop.cwd()
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
    config = function(_, opts)
        -- Check if new API is available (Neovim 0.11+)
        local use_new_api = vim.lsp.config ~= nil and vim.lsp.enable ~= nil
        
        if use_new_api then
            -- Use new vim.lsp.config API (suppresses deprecation warning)
            local default_on_attach = opts.on_attach

            for name, server_opts in pairs(opts.servers or {}) do
                -- Handle tsserver -> ts_ls rename
                if name == 'tsserver' then
                    name = 'ts_ls'
                end

                server_opts = server_opts or {}

                -- Ensure per-server on_attach runs the default on_attach first
                local server_on_attach = server_opts.on_attach
                if default_on_attach then
                    server_opts.on_attach = function(client, bufnr)
                        default_on_attach(client, bufnr)
                        if type(server_on_attach) == 'function' then
                            server_on_attach(client, bufnr)
                        end
                    end
                elseif server_on_attach then
                    server_opts.on_attach = server_on_attach
                end

                -- Configure and enable LSP server using new API
                vim.lsp.config(name, server_opts)
                vim.lsp.enable(name)
            end
        else
            -- Use legacy lspconfig API for older Neovim versions
            local ok, lspconfig = pcall(require, 'lspconfig')
            if not ok or not lspconfig then
                vim.notify('lspconfig not found', vim.log.levels.ERROR)
                return
            end

            local default_on_attach = opts.on_attach

            -- Setup each server defined in opts.servers
            for name, server_opts in pairs(opts.servers or {}) do
                -- Handle tsserver -> ts_ls rename
                if name == 'tsserver' then
                    name = 'ts_ls'
                end

                server_opts = server_opts or {}

                -- Ensure per-server on_attach runs the default on_attach first
                local server_on_attach = server_opts.on_attach
                if default_on_attach then
                    server_opts.on_attach = function(client, bufnr)
                        default_on_attach(client, bufnr)
                        if type(server_on_attach) == 'function' then
                            server_on_attach(client, bufnr)
                        end
                    end
                elseif server_on_attach then
                    server_opts.on_attach = server_on_attach
                end

                -- Setup the LSP server using lspconfig
                local srv = lspconfig[name]
                if srv and type(srv.setup) == 'function' then
                    srv.setup(server_opts)
                else
                    vim.notify(string.format('LSP server %s not found in lspconfig', name), vim.log.levels.WARN)
                end
            end
        end
    end,
}
