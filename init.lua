-- Neovim config — point d'entrée
local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
vim.opt.runtimepath:prepend(config_dir)

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
    lazy.setup({ { import = "plugins" } }, {
      change_detection = { notify = false },
      performance = { rtp = { paths = { config_dir } } },
    })
  else
    vim.notify("lazy.nvim : échec du chargement — nvim >= 0.8.0 requis", vim.log.levels.WARN)
  end
end

require("commands").setup()
