# installing

How these tools get onto the machine at all: npx, nix, and gh auth.

## npm tools run through npx, never npm -g

**verified:** 2026-09-01, `gnhf --version` prints `0.1.47`, `npx -y lavish-axi --help`
returns 7 playbooks
**where:** `home/bin/gnhf`, and the `lavish` skill

A nix `nodejs` has a read-only global prefix, so `npm install -g` has nowhere to write,
and pointing it at a writable prefix would put a mutable install outside this repo where
nothing tracks it.

**Fix:** a one line wrapper that execs `npx -y <pkg>@<version>`. `gnhf` is pinned in the
wrapper so an upstream release cannot change what a switch installs. `lavish-axi` is
deliberately not pinned: its skill is a stub that defers to the running CLI, and pinning
would defeat the thing that keeps it from going stale.

### Held back

**Pi must install under ~/.local because nixpkgs nodejs makes npm -g unwritable.**
n=1, 2026-09-08, official `pi.dev/install.sh` (1728 lines) plus `bootstrap-mac.sh`.
Rejected: the read-only prefix is already this subject's fact; the Pi `~/.local` prefix
was not measured as a failure on this machine, and n is not five.

---

---

## gh is authenticated, with three of the four scopes

**verified:** 2026-09-01, `gh auth status` reports account zayahwork, a `gho_` token,
scopes `gist`, `read:org`, `repo`
**where:** `no-mistakes init`, and any firstmate session

Both open pull requests through the GitHub CLI, so both were dead until this was done.

`gh auth login` is interactive: it prints a device code and waits on
<https://github.com/login/device>, so no agent can finish it. A person runs it, and the
`!` prefix in a Claude Code prompt is the way to run it where the output is visible.
Handing the URL to `explorer.exe` opens it on the Windows side.

**Missing:** the `workflow` scope, which is only needed to push a change to a file under
`.github/workflows`. Add it with `gh auth refresh -s workflow` if a pipeline ever needs
to, rather than pre-granting it.

---
