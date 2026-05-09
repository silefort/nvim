return {
  "maxmx03/solarized.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    theme = "neo",
    variant = "winter",
  },
  config = function(_, opts)
    vim.o.background = "light"
    vim.o.termguicolors = true
    require("solarized").setup(opts)
    vim.cmd.colorscheme("solarized")
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  end,
}
