return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<CR>",  desc = "Naviguer à gauche (vim/tmux)" },
    { "<C-j>", "<cmd><C-U>TmuxNavigateDown<CR>",  desc = "Naviguer en bas (vim/tmux)" },
    { "<C-k>", "<cmd><C-U>TmuxNavigateUp<CR>",    desc = "Naviguer en haut (vim/tmux)" },
    { "<C-l>", "<cmd><C-U>TmuxNavigateRight<CR>", desc = "Naviguer à droite (vim/tmux)" },
  },
}
