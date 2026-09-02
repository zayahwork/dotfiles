# treehouse

A pool of reusable worktrees. Install, and how an agent gets one.

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
