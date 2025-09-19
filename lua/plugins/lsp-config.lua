return {
    'neovim/nvim-lspconfig',
    opts = {
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

        if use_new_api then
            for name, server_opts in pairs(opts.servers or {}) do
                if name == 'tsserver' then
                    name = 'ts_ls'
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
