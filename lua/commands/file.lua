local cmd = require("commands")

local function with_telescope(fn)
  local ok, builtin = pcall(require, "telescope.builtin")
  if not ok then
    vim.notify("telescope n'est pas disponible", vim.log.levels.ERROR)
    return
  end
  fn(builtin)
end

local function search()
  with_telescope(function(b) b.find_files() end)
end

local list_filters = { recent = function(b) b.oldfiles() end }

local function list(filter)
  if filter == nil then
    vim.notify("File list: argument requis (recent)", vim.log.levels.ERROR)
    return
  end
  local handler = list_filters[filter]
  if not handler then
    vim.notify("File list: filtre inconnu '" .. filter .. "'", vim.log.levels.ERROR)
    return
  end
  with_telescope(handler)
end

cmd.register("file", "search", search, {
  desc = "Chercher un fichier par nom (telescope find_files)",
})

cmd.register("file", "list", list, {
  desc = "Lister des fichiers selon un filtre (recent)",
  complete = function(arglead)
    return vim.tbl_filter(
      function(f) return vim.startswith(f, arglead) end,
      vim.tbl_keys(list_filters)
    )
  end,
})
