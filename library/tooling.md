# tooling

The agent toolchain from <https://github.com/kunchenguid>, all six pinned repos, all
MIT. How each one is installed here and what it cost to get in.

## Contents

- treehouse v2.3.0, from their flake, with `doCheck = false` because their tests fail in the sandbox.
- no-mistakes v1.60.2, built by `nix/no-mistakes.nix`, since it is neither in nixpkgs nor a flake.
- gnhf 0.1.47 and lavish-axi, npm tools reached through npx, never `npm -g`.
- firstmate is a cloned distro at `~/github/firstmate`, not a package. Needs `gh auth login`.
- axi is not installed at all. It is a spec, and it lives in the `agent-cli` skill.

---

## treehouse builds only with its test suite switched off

**verified:** 2026-09-01, `treehouse --version` prints `v2.3.0` after the override
**where:** `home.nix`, the `treehouse` flake input pinned to `v2.3.0`

Their flake is the right way in, and at v2.3.0 it does not build. The Go test suite
asserts on no-mistakes CI gate output and fails in the nix sandbox, which has no git
remote and no pull request to attest to:

```
--- FAIL: TestNoMistakesGateDecisions/human_PR_with_empty_attestation_head_sha_fails
    gate output missing "not bound to the current pull request head"
```

**Why:** the check is about their release process, not about whether the binary works.
**Fix:** `.overrideAttrs (_: { doCheck = false; })` on their package. v2.3.0 was the
newest release on 2026-09-01, so there was nothing to upgrade to.

---

## no-mistakes is built here, and drops three of its four binaries

**verified:** 2026-09-01, `no-mistakes --version` prints `no-mistakes version v1.60.2`
**where:** `nix/no-mistakes.nix`

Not in nixpkgs, and it ships no flake, so the derivation is ours: `buildGoModule` over a
`fetchFromGitHub` pinned to `v1.60.2`. Bump the version and both hashes together.

Two things a plain build gets wrong. It installs `fakeagent`, `genskill` and
`recordfixture` alongside the tool, which are their test harness, so `subPackages` is
set to `cmd/no-mistakes` only. And the binary reports `dev (unknown)` unless the
`internal/buildinfo.Version` ldflag is stamped the way their Makefile does it. The two
telemetry ldflags are left unset on purpose; an empty TelemetryHost means nothing to
report to.

---

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

---

## firstmate is a cloned repo, not an install

**verified:** 2026-09-01, cloned to `~/github/firstmate` at `1c41029`, 37M
**where:** outside this repo, because it is not part of the machine config

There is nothing to install. The repo is the distro: `AGENTS.md`, skills and helper
scripts that turn a general purpose agent into a first mate when you launch a harness
inside the directory. `cd ~/github/firstmate && claude` is the whole launch.

It is cloned, not adopted. Running it hands the method over to firstmate's own
lifecycle, which is not the same as the one in `method/`.

---

## gh is not authenticated, and two of these need it

**verified:** 2026-09-01, `gh auth status` prints "You are not logged into any GitHub
hosts"
**where:** `no-mistakes init`, and any firstmate session

Both open pull requests through the GitHub CLI. `gh auth login` is interactive, so no
agent can do it. Until a person runs it, both are installed and neither can complete a
run.
