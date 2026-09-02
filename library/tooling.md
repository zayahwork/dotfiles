# tooling

The agent toolchain from <https://github.com/kunchenguid>, all six pinned repos, all
MIT. How each one is installed here and what it cost to get in.

## Contents

- treehouse v2.3.0, from their flake, with `doCheck = false` because their tests fail in the sandbox.
- An agent takes a treehouse with `get --lease`, never the bare subshell, which exits empty.
- no-mistakes v1.60.2, built by `nix/no-mistakes.nix`, since it is neither in nixpkgs nor a flake.
- gnhf 0.1.47 and lavish-axi, npm tools reached through npx, never `npm -g`.
- gnhf stops on a cap, on `--stop-when`, or on three failures, never because the objective is done.
- gnhf hides its run state by writing `.gnhf/runs/` into `.git/info/exclude`, which every worktree shares.
- firstmate is a cloned distro at `~/github/firstmate`, not a package.
- gh is authenticated as zayahwork with `gist`, `read:org`, `repo`. No `workflow` scope.
- axi is not installed at all. It is a spec, and it lives in the `agent-cli` skill.
- `no-mistakes axi run` says `passed` on an empty branch, having skipped every real step.
- `no-mistakes` exits 1 for any `error:`, not only for a failed run; 2 is bad usage.
- `no-mistakes init` needs an `origin` remote, and cannot overwrite our SKILL.md.

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

## An agent takes a treehouse with `get --lease`, never the bare subshell

**verified:** 2026-09-01, `treehouse get --lease --json --no-fetch` printed
`{"path":"/tmp/th-test/.treehouse/th-test-c49429/1/th-test","lease_id":"9bef1391074cc499832588efb0328b13"}`,
and `treehouse return <path>` put it back as `available`
**where:** the `treehouse` skill, and any agent that needs a tree of its own

Bare `treehouse` acquires a worktree and opens a subshell in it. Run with no terminal,
that subshell exits immediately and the tree is returned before any work happens, so an
agent following the subshell shape gets a worktree it never occupied. `--lease` acquires
durably instead: the absolute path on stdout, every banner on stderr, never handed to a
later `get` and never removed by `prune` until `treehouse return <path>`. Read a tree
somebody else holds with `treehouse enter --print-path <name>`, which leaves pool state
alone.

**Fix:** the `treehouse` skill now documents the lease as the agent path beside the
subshell, and its command list gained `update`, which v2.3.0 has and the skill omitted.

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

## gnhf stops on a cap, on `--stop-when`, or on three failures, never on the objective

**verified:** 2026-09-01, `gnhf --help` on 0.1.47 offers no completion flag other than
`--stop-when`, and `maxConsecutiveFailures: 3` is a hard coded default in its `dist/cli.mjs`
**where:** the `gnhf` skill, and any unattended run

Nothing in gnhf notices that an objective is finished, so an uncapped run hands the same
objective to a fresh iteration forever. A run ends on `--max-iterations`, on
`--max-tokens`, on an iteration reporting the `--stop-when` condition met, on three
consecutive failed iterations, or on a permanent agent error such as a low Claude credit
balance. A no-op iteration counts as a failure, which is the only way a run with nothing
left to do stops itself. Two refusals before any of that: `Working tree is not clean.
Commit or stash changes first.` and `Cannot combine --current-branch and --worktree.`

**Fix:** the `gnhf` skill said "until the objective is met or a cap stops it" and named
no stop condition. It now has a "What actually ends a run" section listing all five,
plus the two refusals.

---

## gnhf hides its run state in `.git/info/exclude`, not in `.gitignore`

**verified:** 2026-09-01, from a gnhf worktree, `git check-ignore -v .gnhf/runs` printed
`/home/pc/github/dotfiles/.git/info/exclude:7:.gnhf/runs/`
**where:** any repo gnhf has been run in, and every worktree of it

Prompt, notes, per-iteration jsonl and the run log live under `.gnhf/runs/<runId>/` in
the working directory, and gnhf keeps them out of the branch by appending to the repo's
exclude file rather than to a tracked `.gitignore`. The pattern is `.gnhf/runs/`, so
`git check-ignore .gnhf` exits 1 and the rule looks absent until you ask about the
`runs/` path itself. Worktrees share one exclude file through the common git dir, which
is why a run inside a worktree writes into the main checkout's `.git/info/exclude`.

---

## `no-mistakes axi run` returns `outcome: passed` on a branch with zero commits ahead

**verified:** 2026-09-01, in `/tmp/nmtest` on a `feat` branch at the same SHA as `main`,
`no-mistakes axi run --intent "..."` printed `outcome: passed`, exit 0, with
`review,skipped` `test,skipped` `document,skipped` `lint,skipped` `push,skipped`
`pr,skipped` `ci,skipped`
**where:** v1.60.2, the `no-mistakes` skill, any agent that reads the outcome word alone

Nothing refuses an empty branch, so the run completes having validated nothing and says
the same word it says after a real pass. A second false green sits beside it: when
`origin` is not a forge, `pr` and `ci` come back `skipped` and the outcome is still
`passed`, not `checks-passed`. The one-commit control run on the same repo did execute
review, test, document and lint for real and parked at a lint gate, so the skipping is
the empty diff and the non-forge remote, not a broken install.

**Fix:** the `no-mistakes` skill now requires at least one commit the default branch does
not have, tells the agent to check `git log --oneline <default>..HEAD`, and says to read
the `steps` table rather than the outcome word.

---

## `no-mistakes` exits 1 for every `error:`, not only for a failed run

**verified:** 2026-09-01, exit 1 from `no-mistakes axi` in an uninitialized repo, from
`axi run` on the default branch, from `axi run` with an uncommitted tree, from
`axi logs --step review` with no run, and from `axi sync --check` with no push binding
**where:** v1.60.2, any script or agent branching on the exit code

The skill said 1 meant "failed or cancelled final outcomes", which reads as though the
pipeline ran and lost. It does not: 1 is the code for any `error:` response as well, and
2 stays reserved for bad usage such as a missing `--action` or a missing `--intent`.

**Fix:** branch on whether the output carries an `outcome:` or an `error:`, never on the
code alone. The skill's exit-code line now says so.

---

## `no-mistakes init` needs an `origin` remote and cannot install its own SKILL.md here

**verified:** 2026-09-01, init in a remote-less repo printed
`init: no 'origin' remote in /tmp/nmnoremote`; init in a repo with one printed
`skill  skipped: open /nix/store/8am5ax4rn1hi4s7h54c9p3fl3fhpqs59-hm_skills/no-mistakes/SKILL.md: permission denied`
**where:** v1.60.2, `no-mistakes init`, and `~/.claude/skills/no-mistakes/`

init wants a remote because the pipeline pushes a branch and opens a pull request, so it
refuses before creating the gate. It also tries to write its own upstream SKILL.md over
ours on every init, and the read-only home-manager store path is the only reason our
house version survives. Treat that permission-denied line as the guard working, not as a
fault to fix.
