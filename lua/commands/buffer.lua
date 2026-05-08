local cmd = require("commands")

cmd.register("buffer", "save", function()
  vim.cmd("write")
end, { desc = "Sauvegarder le buffer courant" })

cmd.register("buffer", "close", function()
  vim.cmd("bdelete")
end, { desc = "Fermer le buffer courant" })

cmd.register("buffer", "reload", function()
  vim.cmd("edit!")
end, { desc = "Recharger le buffer courant depuis le disque" })
