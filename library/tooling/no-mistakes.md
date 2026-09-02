# no-mistakes

The push gate. How it is built here, and the ways a green result can lie.

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
