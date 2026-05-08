#!/usr/bin/env bash
# Validations automatisables de la config Neovim.
# Chaque feature ajoutera ici son critère de validation.
set -euo pipefail

ROOT="$(dirname "$0")/.."

run() {
  nvim --headless -u "$ROOT/init.lua" "$@" +qa 2>&1
}

# La config doit démarrer proprement en mode headless.
echo "Vérification du démarrage headless..."
run
echo "OK"

# Le module commands se charge sans erreur.
echo "Vérification du chargement de commands..."
run -c 'lua require("commands")'
echo "OK"

# :Buffer est enregistrée.
echo "Vérification de :Buffer..."
run -c 'lua assert(vim.api.nvim_get_commands({}).Buffer, ":Buffer non enregistrée")'
echo "OK"

# :Commands est enregistrée.
echo "Vérification de :Commands..."
run -c 'lua assert(vim.api.nvim_get_commands({}).Commands, ":Commands non enregistrée")'
echo "OK"

# Le registre contient buffer/save et buffer/close.
echo "Vérification du registre..."
run -c 'lua local r = require("commands")._registry; assert(r.buffer and r.buffer.save and r.buffer.close, "registre incomplet")'
echo "OK"

# Une action inconnue notifie sans faire planter Neovim.
echo "Vérification d'une action inconnue..."
run -c 'Buffer inexistante'
echo "OK"
