# media

Media for X and anything else we post. Images, video, audio, thumbnails, the source
files behind them.

## This branch is not part of the flow

`development -> staging -> main` is for the config. This branch is not a fourth stage
in it and never merges into any of them.

It is an **orphan branch**: its own root commit, no history in common with the code.
That is deliberate. Media is large and binary, and anything committed to a branch stays
in that branch's history forever. Keeping it on its own root means a clone of the config
branches never has to carry a single video file.

So there is nothing to promote here. Commit to `media`, push `media`, done.

## Working on it

    git checkout media          # only media, no nix config in sight
    git checkout development    # back to the config

Because the histories are unrelated, switching swaps the whole working tree. Commit
before you switch.

## Layout

| Path | What goes in it |
| --- | --- |
| `x/` | Anything posted to X. |
| `x/source/` | The editable original: the project file, the raw capture, the full-res export. |
| `x/out/` | The file actually uploaded, at the size and format X wants. |

Add a sibling folder per platform as we need one, with the same `source/` and `out/`
split. The split is the whole point: `out/` is disposable and can always be rebuilt
from `source/`, so if we ever need to shrink this branch, `out/` is what goes.

## Two things to know before committing a large file

- **GitHub refuses any file over 100 MB** and warns over 50 MB. A refused push fails
  after the upload, not before.
- **Deleting a large file later does not shrink the repo.** It stays in history. The
  only real fix is rewriting the branch, so it is worth checking the size before the
  commit rather than after.

Check first:

    du -h path/to/file
