#!/usr/bin/env bash
# Copy the macOS WezTerm config into place.
#
#   bash ~/github/dotfiles/macos/apply.sh
#
# home-manager also deploys this file on Darwin. This script is the no-nix
# path, and the thing bootstrap-mac.sh runs so WezTerm works before a switch.
# Idempotent: copies only when the destination differs.
set -euo pipefail

here=$(CDPATH= cd "$(dirname "$0")" && pwd)
src="$here/wezterm.lua"
dest_dir="$HOME/.config/wezterm"
dest="$dest_dir/wezterm.lua"

if [ ! -f "$src" ]; then
  echo "macos/apply: no wezterm.lua next to this script" >&2
  exit 1
fi

mkdir -p "$dest_dir"

# home-manager deploys a store symlink on Darwin. Leave that alone. This
# helper is for the no-nix path, and for the first launch before a switch.
if [ -L "$dest" ]; then
  echo "wezterm.lua: already managed at $dest"
  exit 0
fi

if [ -f "$dest" ] && cmp -s "$src" "$dest"; then
  echo "wezterm.lua: already in place at $dest"
  exit 0
fi

if [ -f "$dest" ]; then
  cp "$dest" "$dest.bak"
  echo "wezterm.lua: kept previous copy at $dest.bak"
fi

cp "$src" "$dest"
echo "wezterm.lua: copied to $dest"
