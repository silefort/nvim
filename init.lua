-- Neovim config — point d'entrée
vim.opt.runtimepath:prepend(vim.fn.fnamemodify(vim.env.MYVIMRC, ":h"))
require("commands").setup()
