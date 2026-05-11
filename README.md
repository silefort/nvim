# Neovim Config — branche `lazyvim`

Configuration Neovim personnalisée, construite feature par feature en mode TDD.
Lua uniquement. Fondée sur la distribution [LazyVim](https://github.com/LazyVim/LazyVim).

> Cette branche repart de zéro sur une base LazyVim.
> La config vanilla est sur `main`.

## Structure

```
├── init.lua              # Point d'entrée (à venir : importe lua/config/lazy.lua)
├── lua/
│   ├── config/           # Bootstrap, options, keymaps, autocmds (à venir)
│   └── plugins/          # Overrides et ajouts de plugins (à venir)
└── tests/
    └── check.sh          # Validations headless automatisables
```

## Prérequis

- Neovim >= 0.9.0
- Git (pour le clone automatique de lazy.nvim / LazyVim au premier lancement)

## Lancer les tests

```sh
bash tests/check.sh
```

## Features implémentées

| Feature | Branche | Description |
|---------|---------|-------------|
| Init lazyvim | `lazyvim` | Page blanche, harness de tests minimal, doc adaptée |
| Installer LazyVim | `lazyvim` | Bootstrap lazy.nvim + spec `LazyVim/LazyVim`, tests via `:Lazy! sync` |

## Backlog

- Ajouter des overrides dans `lua/config/options.lua`, `keymaps.lua`, `autocmds.lua`
- Choisir/configurer un colorscheme via `lua/plugins/colorscheme.lua`
- Activer des extras LazyVim (LSP, AI, etc.)
