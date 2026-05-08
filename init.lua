-- Neovim config — point d'entrée
vim.opt.runtimepath:prepend(vim.fn.fnamemodify(vim.env.MYVIMRC, ":h"))

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("lazy.nvim : échec du clone\n" .. out, vim.log.levels.WARN)
  end
end
if (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.opt.rtp:prepend(lazypath)
  local ok, lazy = pcall(require, "lazy")
  if ok then
    lazy.setup({ { import = "plugins" } })
  else
    vim.notify("lazy.nvim : échec du chargement — nvim >= 0.8.0 requis", vim.log.levels.WARN)
  end
end

require("commands").setup()
