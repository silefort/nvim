vim.g.mapleader = " "
vim.keymap.set("n", "<C-n>", vim.cmd.Ex)
vim.keymap.set("n", "<leader>s", vim.cmd.w)
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<leader>sl", "i<CR><Esc>")
vim.keymap.set("n", "<leader>la", "o<Esc>k")
vim.keymap.set("n", "<leader>lb", "O<Esc>j")

-- Toggle show Number ( for copy paste )
vim.keymap.set("n", "<leader>nn", ":set relativenumber!<CR>:set number!<CR>")

-- Create a new vertical split easily
vim.keymap.set("n", "<leader>vs", "<C-w>v<C-w>l")

-- reselect visual block after indent/outdent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Select all text in current buffer
vim.keymap.set("n", "<leader>sa", "ggVG")

-- Make Y act like C and D (copy till the end of the line)
vim.keymap.set("n", "Y", "y$")

-- Toggle paste mode on and off
vim.keymap.set("n", "<leader>pp", ":setlocal paste!<CR>")
