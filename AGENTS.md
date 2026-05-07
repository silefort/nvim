# Neovim Config — Agent Guide

## Objectif

Ce repo contient une configuration Neovim personnalisée, construite progressivement en mode TDD : on ajoute une feature à la fois, on la valide, on passe à la suivante.

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

```
nvim/
├── init.lua              # Point d'entrée principal
├── lua/
│   ├── core/             # Options de base, keymaps, autocmds
│   └── plugins/          # Un fichier par plugin (ou groupe cohérent)
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
- Plugin manager : **lazy.nvim**
- Leader key : `<Space>`
- Un commit par feature validée
- Les messages de commit suivent les **Conventional Commits** (voir ci-dessous)

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

_(vide pour l'instant — se remplit au fil des itérations)_

## Backlog / idées

_(à alimenter au fil de la conversation)_
