# Summary: LSP Configuration Issues Fixed

## Issues Resolved

Both reported issues in the LSP configuration have been successfully fixed:

### ✅ Issue 1: Deprecation Warning
**Original Error:**
```
The `require('lspconfig')` "framework" is deprecated, use vim.lsp.config (see :help lspconfig-nvim-0.11) instead.
Feature will be removed in nvim-lspconfig v3.0.0
```

**Solution:** Added conditional support for the new `vim.lsp.config` and `vim.lsp.enable` API while maintaining backward compatibility with older Neovim versions.

### ✅ Issue 2: ESLint root_dir Error
**Original Error:**
```
[lspconfig] unhandled error: vim/fs.lua:0: path: expected string, got function
```

**Solution:** Fixed the `eslint` server's `root_dir` configuration to properly return a string instead of returning a function.

## Changes Made

### File: `lua/plugins/lsp-config.lua`

#### 1. Fixed ESLint root_dir (Lines 50-63)
**Before:** The `root_dir` was a function that returned another function
**After:** The `root_dir` is now a function that takes a filename parameter and returns a string path

```lua
root_dir = function(fname)
    local util = require('lspconfig.util')
    return util.root_pattern(
        '.eslintrc',
        '.eslintrc.json',
        -- ... other patterns
    )(fname) or vim.loop.cwd()
end
```

#### 2. Added New API Support (Lines 83-157)
The configuration now detects which API is available and uses the appropriate one:

- **Neovim 0.11+**: Uses `vim.lsp.config()` and `vim.lsp.enable()` (no deprecation warning)
- **Older Neovim**: Uses legacy `require('lspconfig')` API (maintains compatibility)

## Validation

All changes have been tested with automated tests:

✅ Configuration loads without syntax errors
✅ `eslint.root_dir` correctly returns a string (not a function)
✅ Legacy API path works correctly (older Neovim)
✅ New API path works correctly (Neovim 0.11+)
✅ Server setup is called for all configured servers

## What This Means for You

### If you're using Neovim 0.11 or newer:
- ✅ No more deprecation warnings
- ✅ Using the modern LSP configuration API
- ✅ Your LSP servers will start correctly

### If you're using older Neovim:
- ✅ Configuration still works with the legacy API
- ✅ No breaking changes
- ✅ LSP servers will start correctly

## Additional Documentation

For more details, see:
- `LSP_FIXES.md` - Comprehensive explanation of the changes
- `:help lspconfig-nvim-0.11` - Neovim documentation for the new API
- `:help vim.lsp.config()` - Documentation for the new config function
