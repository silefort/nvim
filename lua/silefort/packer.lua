-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
     requires = { {'nvim-lua/plenary.nvim'} }
  }

  use ({ 'shaunsingh/solarized.nvim',
	config = function()
		vim.cmd('colorscheme solarized')
		vim.cmd('set background=light')
	end
  })
  use ('ThePrimeagen/harpoon')

end)
