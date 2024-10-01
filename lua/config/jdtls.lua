local jdtls = require('jdtls')

-- Determine OS
local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local launcher_path = mason_path .. "/plugins/org.eclipse.equinox.launcher.gtk.linux.x86_64_1.2.1100.v20240722-2106.jar"  -- Update this if necessary
local config_path = mason_path .. "/config_linux"  -- Ensure this is correct for your OS

local workspace_dir = vim.fn.expand("~") .. "/workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local config = {
    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', launcher_path,
        '-configuration', config_path,
        '-data', workspace_dir,
    },

    -- Root directory of the project
    root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' }),

    -- Additional settings and options
    settings = { java = {} },
    init_options = { bundles = {} },
}

-- Start or attach to the language server
jdtls.start_or_attach(config)
