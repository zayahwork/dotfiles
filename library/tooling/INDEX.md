# tooling

The agent toolchain from <https://github.com/kunchenguid>, all six pinned repos, all
MIT. Split into a file per tool, because the single file went past the 150 line mark in
`../INDEX.md` at which a topic earns a directory.

| File | What is in it |
| --- | --- |
| `installing.md` | How any of it gets onto the machine: npx over `npm -g`, why, and the state of `gh auth`. |
| `treehouse.md` | The worktree pool. Its flake does not build without an override, and an agent must use `get --lease`. |
| `no-mistakes.md` | The push gate. Built here from source, and three ways a green `passed` can mean nothing ran. |
| `gnhf.md` | The autonomous loop. What actually ends a run, where its state hides, and how `goodnight` lost every objective but its last word. |
| `firstmate.md` | The agent distro. Cloned rather than installed, and it picks the experimental backend here. |

Not a tool and not here: **axi** is a spec with nothing to install. It lives in the
`agent-cli` skill, and the decision to adopt it is in `../repo.md`.
