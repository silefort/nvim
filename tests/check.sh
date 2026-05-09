#!/usr/bin/env bash
# Validations automatisables de la config Neovim.
# Chaque feature ajoutera ici son critère de validation.
set -uo pipefail

ROOT="$(dirname "$0")/.."

PASS=0; FAIL=0; SKIP=0
FAILED_NAMES=()

nvim_run() {
  nvim --headless -u "$ROOT/init.lua" "$@" +'qa!' 2>&1
}

test_case() {
  local name="$1"; shift
  local output
  if output=$("$@" 2>&1); then
    printf '  ✓ %s\n' "$name"
    PASS=$((PASS + 1))
  else
    printf '  ✗ %s\n' "$name"
    printf '%s\n' "$output" | sed 's/^/      /'
    FAIL=$((FAIL + 1))
    FAILED_NAMES+=("$name")
  fi
}

test_skip() {
  printf '  ○ %s — %s\n' "$1" "$2"
  SKIP=$((SKIP + 1))
}

has_telescope() {
  nvim --headless -u "$ROOT/init.lua" \
    -c 'lua if not pcall(require, "telescope") then vim.cmd("cquit") end' \
    +'qa!' >/dev/null 2>&1
}

has_nvim_08() {
  nvim --headless -u NONE \
    -c 'lua if vim.fn.has("nvim-0.8") == 0 then vim.cmd("cquit") end' \
    +qa >/dev/null 2>&1
}

echo "Running tests..."
echo

test_case "démarrage headless" nvim_run
test_case "chargement du module commands" nvim_run -c 'lua require("commands")'
test_case ":Buffer enregistrée" nvim_run -c 'lua assert(vim.api.nvim_get_commands({}).Buffer, ":Buffer non enregistrée")'
test_case ":Commands enregistrée" nvim_run -c 'lua assert(vim.api.nvim_get_commands({}).Commands, ":Commands non enregistrée")'
test_case "registre buffer/save et buffer/close" nvim_run -c 'lua local r = require("commands")._registry; assert(r.buffer and r.buffer.save and r.buffer.close, "registre incomplet")'
test_case "action inconnue ne crashe pas" nvim_run -c 'Buffer inexistante'
test_case ":File enregistrée" nvim_run -c 'lua assert(vim.api.nvim_get_commands({}).File, ":File non enregistrée")'
test_case ":String enregistrée" nvim_run -c 'lua assert(vim.api.nvim_get_commands({}).String, ":String non enregistrée")'
test_case "registre file/search, file/list et string/search" nvim_run -c 'lua local r = require("commands")._registry; assert(r.file and r.file.search and r.file.list, "registre file incomplet"); assert(r.string and r.string.search, "registre string incomplet")'
test_case ":File list sans argument ne crashe pas" nvim_run -c 'File list'
test_case ":File list filtre inconnu ne crashe pas" nvim_run -c 'File list foobar'
test_case "wildcharm = <Tab>" nvim_run -c 'lua assert(vim.o.wildcharm == 9, "wildcharm doit valoir 9 (Tab), reçu " .. tostring(vim.o.wildcharm))'
test_case "<Tab> mappé en cmdline" nvim_run -c 'lua assert(vim.fn.maparg("<Tab>", "c") ~= "", "<Tab> non mappé en cmdline")'

if has_telescope; then
  test_case ":Commands ouvre le picker Telescope" nvim_run -c 'lua local ok, err = pcall(vim.cmd, "silent! Commands"); assert(ok, "Commands a échoué : " .. tostring(err))'
  test_case ":File search ouvre le picker Telescope" nvim_run -c 'lua local ok, err = pcall(vim.cmd, "silent! File search"); assert(ok, ":File search a échoué : " .. tostring(err))'
  test_case ":String search ouvre le picker Telescope" nvim_run -c 'lua local ok, err = pcall(vim.cmd, "silent! String search"); assert(ok, ":String search a échoué : " .. tostring(err))'
  test_case ":File list recent ouvre le picker Telescope" nvim_run -c 'lua local ok, err = pcall(vim.cmd, "silent! File list recent"); assert(ok, ":File list recent a échoué : " .. tostring(err))'
else
  test_skip ":Commands ouvre le picker Telescope" "telescope non installé (lance :Lazy install)"
  test_skip ":File search ouvre le picker Telescope" "telescope non installé (lance :Lazy install)"
  test_skip ":String search ouvre le picker Telescope" "telescope non installé (lance :Lazy install)"
  test_skip ":File list recent ouvre le picker Telescope" "telescope non installé (lance :Lazy install)"
fi

if has_nvim_08; then
  test_case ":Lazy enregistrée" nvim_run -c 'lua assert(vim.api.nvim_get_commands({}).Lazy, ":Lazy non enregistrée")'
else
  test_skip ":Lazy enregistrée" "nvim < 0.8.0"
fi

echo
TOTAL=$((PASS + FAIL + SKIP))
printf 'Tests: %d passed, %d failed, %d skipped (%d total)\n' "$PASS" "$FAIL" "$SKIP" "$TOTAL"

if [ "$FAIL" -gt 0 ]; then
  printf '\nFailed:\n'
  for name in "${FAILED_NAMES[@]}"; do
    printf '  - %s\n' "$name"
  done
  exit 1
fi
