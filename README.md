# dotfiles

Declarative WSL Ubuntu environment, managed with Nix flakes and home-manager.
Nix installed 2026-09-01 with the Determinate Systems installer.

## Apply

    cd ~/github/dotfiles
    nix run home-manager/master -- switch --flake .#pc

After the first switch, use `apply` rather than home-manager directly:

    apply

It checks that git tracks every file the flake needs before switching, because a flake
cannot see an untracked file and fails with a stack trace that buries the real reason.
`apply --check` reports without changing anything, `apply --build` builds without
activating.

## Layout

- `flake.nix` pins nixpkgs and home-manager
- `home.nix` is the actual config: packages, git, zsh, starship
- `home/` is the source for anything deployed into `$HOME`
- `home/AGENTS.md` is the one rules file every agent reads
- `home/.claude/skills/` are the method skills, deployed to `~/.claude/skills/`
- `method/` is the build workflow: vocabulary, templates and an empty board.
  `method/README.md` explains it. Copy its pieces into a new project to start one.
- `library/` is what we know about this machine, kept as numbers, rules and failures.
  Three levels: `INDEX.md` lists topics, a topic file opens with a contents block of its
  subjects, and the subject holds the detail. An agent reads one line of each until the
  last, so a lookup costs three short reads and a miss costs one. It lives in the working
  tree rather than in `home/` because agents append to it, and anything deployed into
  `$HOME` is a read-only store symlink.

## Branches

Work moves in one direction and never skips a step.

    development  ->  staging  ->  main

- **development** is where we work and create new stuff. Every commit starts here.
  This is the branch you are on by default, and the only one anything is written
  directly to. Rough is fine here. That is the point of it.
- **staging** is where a thing goes once the rough draft is done and the reviser has
  finished with it. Then we let it run and see what goes wrong. Things are expected to
  break here, and finding out is the job this branch does.
- **main** is live. It only ever holds what has already run in staging without going
  wrong. Nothing arrives here to be tested.

The rule that makes it worth having: **never commit directly to `staging` or `main`.**
A change that appears on `main` without passing through the other two was never let
run anywhere, so nothing knows whether it works, and the branch stops meaning anything.

Which also means a promotion is a claim, not a step. Moving to `staging` claims the
draft is finished being revised. Moving to `main` claims it ran and nothing went
wrong. Do not make either claim to tidy up the branches.

Promote with a merge, not a reset or a cherry-pick, so the history says where a change
came from:

    git checkout staging     && git merge --no-ff development
    git checkout main        && git merge --no-ff staging

Then push the branch you promoted into. Go back to `development` to keep working.

### media, which is outside all of that

    media        (its own root, joins nothing)

`media` is the drop for finished media: a thing lands there once it is done and we are
satisfied with it, ready to grab and post. No drafts, no project files, no working
copies. It is an **orphan branch** with its own root commit and no history in common
with the three above, so it is not a fourth stage and never merges into one. Commit to
it, push it, done.

The reason it is separate: media is large and binary, and anything committed to a
branch stays in that branch's history forever. On its own root, a clone of the config
never has to carry a video file.

    git checkout media          # only media, no nix config in sight
    git checkout development    # back to the config

Because the histories are unrelated, switching swaps the whole working tree, so commit
before you switch. `media`'s own README has the layout and the file-size limits.
