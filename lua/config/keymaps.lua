local map = vim.keymap.set

-- Surcharge les defaults LazyVim (<C-w>hjkl) pour navigation seamless nvim ↔ tmux
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>",  { desc = "Naviguer à gauche (vim/tmux)",  silent = true })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>",  { desc = "Naviguer en bas (vim/tmux)",    silent = true })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>",    { desc = "Naviguer en haut (vim/tmux)",   silent = true })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Naviguer à droite (vim/tmux)",  silent = true })
