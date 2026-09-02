---
name: treehouse
description: Get an isolated git worktree instantly from a pool of pre-warmed ones, so several agents can work the same repo in parallel without clones, conflicts, or a cold dependency install each time. Use before starting parallel work, or when an agent needs a tree of its own.
---

# treehouse

A pool of reusable worktrees. Asking for one is instant because it already exists, with
its dependencies and build cache intact from the last time somebody used it. Returning
it puts it back in the pool rather than deleting it.

## Current guidance lives in the CLI

`treehouse --help`, and `treehouse <command> --help`, are the source of truth. The
commands are `get`, `enter`, `return`, `status`, `destroy`, `prune`, `init`, `update`.

## The shape of it

```sh
treehouse            # take one from the pool and drop into a subshell
exit                 # hand it back, lingering processes terminated
treehouse status     # what is in the pool and who has what
```

Run it from inside the repo you want a tree of. You land in a subshell in the worktree,
do the work there, and `exit` returns it.

## An agent cannot use the subshell

That shape is for a person at a terminal. An agent has no subshell to land in, so it
uses the lease instead:

```sh
treehouse get --lease --lease-holder <who>   # prints the absolute path, nothing else
treehouse return <path>                      # release it
```

`--json` on the lease adds the lease id and metadata, all banners go to stderr, and a
leased worktree is never handed to a later `get` and never removed by `prune` until it
is returned. `treehouse enter --print-path <name>` prints the path of a worktree
somebody else already has, without touching pool state.

## Why it matters here

Each agent gets its own tree, so two agents on one repo never step on each other. That
is what makes parallel work safe rather than merely possible.

`corp-layout` already builds a herdr workspace per worktree, and herdr binds
`prefix+shift+g` for a new one. Those make a worktree; treehouse keeps a pool of them
warm. Reach for treehouse when the repo has an install step worth not paying twice, and
for the existing tools when it does not.

## One thing that bit us

Their flake at `v2.3.0` does not build without `doCheck = false`, because their Go tests
assert on no-mistakes CI gate output and the nix sandbox has no remote and no pull
request. That override is in `home.nix` and the detail is in `library/tooling/treehouse.md`. If a
version bump fails a switch, look there first.
