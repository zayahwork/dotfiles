# tooling

The agent toolchain from <https://github.com/kunchenguid>, all six pinned repos, all
MIT. Split into a file per tool, because the single file went past the 150 line mark in
`../INDEX.md` at which a topic earns a directory.

| File | What is in it |
| --- | --- |
| [`installing.md`](installing.md) | How any of it gets onto the machine: npx over `npm -g`, why, and the state of `gh auth`. |
| [`treehouse.md`](treehouse.md) | The worktree pool. Its flake does not build without an override, and an agent must use `get --lease`. |
| [`no-mistakes.md`](no-mistakes.md) | The push gate. Built here from source, and three ways a green `passed` can mean nothing ran. |
| [`gnhf.md`](gnhf.md) | The autonomous loop. What actually ends a run, where its state hides, and how `goodnight` lost every objective but its last word. |
| [`firstmate.md`](firstmate.md) | The agent distro. Cloned rather than installed, and it picks the experimental backend here. |
| [`gh-axi.md`](gh-axi.md) | The GitHub wrapper. Pinned at 0.1.35, and its no-argument dashboard reports `0 open` when auth is missing. |

**axi** itself is still a spec with nothing to install: the ten principles live in the
`agent-cli` skill and the decision to adopt them is in `../repo.md`. Its catalog does
ship tools, though, and `gh-axi` is the first one we took, which is why it has a file
above.
