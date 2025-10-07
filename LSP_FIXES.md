# LSP Configuration Fixes

## Issues Fixed

### Issue 1: Deprecation Warning
**Problem:** `require('lspconfig')` framework is deprecated in Neovim 0.11+, should use `vim.lsp.config` instead.

**Error Message:**
```
The `require('lspconfig')` "framework" is deprecated, use vim.lsp.config (see :help lspconfig-nvim-0.11) instead.
Feature will be removed in nvim-lspconfig v3.0.0
```

### Issue 2: ESLint root_dir Error
**Problem:** The `root_dir` configuration for eslint was incorrectly returning a function instead of being a function that returns a string.

**Error Message:**
```
[lspconfig] unhandled error: vim/fs.lua:0: path: expected string, got function
```

## Changes Made

### 1. Fixed eslint root_dir (Lines 49-63)

**Before:**
```lua
root_dir = function()
    local ok, util = pcall(require, 'lspconfig.util')
    if not ok or not util or not util.root_pattern then
        return function()
            return vim.loop.cwd()
        end
    end
    return util.root_pattern(...)
end
```

**After:**
```lua
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
end
```

**Key Changes:**
- `root_dir` now properly accepts a `fname` parameter (the filename being processed)
- Directly requires `lspconfig.util` (safe because this runs after plugin is loaded)
- Calls `util.root_pattern(...)(fname)` to get the actual root directory string
- Provides fallback to `vim.loop.cwd()` if no root is found

### 2. Added Support for New vim.lsp.config API (Lines 83-157)

**Implementation:**
```lua
config = function(_, opts)
    -- Check if new API is available (Neovim 0.11+)
    local use_new_api = vim.lsp.config ~= nil and vim.lsp.enable ~= nil
    
    if use_new_api then
        -- Use new vim.lsp.config API (suppresses deprecation warning)
        for name, server_opts in pairs(opts.servers or {}) do
            -- ... setup logic ...
            vim.lsp.config(name, server_opts)
            vim.lsp.enable(name)
        end
    else
        -- Use legacy lspconfig API for older Neovim versions
        local ok, lspconfig = pcall(require, 'lspconfig')
        -- ... existing logic ...
    end
end
```

**Key Features:**
- Detects if new `vim.lsp.config` and `vim.lsp.enable` APIs are available
- Uses new API when available (Neovim 0.11+) to eliminate deprecation warnings
- Falls back to legacy `lspconfig` API for older Neovim versions
- Maintains backward compatibility
- Preserves all existing functionality (on_attach, server-specific configs, etc.)

## Testing

A validation test was created (`/tmp/test_lsp_config.lua`) that verifies:
- ✓ Configuration loads without syntax errors
- ✓ `eslint.root_dir` is a function (not a function returning a function)
- ✓ `eslint.root_dir('/tmp/test.js')` returns a string (not a function)
- ✓ Config function executes without errors in both new and legacy modes

## Migration Notes

### For Neovim 0.11+ users:
- No action needed - the configuration will automatically use the new API
- Deprecation warnings will no longer appear

### For older Neovim users:
- Configuration continues to work with the legacy lspconfig API
- Consider upgrading to Neovim 0.11+ to use the new LSP configuration system

## Files Modified

- `lua/plugins/lsp-config.lua` - Fixed both issues

## Related Documentation

- See `:help lspconfig-nvim-0.11` in Neovim for details on the new API
- See `:help vim.lsp.config()` for the new configuration function
- See `:help vim.lsp.enable()` for enabling LSP servers
