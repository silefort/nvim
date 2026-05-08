# Neovim Config

Configuration Neovim personnalisée, construite feature par feature en mode TDD.
Lua uniquement. Plugin manager : lazy.nvim.

## Structure

```
├── init.lua              # Point d'entrée + bootstrap lazy.nvim
├── lua/
│   ├── commands/         # Langage de commandes object-action
│   ├── core/             # Options, keymaps, autocmds (à venir)
│   └── plugins/          # Un fichier par plugin lazy (à venir)
└── tests/
    └── check.sh          # Validations headless automatisables
```

## Prérequis

- Neovim >= 0.8.0
- Git (pour le clone automatique de lazy.nvim au premier lancement)

## Premier lancement

Le bootstrap dans `init.lua` clone lazy.nvim automatiquement si absent :

```sh
nvim   # clone lazy.nvim, puis ouvre normalement
```

## Lancer les tests

```sh
bash tests/check.sh
```

Chaque check doit sortir avec code 0. Un `Error detected` en mode headless n'est pas
fatal si la ligne suivante affiche `OK` (cas normal pour `vim.notify`). Les checks
marqués `IGNORÉ` signalent une dépendance non satisfaite (ex. nvim < 0.8.0).

---

## Langage de commandes

La config expose un vocabulaire **objet-action** via les commandes utilisateur natives
de Neovim. Chaque objet devient une commande `:<Object>` avec complétion des verbes.

### Utilisation

```
:Buffer <Tab>        → close, reload, save  (complétion des verbes)
:Buffer save         → sauvegarde le buffer courant
:Buffer close        → ferme le buffer courant
:Buffer reload       → recharge le buffer depuis le disque (edit!)
:File search         → chercher un fichier par nom (telescope find_files)
:File list recent    → lister les fichiers récemment édités (telescope oldfiles)
:File list <Tab>     → complète : recent
:String search       → chercher une chaîne dans le projet (telescope live_grep)
:Commands            → ouvre un picker Telescope (filtrage live, <Enter> préremplit la cmdline)
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
| Bootstrap lazy.nvim  | `feat-plugins-bootstrap-lazy-nvim`   | Clone + setup lazy.nvim, `:Lazy` disponible |
| Picker `:Commands`   | `feat-commands-picker-telescope`     | `:Commands` ouvre un picker Telescope, `<Enter>` préremplit la cmdline |
| Buffer reload        | `feat-commands-buffer-reload`        | `:Buffer reload` recharge le buffer courant depuis le disque (`edit!`) |
| Objets `:File` et `:String` | `feat-commands-ajouter-objets-file-et-string` | `:File search`, `:File list recent`, `:String search` via Telescope |

## Backlog

- `lua/core/options.lua` — options de base (numérotation, indentation…)
- `lua/core/keymaps.lua` — keymaps de navigation fichier (`<leader>f*`) branchés sur le registre (`:File search`, `:String search`, `:File list recent`)
- Oil.nvim — explorateur de fichiers façon buffer (rename/move via édition de texte)
