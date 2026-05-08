local M = {}

M._registry = {}

local function pascal_case(s)
  return s:sub(1, 1):upper() .. s:sub(2)
end

local function create_object_command(object)
  local cmd_name = pascal_case(object)
  vim.api.nvim_create_user_command(cmd_name, function(opts)
    local action = opts.fargs[1]
    local entry = M._registry[object] and M._registry[object][action]
    if not entry then
      vim.notify(("%s : action inconnue %q"):format(cmd_name, action or ""), vim.log.levels.ERROR)
      return
    end
    local rest = vim.list_slice(opts.fargs, 2)
    entry.fn(unpack(rest))
  end, {
    nargs = "+",
    complete = function(arglead, cmdline)
      local parts = vim.split(cmdline, "%s+", { trimempty = true })
      -- parts[1] = command name, parts[2] = action being typed
      local completing_action = #parts == 1 or (#parts == 2 and arglead ~= "")
      if completing_action then
        local actions = {}
        for action in pairs(M._registry[object] or {}) do
          if action:find(arglead, 1, true) == 1 then
            table.insert(actions, action)
          end
        end
        table.sort(actions)
        return actions
      end
      -- delegate to per-action completion if defined
      local action = parts[2]
      local entry = M._registry[object] and M._registry[object][action]
      if entry and entry.complete then
        return entry.complete(arglead, vim.list_slice(parts, 3))
      end
      return {}
    end,
    desc = "Commandes " .. object .. "-*",
  })
end

function M.register(object, action, fn, opts)
  local is_new_object = M._registry[object] == nil
  M._registry[object] = M._registry[object] or {}
  if is_new_object then
    create_object_command(object)
  end
  M._registry[object][action] = {
    fn = fn,
    desc = opts and opts.desc or "",
    complete = opts and opts.complete,
  }
end

vim.api.nvim_create_user_command("Commands", function()
  local lines = {}
  local objects = vim.tbl_keys(M._registry)
  table.sort(objects)
  for _, object in ipairs(objects) do
    local actions = vim.tbl_keys(M._registry[object])
    table.sort(actions)
    for _, action in ipairs(actions) do
      local entry = M._registry[object][action]
      local label = pascal_case(object) .. " " .. action
      table.insert(lines, { { label, "Title" }, { "  " .. entry.desc, "Comment" } })
    end
  end
  if #lines == 0 then
    vim.api.nvim_echo({ { "Aucune commande enregistrée.", "WarningMsg" } }, true, {})
    return
  end
  for _, chunks in ipairs(lines) do
    vim.api.nvim_echo(chunks, true, {})
  end
end, {
  nargs = 0,
  desc = "Lister toutes les commandes object-action disponibles",
})

function M.setup()
  require("commands.buffer")
end

return M
