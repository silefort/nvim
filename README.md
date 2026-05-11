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

_(branche fraîche — aucune feature encore)_

## Backlog

- Installer LazyVim (clone du starter ou import de `LazyVim/LazyVim` via spec lazy.nvim)
