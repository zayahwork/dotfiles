# media

The drop. Finished media only, ready to grab and post.

Something arrives here when it is **done and we are satisfied with it**. Nothing is
worked on here, nothing is drafted here, and nothing sits here waiting to be revised.
The one question a file has to answer to belong on this branch is: would I post this
right now, as it is?

That is the whole rule. It is what makes the branch useful: anything you find here can
go straight out without being opened and checked first.

## Where the work happens

Somewhere else. A scratch folder, the editor's own project directory, wherever suits
the tool. Working files, project files, raw captures and half-finished cuts do not
belong on this branch, because the moment they are here the rule above stops being
true and every file needs opening to find out which kind it is.

Export the finished thing, drop it here, commit.

## This branch is not part of the flow

`development -> staging -> main` is for the config. This branch is not a fourth stage
in it and never merges into any of them.

It is an **orphan branch**: its own root commit, no history in common with the config.
That is deliberate. Media is large and binary, and anything committed to a branch stays
in that branch's history forever. Keeping it on its own root means a clone of the config
branches never has to carry a single video file.

There is nothing to promote. Commit to `media`, push `media`, done.

    git checkout media          # only media, no nix config in sight
    git checkout development    # back to the config

The histories are unrelated, so switching swaps the whole working tree. Commit before
you switch.

## Layout

| Path | What goes in it |
| --- | --- |
| `x/` | Finished media for X. |

One folder per platform. Add a sibling when we start posting somewhere new.

Name a file so it is obvious what it is without opening it. The date it is for, then
what it shows:

    x/2026-09-01-herdr-agent-tabs.mp4
    x/2026-09-01-nix-rebuild.png

## Two things to know before committing a large file

- **GitHub refuses any file over 100 MB** and warns over 50 MB. A refused push fails
  after the upload, not before.
- **Deleting a large file later does not shrink the repo.** It stays in history. The
  only real fix is rewriting the branch, so it is worth checking the size before the
  commit rather than after.

Check first:

    du -h path/to/file
