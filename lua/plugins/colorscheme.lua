return {
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      theme = "neo",
    },
    config = function(_, opts)
      vim.o.background = "light"
      require("solarized").setup(opts)
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        vim.cmd.colorscheme("solarized")
        vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      end,
    },
  },
}
