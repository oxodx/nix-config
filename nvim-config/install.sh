#!/usr/bin/env bash
# Installs this Neovim config for the current user on Linux or macOS.
# An existing config in ~/.config/nvim is moved aside, not deleted.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
dest="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

if ! command -v nvim >/dev/null 2>&1; then
  echo "Neovim is not installed. Install Neovim 0.11 or newer first: https://neovim.io"
  exit 1
fi

echo "Found: $(nvim --version | head -n1)"
for tool in git rg fd make cc; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing (recommended): $tool"
  fi
done

if [ -e "$dest" ]; then
  backup="$dest.bak-$(date +%Y%m%d-%H%M%S)"
  mv "$dest" "$backup"
  echo "Moved your existing config to $backup"
fi

mkdir -p "$dest"
cp -r "$here/init.lua" "$here/lua" "$here/custom-snippets" "$dest/"

echo "Installed to $dest"
echo "Open nvim: lazy.nvim installs the plugins on first start. Then run :Mason to check the servers."
