return {
  -- Other plugins here...

  -- Install nvim-jdtls
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" }, -- Load only for Java files
    config = function()
      -- Optional: Configure nvim-jdtls if needed (setup is described below)
      -- You can leave this empty if you want to configure it in a separate file.
    end,
  }
}
