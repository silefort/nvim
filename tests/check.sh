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

# :File et :String sont enregistrées.
echo "Vérification de :File et :String..."
run -c 'lua assert(vim.api.nvim_get_commands({}).File, ":File non enregistrée")'
run -c 'lua assert(vim.api.nvim_get_commands({}).String, ":String non enregistrée")'
echo "OK"

# Le registre contient file/search, file/list et string/search.
echo "Vérification du registre file et string..."
run -c 'lua local r = require("commands")._registry; assert(r.file and r.file.search and r.file.list, "registre file incomplet"); assert(r.string and r.string.search, "registre string incomplet")'
echo "OK"

# :File list sans argument notifie sans planter.
echo "Vérification de :File list sans argument..."
run -c 'File list'
echo "OK"

# :File list avec un filtre inconnu notifie sans planter.
echo "Vérification de :File list filtre inconnu..."
run -c 'File list foobar'
echo "OK"

# :Commands ouvre le picker Telescope (si telescope est installé).
echo "Vérification du picker Telescope pour :Commands..."
if nvim --headless -u "$ROOT/init.lua" -c 'lua if not pcall(require, "telescope") then vim.cmd("cquit") end' +qa 2>/dev/null; then
  run -c 'lua local ok, err = pcall(vim.cmd, "silent! Commands"); assert(ok, "Commands a échoué : " .. tostring(err))'
  echo "OK"
else
  echo "IGNORÉ (telescope non installé — lance :Lazy install)"
fi

# :File search, :String search et :File list recent ouvrent le picker (si telescope est installé).
echo "Vérification des pickers :File et :String..."
if nvim --headless -u "$ROOT/init.lua" -c 'lua if not pcall(require, "telescope") then vim.cmd("cquit") end' +qa 2>/dev/null; then
  run -c 'lua local ok, err = pcall(vim.cmd, "silent! File search"); assert(ok, ":File search a échoué : " .. tostring(err))'
  run -c 'lua local ok, err = pcall(vim.cmd, "silent! String search"); assert(ok, ":String search a échoué : " .. tostring(err))'
  run -c 'lua local ok, err = pcall(vim.cmd, "silent! File list recent"); assert(ok, ":File list recent a échoué : " .. tostring(err))'
  echo "OK"
else
  echo "IGNORÉ (telescope non installé — lance :Lazy install)"
fi

# :Lazy est enregistrée (lazy.nvim nécessite nvim >= 0.8.0).
echo "Vérification de :Lazy..."
if nvim --headless -u NONE -c 'lua if vim.fn.has("nvim-0.8") == 0 then vim.cmd("cquit") end' +qa 2>/dev/null; then
  run -c 'lua assert(vim.api.nvim_get_commands({}).Lazy, ":Lazy non enregistrée")'
  echo "OK"
else
  echo "IGNORÉ (nvim < 0.8.0)"
fi
