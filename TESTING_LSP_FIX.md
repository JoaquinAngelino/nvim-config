# Testing LSP Keybindings Fix

This document explains how to verify that the LSP keybindings fix is working correctly.

## What was fixed

The LSP server configuration in `lua/plugins/lsp-config.lua` was not properly calling `lspconfig[server].setup()`, which meant LSP servers were never started and the `on_attach` function (which sets up keybindings) was never executed.

## Changes made

1. **Simplified LSP setup** - Removed complex branching logic for non-existent API and directly use the standard `lspconfig` module
2. **Added F12 keybinding** - Added F12 as an alternative to F2 for rename (common IDE convention)
3. **Consistent keybindings** - Applied same fix to both `lsp-config.lua` and `jdtls.lua`

## How to verify the fix

### 1. Check LSP servers are installed

```vim
:Mason
```

Ensure these servers are installed:
- lua_ls (for Lua)
- pyright (for Python)
- ts_ls (for TypeScript/JavaScript)
- jdtls (for Java)

### 2. Open a file and verify LSP attaches

Open a file in one of the supported languages:
```bash
nvim test.lua
# or
nvim test.py
# or
nvim test.ts
# or
nvim Test.java
```

Check LSP status:
```vim
:LspInfo
```

You should see the LSP client attached and running.

### 3. Test the keybindings

With your cursor on a symbol/function/variable:

- **gd** - Go to definition (should jump to where the symbol is defined)
- **gD** - Go to declaration
- **gr** - Show references (should show all places where symbol is used)
- **K** - Show hover documentation
- **F2** or **F12** - Rename symbol
- **<leader>ca** - Show code actions (if your leader is Space, press Space then c then a)
- **<leader>f** - Format the file

### 4. Check debug logs

The configuration writes debug logs to help verify mappings are set:

```bash
cat /tmp/nvim-lsp-debug.log
```

You should see entries like:
```
on_attach called: client=lua_ls bufnr=1
map set: lhs=gd rhs=<func> desc=LSP: go to definition
map set: lhs=gD rhs=<func> desc=LSP: go to declaration
...
```

## Troubleshooting

### LSP not attaching
- Make sure the LSP server is installed via Mason (`:Mason`)
- Check for errors with `:messages`
- Make sure you're in a proper project directory (some LSP servers need a project root)

### Keybindings not working
- Check if LSP is attached with `:LspInfo`
- Verify the mapping exists with `:nmap gd` (should show the LSP mapping)
- Check the debug log at `/tmp/nvim-lsp-debug.log`

### Server-specific issues

**eslint**: Only starts if project has eslint config file (`.eslintrc*`, `eslint.config.js`, or package.json)

**jdtls (Java)**: Only starts for `.java` files and needs a project root with `pom.xml`, `build.gradle`, or similar

## Expected behavior after fix

1. When you open a supported file, the LSP server should automatically attach
2. All keybindings (gd, gD, gr, K, F2, F12, <leader>ca, <leader>f) should work immediately
3. The debug log should show the `on_attach` was called and mappings were set
