# Neovim Config — Agent Guide

## Objectif

Ce repo contient une configuration Neovim personnalisée, construite progressivement en mode TDD : on ajoute une feature à la fois, on la valide, on passe à la suivante.

Il existe deux bases parallèles :

| Branche | Base | Description |
|---------|------|-------------|
| `main` | Vanilla | lazy.nvim brut + plugins sélectionnés à la main, sans distribution |
| `lazyvim` | LazyVim | Fondée sur la distribution [LazyVim](https://github.com/LazyVim/LazyVim) (lazy.nvim + sensible defaults + plugin préconfigurés) |

**Cette branche (`lazyvim`) repart de zéro sur la base LazyVim.** La config vanilla de `main` n'est pas portée ici.

## Approche de développement

**Cycle de travail :**
1. L'utilisateur exprime une feature ou un comportement souhaité
2. On définit ensemble comment la tester/valider (comportement attendu, commande de vérification)
3. On implémente la feature dans la config
4. On valide que ça marche
5. On commit et on passe à la suite

**Principes :**
- Chaque feature est atomique et testable indépendamment
- Pas d'abstraction prématurée — on résout le besoin concret d'abord
- La config doit tourner proprement sans erreur au démarrage (`nvim --headless +qa` doit sortir avec code 0)
- Les plugins sont ajoutés uniquement quand ils servent un besoin réel et exprimé

## Structure cible

Structure LazyVim standard :

```
nvim/
├── init.lua              # Point d'entrée (importe lua/config/lazy.lua)
├── lua/
│   ├── config/           # Bootstrap et surcharges (lazy.lua, options.lua, keymaps.lua, autocmds.lua)
│   └── plugins/          # Overrides et ajouts de plugins (un fichier par plugin ou groupe)
├── AGENTS.md             # Ce fichier
└── tests/                # Scripts de validation
```

## Comment tester

Chaque feature doit avoir un critère de validation explicite. Exemples :

- **Option vim** : `nvim --headless -c 'lua assert(vim.o.number == true)' -c 'qa'` doit sortir sans erreur
- **Plugin chargé** : `nvim --headless -c 'lua require("plugin-name")' -c 'qa'` doit sortir avec code 0
- **Keymap défini** : `nvim --headless -c 'lua assert(vim.fn.maparg("<leader>ff", "n") ~= "")' -c 'qa'`
- **Test manuel** : comportement décrit explicitement (ex. "ouvrir un fichier .lua et vérifier la coloration syntaxique")

Le script `tests/check.sh` contiendra les validations automatisables.

## Conventions

- Lua uniquement (pas de vimscript)
- Plugin manager : **lazy.nvim**, via la distribution **LazyVim**
- Leader key : `<Space>`
- Un commit par feature validée
- Les messages de commit suivent les **Conventional Commits** (voir ci-dessous)
- Chaque nouvelle feature démarre sur une **branche dédiée issue de `lazyvim`**
- Chaque feature terminée se clôture par un `git push` — l'agent fournit la commande, l'utilisateur l'exécute lui-même

## Branches

Format : `<type>-<scope>-<description-avec-tirets>`

Même vocabulaire que les Conventional Commits, mais :
- Les espaces sont remplacés par des `-`
- Pas de parenthèses autour du scope
- Tout en minuscules

> **Note :** les branches de base (`main`, `lazyvim`) dérogent à ce format — ce sont des branches longue durée, pas des features. Les feature-branches issues de `lazyvim` suivent le format normal.

**Exemples :**
```
feat-keymaps-ajouter-leader-ff-telescope
feat-lsp-activer-inlay-hints
fix-treesitter-crash-fichiers-sans-parser
chore-plugins-mise-a-jour-lazy-nvim
refactor-core-separer-options-et-autocmds
docs-agents-documenter-conventions-branches
```

## Messages de commit — Conventional Commits

Format : `<type>(<scope optionnel>): <description en impératif>`

**Types utilisés dans ce repo :**
| Type | Quand l'utiliser |
|------|-----------------|
| `feat` | Nouvelle feature ou comportement visible |
| `fix` | Correction d'un bug ou d'un comportement cassé |
| `chore` | Maintenance sans impact fonctionnel (mise à jour de plugin, nettoyage) |
| `refactor` | Réorganisation du code sans changement de comportement |
| `docs` | Modification de documentation uniquement |
| `test` | Ajout ou modification de scripts de validation |

**Règle d'or :** la description doit compléter la phrase :
> "Si nous appliquons ce commit, alors nous allons **[description]**"

**Bons messages :**
```
feat(keymaps): ajouter <leader>ff pour ouvrir le file picker telescope
feat(lsp): activer les inlay hints pour Lua et TypeScript
fix(treesitter): éviter le crash sur les fichiers sans parser disponible
chore(plugins): mettre à jour lazy.nvim vers v11.x
refactor(core): séparer options.lua en options et autocmds
test: ajouter la vérification headless du bootstrap lazy.nvim
docs(agents): documenter les conventions de commit
```

**Mauvais messages :**
```
update config                          # pas de type, trop vague
feat: changed some stuff               # en anglais, pas d'impératif, trop vague
fix(lsp): correction du bug            # "du bug" ne dit rien
ajout telescope                        # pas de type
feat(plugins/telescope.lua): init      # scope = nom de fichier, pas de comportement
WIP                                    # jamais commiter du WIP
```

**Règles :**
- Description en français, en minuscules, sans point final
- Infinitif présent : "ajouter", "corriger", "activer" — pas "ajouté", "ajout de", "ajoute"
- Scope = domaine fonctionnel (`lsp`, `keymaps`, `ui`, `treesitter`…), pas un nom de fichier
- Corps du message (optionnel) pour expliquer le *pourquoi*, séparé par une ligne vide

## Features implémentées

| Feature | Branche | Description |
|---------|---------|-------------|
| Init lazyvim | `lazyvim` | Page blanche, harness de tests minimal, doc adaptée |
| Installer LazyVim | `lazyvim` | Bootstrap lazy.nvim + spec `LazyVim/LazyVim`, tests via `:Lazy! sync` |
| tmux-navigator | `feat-plugins-tmux-navigator-seamless-hjkl` | Navigation seamless nvim↔tmux via `<C-h/j/k/l>`, overrides des defaults LazyVim |
| tokyonight-day transparent | `feat-plugins-tmux-navigator-seamless-hjkl` | Bascule tokyonight en variante `day` + bg transparent pour laisser passer le bg terminal Solarized Light |

## Backlog / idées

- Choisir/configurer un colorscheme via `lua/plugins/colorscheme.lua`
- Activer des extras LazyVim (LSP par langage, AI, etc.)
