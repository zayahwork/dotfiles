# Lessons

What already went wrong, so it does not have to go wrong twice.

This file is the whole index. Read the table, open a file only when its line matches
what you are actually doing, and never read the directory whole. One hit, one file.
If nothing on the table matches, nothing here is going to help. Move on.

| File | What is in it |
| --- | --- |
| `terminal.md` | herdr, WezTerm and the Windows key layer. Chords that never arrive, panes that start wrong. |
| `nix.md` | Nix, home-manager and WSL. What a store symlink cannot own, switches that look fine and are not. |
| `agents.md` | Claude, Codex, cursor-agent. Their config files, their skills, the way they read this repo. |

---

## Writing one

Write an entry when something cost real time and the next person would hit it the same
way. Not for a typo, not for a thing you guessed at and never confirmed.

Append it to the file it belongs in. Start a new file only when the thing genuinely has
no home on the table, and when you do, add its row here with a description a stranger
can match against in one read. The description is the whole interface: if it is vague,
the file is invisible.

The format, kept short on purpose:

```markdown
## <the thing that goes wrong, said plainly>

**hit:** 2026-09-01
**where:** the file, tool or command it happens in

What happened, and what it looked like. Include the real error text if it is short.

**Why:** the actual cause, once known.
**Fix:** what worked. Not what should work.
```

Two rules about the contents. **An entry is a thing that happened**, verified on this
machine, not a thing you expect to happen. If the cause was never confirmed, say
UNCONFIRMED in the Why line rather than writing a smooth guess. And **an entry that
turns out to be wrong gets deleted**, not left with a correction under it. A log nobody
trusts costs more than no log.
