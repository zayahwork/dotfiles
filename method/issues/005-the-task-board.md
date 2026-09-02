# A viewer looks at the overlay and understands what is being built today and how far along it is

**id:** 005
**type:** human
**blocked-by:** 001
**slice:** vertical
**stories:** 6
**from:** prd-stream-agent.md

---

## What done looks like

A browser source on the canvas shows a topic in a few words, today's tasks, the
schedule, and a percent bar. It changes when an issue changes state. Nothing that looks
like a file path, a commit hash, a branch or an issue id ever appears on it.

## Modules touched

`board`, `dataset`, `command`

## The failing test to write first

`test_board_never_leaks_developer_vocabulary`. Feed the renderer a board state whose
issue titles contain a path, a SHA and a branch name, and assert none of them appear in
the rendered output. It fails before implementation because there is no renderer. This is
the check that keeps the board for the audience rather than for us.

## Feedback loop

    python -m stream.board --serve
    open the local page, move an issue's state, watch it change
    pytest stream/tests/test_board.py -v

Passing prints the rendered board with zero matches for the leak patterns.

## Not this issue

A person adds the browser source to the OBS scene once, by hand. Decision 2 means the
agent never touches scene composition, and that has no exception for this feature.
Placement and the percent bar's definition are open questions in the PRD and must be
answered before this is worked.
