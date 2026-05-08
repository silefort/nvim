#!/usr/bin/env bash
# Validations automatisables de la config Neovim.
# Chaque feature ajoutera ici son critère de validation.
set -euo pipefail

# La config doit démarrer proprement en mode headless.
echo "Vérification du démarrage headless..."
nvim --headless -u "$(dirname "$0")/../init.lua" +qa
echo "OK"
