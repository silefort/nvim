return {
  {
    "folke/tokyonight.nvim",
    init = function()
      vim.o.background = "light"
    end,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}
