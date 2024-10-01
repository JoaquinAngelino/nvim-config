return {
  'akinsho/toggleterm.nvim',
  config = function()
    require("toggleterm").setup({
      direction = 'float',
      open_mapping = [[<A-i>]],
      insert_mappings = true,
      termina_mappings = true,
      float_opts = {
        border = 'curved',
        winblend = 3,
        highlights = {
          border = "Normal",
          background = "Normal",
        }
      },
    })
  end
}
