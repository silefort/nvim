# nvim
My nvim setup

## Install Packer (https://github.com/wbthomason/packer.nvim)
git clone --depth 1 https://github.com/wbthomason/packer.nvim >  ~/.local/share/nvim/site/pack/packer/start/packer.nvim

## Plugins :


## Remaps : 

### File Navigation

<C-n>       Ex (Open Netrw)
<C-e>       Open harpoon
<leader>ha  Add the current file to harpoon
<leader>vs  Create a new vertical split

### Searching tools
<leader>ff  Find file in current directory using Telescope
<leader>ffg Find file in current git repository
<leader>fs  Find string in current directory files

### File Manipulation
<leader>s   Save current buffer
<leader>sa  Select all text in buffer

### Insert tools
jj          Esc
<leader>sl  Split line
<leader>lb  Add line before
<leader>la  Add line after
<leader>pp  Toggle Paste Mode

### Misc
<leader>nn  Toggle line numbers (for massive copy/paste)

## Commands :
:PackerSync : Clean, Update, Install and Regenerate Compiled Packer leader file

## Todo :
[ ] Setup Packer (Check documentation) (auto Sync...)
[ ] Setup Telescope
[ ] Setup Treesitter (and understand what it does exactly)
[ ] Setup Harpoon properly (with new bindings, h/n/p/s/t doesn't work for me)
[ ] Setup Undotree
[ ] Setup fugitive
[ ] How to remove files from harpoon ?
[ ] Add my keybindings
[ ] Add my regular vim setups
[ ] Create a proper cheatsheet in this readme with all the remappings and commands
[ ] Always ignore un~ and swp files
