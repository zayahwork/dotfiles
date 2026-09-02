#!/usr/bin/env bash
# Stand this repo up on a Linux side that has never run it.
#
#   bash ~/github/dotfiles/bootstrap.sh
#
# Idempotent. Every step checks before it acts, so running it again on a machine
# that is already set up changes nothing and still prints what it found.
#
# What it will not do: type your password, and log you into Claude. Both are
# yours. It tells you the exact commands at the end.
set -euo pipefail

repo="${1:-$HOME/github/dotfiles}"
user="$(id -un)"
remote="https://github.com/zayahwork/dotfiles.git"

say()  { printf '\n== %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

say "machine"
echo "user: $user"
echo "repo: $repo"

# ------------------------------------------------------------------- nix --
# Determinate's installer puts nix here and only a login shell knows about it.
# This script is run with bash from anywhere, so find it either way.
if ! have nix && [ -x /nix/var/nix/profiles/default/bin/nix ]; then
  export PATH="/nix/var/nix/profiles/default/bin:$PATH"
fi

if ! have nix; then
  cat >&2 <<'EOF'
bootstrap: nix is not installed, and nothing here works without it.

    curl -fsSL https://install.determinate.systems/nix | sh -s -- install

Open a new shell afterwards, then run this script again.
EOF
  exit 1
fi
echo "nix: $(nix --version)"

# ------------------------------------------------------------------- git --
say "git"
gcm='/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe'
if [ -x "$gcm" ]; then
  # Borrow the Windows credential store rather than logging in again on the
  # Linux side. A private clone then needs no token and no second account.
  git config --global credential.helper \
    '/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe'
  echo "credential helper: Windows Git Credential Manager"
else
  echo "no Windows Git Credential Manager found; a private clone will prompt" >&2
fi

git config --global user.name  "zayahwork"
git config --global user.email "zayahwork@gmail.com"
git config --global init.defaultBranch main
git config --global pull.rebase true
echo "identity: $(git config --global user.name) <$(git config --global user.email)>"

# ------------------------------------------------------------------ repo --
say "repo"
if [ -d "$repo/.git" ]; then
  echo "already cloned"
else
  mkdir -p "$(dirname "$repo")"
  git clone "$remote" "$repo"
fi
cd "$repo"
echo "branch: $(git branch --show-current)"

# -------------------------------------------------- an entry for this box --
# home-manager refuses to activate when home.username disagrees with whoever is
# running it, so a machine with a new user needs its own line in flake.nix.
say "machine entry in flake.nix"
marker="# BOOTSTRAP-INSERTS-MACHINES-HERE"

if grep -q "\"$user\" = mkHome \"$user\";" flake.nix; then
  echo "flake.nix already knows about $user"
elif grep -qF "$marker" flake.nix; then
  sed -i "s|$marker|\"$user\" = mkHome \"$user\";\n          $marker|" flake.nix
  echo "added: \"$user\" = mkHome \"$user\";"
  echo "left uncommitted on purpose - read it, then commit it."
else
  echo "bootstrap: no marker in flake.nix. Add this line by hand inside" >&2
  echo "homeConfigurations, then run again:" >&2
  echo "    \"$user\" = mkHome \"$user\";" >&2
  exit 1
fi

# ---------------------------------------------------------------- switch --
# A flake only sees what git tracks, so a line just written into flake.nix is
# visible (it is a tracked file) but a brand new file would not be. apply
# handles that; on the very first run apply does not exist yet.
say "home-manager switch"
if [ -x "$HOME/.local/bin/apply" ]; then
  "$HOME/.local/bin/apply" --flake ".#$user"
else
  echo "first run, going through nix run - this builds a lot and is slow"
  nix run home-manager/master -- switch --flake ".#$user"
fi

# ----------------------------------------------------------- login shell --
say "login shell"
zsh_path="$HOME/.nix-profile/bin/zsh"
current="$(getent passwd "$user" | cut -d: -f7)"

if [ "$current" = "$zsh_path" ]; then
  echo "already zsh"
elif [ ! -x "$zsh_path" ]; then
  echo "zsh not built yet at $zsh_path, skipping" >&2
else
  echo "currently $current, changing to zsh - sudo will ask for your password"
  # chsh warns "invalid shell" because a Nix zsh is never in /etc/shells. Root
  # applies it regardless, so check the result rather than trusting the message.
  sudo chsh -s "$zsh_path" "$user" || true
  now="$(getent passwd "$user" | cut -d: -f7)"
  if [ "$now" = "$zsh_path" ]; then
    echo "login shell is now zsh (takes effect in your next session)"
  else
    echo "could not change it, still $now - run this yourself:" >&2
    echo "    sudo chsh -s $zsh_path $user" >&2
  fi
fi

# ------------------------------------------------------------------ done --
say "what is left, and only you can do it"

if [ -f "$HOME/.claude/.credentials.json" ]; then
  echo "  claude: already logged in"
else
  echo "  claude: run 'claude' once and log in"
fi

cat <<'EOF'

Then close this window and open a new one, so the login shell takes effect.

  ctrl+alt+g   open the whole environment
  ctrl+alt+r   put Claude back in the repo on the last conversation
  ctrl+alt+/   the key list
EOF
