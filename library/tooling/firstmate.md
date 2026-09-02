# firstmate

The agent distro. Not a package, and it does not run where you think.

## firstmate is a cloned repo, not an install

**verified:** 2026-09-01, cloned to `~/github/firstmate` at `1c41029`, 37M
**where:** outside this repo, because it is not part of the machine config

There is nothing to install. The repo is the distro: `AGENTS.md`, skills and helper
scripts that turn a general purpose agent into a first mate when you launch a harness
inside the directory. `cd ~/github/firstmate && claude` is the whole launch.

It is cloned, not adopted. Running it hands the method over to firstmate's own
lifecycle, which is not the same as the one in `method/`.

---

---

## firstmate picks the experimental herdr backend here, not the documented tmux

**verified:** 2026-09-01, `HERDR_ENV` is set in every pane of this machine's shell, and
`fm_backend_detect` reads it before it reaches any default
**where:** every firstmate session started from a herdr pane

tmux is firstmate's hard default and the only backend its own docs do not mark
experimental. herdr, zellij, cmux and Orca all carry that label. Our shell runs inside
herdr, so detection selects herdr before a default is ever considered. Only `TMUX` being
set outranks it.

**Fix:** `--backend tmux` on the invocation, or write `tmux` into
`$FM_HOME/config/backend`, to get the backend its documentation was written against.
Take the herdr backend on purpose, knowing it is the experimental one, or not at all.
