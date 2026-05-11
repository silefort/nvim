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

echo "Setup : installation des plugins (premier run = clone réseau, peut être long)..."
nvim --headless -u "$ROOT/init.lua" "+Lazy! sync" +'qa!' 2>&1 | tail -5
echo

echo "Running tests..."
echo

test_case "démarrage headless" nvim_run
test_case ":Lazy enregistrée" \
  nvim_run -c 'lua assert(vim.api.nvim_get_commands({}).Lazy, ":Lazy non enregistrée")'
test_case "lazyvim chargeable" \
  nvim_run -c 'lua assert(pcall(require, "lazyvim"), "require(\"lazyvim\") a échoué")'
test_case "lazyvim.config chargeable" \
  nvim_run -c 'lua assert(pcall(require, "lazyvim.config"), "require(\"lazyvim.config\") a échoué")'

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
