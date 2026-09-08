#!/usr/bin/env bash
# Stand this repo up on a Mac that has never run it.
#
#   bash ~/github/dotfiles/bootstrap-mac.sh
#
# Same entry point as Linux: bootstrap.sh detects Darwin and hands off here.
#
# Idempotent. Every step checks before it acts. It will not type your password,
# log you into Pi, or log you into Claude. Those print as exact next steps.
set -euo pipefail

repo="${1:-$HOME/github/dotfiles}"
user="$(id -un)"
remote="https://github.com/zayahwork/dotfiles.git"
here=$(CDPATH= cd "$(dirname "$0")" && pwd)

say()  { printf '\n== %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# Insert a homeConfigurations line above the bootstrap marker. awk, not sed -i:
# BSD sed needs `sed -i ''` and GNU sed treats that as a backup suffix.
insert_flake_machine() {
  local file="$1"
  local entry="$2"
  local tmp
  tmp=$(mktemp)
  awk -v entry="$entry" '
    /# BOOTSTRAP-INSERTS-MACHINES-HERE/ {
      print "          " entry
    }
    { print }
  ' "$file" > "$tmp"
  mv "$tmp" "$file"
}

case "$(uname -m)" in
  arm64)  nix_system="aarch64-darwin" ;;
  x86_64) nix_system="x86_64-darwin" ;;
  *)
    echo "bootstrap-mac: unsupported arch $(uname -m). Need arm64 or x86_64." >&2
    exit 1
    ;;
esac

say "machine"
echo "user: $user"
echo "os: Darwin $(uname -m) -> $nix_system"
echo "repo: $repo"

# -------------------------------------------------------------- homebrew --
# Apple Silicon brew lives at /opt/homebrew. Intel at /usr/local. A fresh
# Mac has neither. The official installer asks for a password; if that is
# refused, stop with the exact command rather than carrying on broken.
say "homebrew"
if have brew; then
  echo "brew: $(brew --version | head -1)"
elif [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  echo "brew: $(brew --version | head -1) (from /opt/homebrew)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
  echo "brew: $(brew --version | head -1) (from /usr/local)"
else
  echo "installing Homebrew. It will ask for your password."
  if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    if [ -x /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
  if ! have brew; then
    cat >&2 <<'EOF'
bootstrap-mac: Homebrew is not installed, and the installer did not leave brew
on PATH. Run this yourself, then run this script again:

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

On Apple Silicon, then:

    eval "$(/opt/homebrew/bin/brew shellenv)"
EOF
    exit 1
  fi
  echo "brew: $(brew --version | head -1)"
fi

# Put brew on PATH for the rest of this script, even if shellenv was already
# run above. Harmless to run twice.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ------------------------------------------------------------------- nix --
# Determinate's installer puts nix here and only a login shell knows about it.
if ! have nix && [ -x /nix/var/nix/profiles/default/bin/nix ]; then
  export PATH="/nix/var/nix/profiles/default/bin:$PATH"
fi

say "nix"
if have nix; then
  echo "nix: $(nix --version)"
else
  cat <<'EOF'
Nix is not installed. Determinate's installer is the one this repo uses on
Linux too. It will ask for your password and then tell you to open a new
shell.

    curl -fsSL https://install.determinate.systems/nix | sh -s -- install

Running that now.
EOF
  if curl -fsSL https://install.determinate.systems/nix -o /tmp/determinate-nix-install.sh; then
    sh /tmp/determinate-nix-install.sh install || true
    rm -f /tmp/determinate-nix-install.sh
  else
    echo "could not download the Determinate installer" >&2
  fi
  if ! have nix && [ -x /nix/var/nix/profiles/default/bin/nix ]; then
    export PATH="/nix/var/nix/profiles/default/bin:$PATH"
  fi
  if ! have nix; then
    cat >&2 <<'EOF'
bootstrap-mac: nix is still not on PATH. Finish the installer yourself, open a
new terminal, then run this script again:

    curl -fsSL https://install.determinate.systems/nix | sh -s -- install
EOF
    exit 1
  fi
  echo "nix: $(nix --version)"
fi

# ------------------------------------------------------------------ rust --
# rustup, not a brew rustc. Local builds (herdr from source, anything cargo)
# should use the same toolchain a Mac developer already expects.
say "rust"
if have rustc && have cargo; then
  echo "rustc: $(rustc --version)"
  echo "cargo: $(cargo --version)"
else
  if [ -f "$HOME/.cargo/env" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.cargo/env"
  fi
  if have rustc && have cargo; then
    echo "rustc: $(rustc --version) (from ~/.cargo)"
  else
    echo "installing rustup"
    if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rustup-init.sh; then
      sh /tmp/rustup-init.sh -y --no-modify-path
      rm -f /tmp/rustup-init.sh
    else
      echo "could not reach rustup.rs" >&2
    fi
    if [ -f "$HOME/.cargo/env" ]; then
      # shellcheck disable=SC1091
      . "$HOME/.cargo/env"
    fi
    export PATH="$HOME/.cargo/bin:$PATH"
    if have rustc && have cargo; then
      echo "rustc: $(rustc --version)"
      echo "cargo: $(cargo --version)"
    else
      cat >&2 <<'EOF'
bootstrap-mac: rustc/cargo still missing. Run this yourself:

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
EOF
    fi
  fi
fi

# ------------------------------------------------------------------ node --
# Pi's official package is an npm install. A later nix nodejs has a read-only
# global prefix, so Pi has to land under ~/.local before that takes over PATH.
say "node"
if have node && have npm; then
  echo "node: $(node --version)"
  echo "npm: $(npm --version)"
else
  echo "installing node via Homebrew, needed for Pi"
  brew install node
  if have node && have npm; then
    echo "node: $(node --version)"
  else
    echo "bootstrap-mac: node/npm still missing. Run: brew install node" >&2
    exit 1
  fi
fi

# ----------------------------------------------------------------- herdr --
# home.nix also installs herdr from nixpkgs. Having a binary now means WezTerm
# can launch before the first switch finishes. Prefer brew, then the official
# installer, then cargo.
say "herdr"
if have herdr; then
  echo "already installed: $(herdr --version 2>/dev/null | head -1 || echo herdr)"
else
  if brew install herdr; then
    echo "installed via brew: $(herdr --version 2>/dev/null | head -1 || echo herdr)"
  else
    echo "brew formula missed; trying https://herdr.dev/install.sh"
    if curl -fsSL https://herdr.dev/install.sh -o /tmp/herdr-install.sh; then
      sh /tmp/herdr-install.sh || true
      rm -f /tmp/herdr-install.sh
    fi
  fi
  if ! have herdr && have cargo; then
    echo "installing herdr from crates.io"
    cargo install herdr || true
    export PATH="$HOME/.cargo/bin:$PATH"
  fi
  if have herdr; then
    echo "installed: $(herdr --version 2>/dev/null | head -1 || echo herdr)"
  else
    echo "herdr is not on PATH yet. home-manager will try nixpkgs#herdr." >&2
    echo "    brew install herdr" >&2
    echo "    curl -fsSL https://herdr.dev/install.sh | sh" >&2
  fi
fi

# -------------------------------------------------------------------- pi --
# Official package, same one https://pi.dev/install.sh installs. Prefix is
# ~/.local on purpose: nixpkgs nodejs makes `npm -g` unwritable, and that is
# the documented fallback the official installer already uses.
say "pi"
export PATH="$HOME/.local/bin:$PATH"
if have pi; then
  echo "already installed: $(pi --version 2>/dev/null | head -1 || command -v pi)"
else
  echo "installing @earendil-works/pi-coding-agent under ~/.local"
  mkdir -p "$HOME/.local/bin"
  if npm install -g --ignore-scripts --prefix "$HOME/.local" \
      @earendil-works/pi-coding-agent; then
    echo "installed: $(pi --version 2>/dev/null | head -1 || command -v pi)"
  else
    cat >&2 <<'EOF'
bootstrap-mac: Pi did not install. The official interactive installer is:

    curl -fsSL https://pi.dev/install.sh | sh

Or the same package this script uses:

    npm install -g --ignore-scripts --prefix "$HOME/.local" @earendil-works/pi-coding-agent
EOF
  fi
fi

# ------------------------------------------------------------------- git --
say "git"
git config --global credential.helper osxkeychain
git config --global user.name  "zayahwork"
git config --global user.email "zayahwork@gmail.com"
git config --global init.defaultBranch main
git config --global pull.rebase true
echo "identity: $(git config --global user.name) <$(git config --global user.email)>"
echo "credential helper: osxkeychain"
echo "a private clone will use the Mac keychain, or prompt"

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

# WezTerm config before the switch, so a window opened during the build still
# lands in herdr. apply.sh is a no-op once home-manager owns the file.
if [ -x "$repo/macos/apply.sh" ]; then
  bash "$repo/macos/apply.sh"
fi

# -------------------------------------------------- an entry for this box --
# home-manager refuses to activate when home.username disagrees with whoever is
# running it, so a machine with a new user needs its own line in flake.nix.
# Darwin also needs the right system, or the switch builds Linux binaries.
say "machine entry in flake.nix"
marker="# BOOTSTRAP-INSERTS-MACHINES-HERE"
entry="\"$user\" = mkHomeFor \"$nix_system\" \"$user\";"

if grep -q "\"$user\" = mkHomeFor \"$nix_system\" \"$user\";" flake.nix; then
  echo "flake.nix already knows about $user on $nix_system"
elif grep -q "\"$user\" = mkHome \"$user\";" flake.nix; then
  cat >&2 <<EOF
bootstrap-mac: flake.nix already has "$user" as a Linux (x86_64-linux) machine.
A switch here would build Linux binaries. Replace that line with:

    $entry

then run this script again.
EOF
  exit 1
elif grep -qF "$marker" flake.nix; then
  insert_flake_machine flake.nix "$entry"
  echo "added: $entry"
  echo "left uncommitted on purpose - read it, then commit it."
else
  echo "bootstrap-mac: no marker in flake.nix. Add this line by hand inside" >&2
  echo "homeConfigurations, then run again:" >&2
  echo "    $entry" >&2
  exit 1
fi

# ---------------------------------------------------------------- switch --
say "home-manager switch"
if [ -x "$HOME/.local/bin/apply" ]; then
  "$HOME/.local/bin/apply" --flake ".#$user"
else
  echo "first run, going through nix run - this builds a lot and is slow"
  nix run home-manager/master -- switch --flake ".#$user"
fi

# --------------------------------------------------------- cursor-agent --
# Same reason as Linux: home.nix aliases cr to cursor-agent, and nothing in
# nixpkgs provides it. The installer drops a binary in ~/.local/bin.
say "cursor-agent"
if have cursor-agent || [ -x "$HOME/.local/bin/cursor-agent" ]; then
  echo "already installed: $("$HOME/.local/bin/cursor-agent" --version 2>/dev/null | head -1)"
else
  echo "installing"
  if curl -fsSL https://cursor.com/install -o /tmp/cursor-install.sh; then
    bash /tmp/cursor-install.sh >/dev/null 2>&1 || true
    rm -f /tmp/cursor-install.sh
    if [ -x "$HOME/.local/bin/cursor-agent" ]; then
      echo "installed: $("$HOME/.local/bin/cursor-agent" --version 2>/dev/null | head -1)"
    else
      echo "install did not produce ~/.local/bin/cursor-agent; cr will not work" >&2
    fi
  else
    echo "could not reach cursor.com; cr will not work until you run:" >&2
    echo "    curl https://cursor.com/install -fsS | bash" >&2
  fi
fi

# ------------------------------------------------------------- wezterm --
say "wezterm"
if have wezterm || [ -d /Applications/WezTerm.app ]; then
  echo "already installed"
else
  echo "installing WezTerm via Homebrew cask"
  brew install --cask wezterm || echo "WezTerm cask missed. Install it from https://wezfurlong.org/wezterm/" >&2
fi

if [ -x "$here/macos/apply.sh" ]; then
  bash "$here/macos/apply.sh"
elif [ -x "$repo/macos/apply.sh" ]; then
  bash "$repo/macos/apply.sh"
fi

# ------------------------------------------------------------------ done --
say "what is left, and only you can do it"

if [ -f "$HOME/.pi/agent/auth.json" ]; then
  echo "  pi: already has auth.json"
else
  echo "  pi: run 'pi', then /login"
fi

if [ -f "$HOME/.claude/.credentials.json" ]; then
  echo "  claude: already logged in"
else
  echo "  claude: run 'claude' once and log in"
fi

cat <<'EOF'

  font: brew install --cask font-jetbrains-mono-nerd-font
        (or install JetBrains Mono Nerd Font from the site / Font Book)
  herdr: launch it from WezTerm or a terminal, not `brew services`.
         A launchd herdr inherits a tiny PATH and `pi` dies with no output.
  skills: after a new shell, `pi` then /skill:grill (or any method skill)

Close this window and open WezTerm so the login shell and PATH take effect.

  ctrl+alt+g   open the commit on GitHub
  ctrl+alt+r   put Claude back in the repo on the last conversation
  ctrl+alt+shift+p   a tab with Pi already in it
  ctrl+alt+i   the key list
EOF
