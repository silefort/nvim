# Neovim Config

Configuration Neovim personnalisée, construite feature par feature en mode TDD.
Lua uniquement. Plugin manager : lazy.nvim (pas encore installé).

## Structure

```
├── init.lua              # Point d'entrée
├── lua/
│   ├── commands/         # Langage de commandes object-action
│   ├── core/             # Options, keymaps, autocmds (à venir)
│   └── plugins/          # Un fichier par plugin (à venir)
└── tests/
    └── check.sh          # Validations headless automatisables
```

## Lancer les tests

```sh
bash tests/check.sh
```

Chaque check doit sortir avec code 0. Un `Error detected` en mode headless n'est pas
fatal si la ligne suivante affiche `OK` (cas normal pour `vim.notify(ERROR)`).

---

## Langage de commandes

La config expose un vocabulaire **objet-action** via les commandes utilisateur natives
de Neovim. Chaque objet devient une commande `:<Object>` avec complétion des verbes.

### Utilisation

```
:Buffer <Tab>        → close, save          (complétion des verbes)
:Buffer save         → sauvegarde le buffer courant
:Buffer close        → ferme le buffer courant
:Commands            → liste toutes les commandes enregistrées
```

`:Bu<Tab>` complète en `:Buffer` — c'est la complétion de nom de commande intégrée
à Neovim, gratuite dès qu'une commande utilisateur est enregistrée.

### Ajouter un objet

Créer `lua/commands/<objet>.lua` :

```lua
local cmd = require("commands")

cmd.register("pane", "close", function()
  vim.cmd("close")
end, { desc = "Fermer le panneau courant" })

cmd.register("pane", "split", function(direction)
  vim.cmd(direction == "vertical" and "vsplit" or "split")
end, {
  desc = "Ouvrir un nouveau panneau",
  complete = function(arglead, _)
    return vim.tbl_filter(function(s)
      return s:find(arglead, 1, true) == 1
    end, { "horizontal", "vertical" })
  end,
})
```

Puis déclarer le module dans `lua/commands/init.lua` → `setup()` :

```lua
function M.setup()
  require("commands.buffer")
  require("commands.pane")   -- ajouter ici
end
```

### API

**`commands.register(object, action, fn, opts)`**

| Paramètre | Type | Description |
|-----------|------|-------------|
| `object` | string | Nom de l'objet en minuscules (`"buffer"`, `"pane"`…). Crée `:<Object>` au premier appel. |
| `action` | string | Verbe en minuscules (`"save"`, `"close"`…). Devient le 1er argument de la commande. |
| `fn` | function | Exécutée avec les arguments suivant l'action (`opts.fargs[2..]`). |
| `opts.desc` | string | Description courte, affichée par `:Commands`. |
| `opts.complete` | function `(arglead, fargs) → string[]` | Complétion des arguments après l'action. Optionnelle. |

**`commands._registry`** — table interne `object → action → { fn, desc, complete }`,
exposée pour les tests headless uniquement.

### Keymaps (à venir)

Les fonctions enregistrées dans le registre seront réutilisées directement pour les
keymaps, sans dupliquer la logique :

```lua
-- exemple futur dans lua/core/keymaps.lua
local cmd = require("commands")
vim.keymap.set("n", "<leader>bs", function() cmd._registry.buffer.save.fn() end)
```

---

## Features implémentées

| Feature | Branche | Description |
|---------|---------|-------------|
| Init arborescence | `feat-init-arborescence-de-base` | Structure `lua/`, `tests/check.sh`, vérification headless |
| Langage de commandes | `feat-commands-langage-object-action` | Registre object-action, `:Buffer`, `:Commands` |

## Backlog

- `lua/core/options.lua` — options de base (numérotation, indentation…)
- `lua/core/keymaps.lua` — keymaps branchés sur le registre de commandes
- lazy.nvim bootstrap
