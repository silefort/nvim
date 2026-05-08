local cmd = require("commands")

local function search()
  local ok, builtin = pcall(require, "telescope.builtin")
  if not ok then
    vim.notify("telescope n'est pas disponible", vim.log.levels.ERROR)
    return
  end
  builtin.live_grep()
end

cmd.register("string", "search", search, {
  desc = "Chercher une chaîne dans le projet (telescope live_grep)",
})
