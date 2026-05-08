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

local function commands_picker()
  local entries = {}
  for object, actions in pairs(M._registry) do
    for action, entry in pairs(actions) do
      table.insert(entries, {
        object = object,
        action = action,
        label  = pascal_case(object) .. " " .. action,
        desc   = entry.desc or "",
      })
    end
  end

  if #entries == 0 then
    vim.notify("Aucune commande enregistrée.", vim.log.levels.WARN)
    return
  end

  table.sort(entries, function(a, b) return a.label < b.label end)

  local ok = pcall(require, "telescope.pickers")
  if not ok then
    vim.notify("Telescope n'est pas chargé. Lance :Lazy install.", vim.log.levels.ERROR)
    return
  end

  local pickers      = require("telescope.pickers")
  local finders      = require("telescope.finders")
  local conf         = require("telescope.config").values
  local actions      = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = "Commands",
    finder = finders.new_table({
      results = entries,
      entry_maker = function(e)
        return {
          value   = e,
          display = string.format("%-24s  %s", e.label, e.desc),
          ordinal = e.label .. " " .. e.desc,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local sel = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if sel then
          vim.api.nvim_input(":" .. sel.value.label .. " ")
        end
      end)
      return true
    end,
  }):find()
end

vim.api.nvim_create_user_command("Commands", function()
  commands_picker()
end, {
  nargs = 0,
  desc = "Ouvrir le picker Telescope des commandes object-action",
})

function M.setup()
  require("commands.buffer")
end

return M
