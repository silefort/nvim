# nvim
My nvim setup

## Install Packer (https://github.com/wbthomason/packer.nvim)
git clone --depth 1 https://github.com/wbthomason/packer.nvim >  ~/.local/share/nvim/site/pack/packer/start/packer.nvim

## Plugins :


## Remaps : 
<C-e> Open harpoon
<C-h> Go to first file in harpoon list
<C-n> Go to third file in harpoon list
<C-p>  : Find file in current git repository
<C-s> Go to fourth file in harpoon list
<C-t> Go to second file in harpoon list
<leader>a Add the current file to harpoon
<leader>pf Find file in current directory using Telescope
<leader>ps Find string in current directory files
<leader>pv :Ex (Open Netrw)

## Commands :
:PackerSync : Clean, Update, Install and Regenerate Compiled Packer leader file

## Todo :
[ ] Setup Packer (Check documentation) (auto Sync...)
[ ] Setup Telescope
[ ] Setup Harpoon
