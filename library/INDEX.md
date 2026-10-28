# The library

Everything worth keeping. This machine and how we work on it, but also how we learn, how
we build, what made a build faster, and what a decision rejected on the way. Facts with
numbers in them, rules that turned out to matter, and what has already gone wrong.

Track everything. What we do not write down, we lose, and nothing can be measured from an
impression of how it went. The structure below exists so that writing all of it down
never makes reading any of it expensive.

As many levels as the system has grown, and you only ever read one line of each until
the last:

1. **This table.** The general topics.
2. **A topic's contents block.** Its subtopics or subjects, one line each.
3. **A subtopic**, when a topic got big enough to become a directory with its own
   `INDEX.md`. `tooling/` is one already.
4. **The subject itself.** Only the one you came for.

It does not stop at four. Every level costs one line to check, so going deeper is always
cheaper than leaving something out. When a file gets fat, split it: its groups become
files and its contents block becomes an `INDEX.md`. Never write less down to keep a file
small.

Open a topic only when its row matches a question that actually matters to the work in
front of you. If no row matches, nothing here helps, and reading further to be sure
costs more than it can return.

| Topic | What is in it |
| --- | --- |
| [`terminal.md`](terminal.md) | herdr, WezTerm, the Windows key layer. Which chords reach the terminal and which the OS eats, how panes start, the theme keys. |
| [`shell.md`](shell.md) | Shell and command execution walls. `exec_command` rejected one rm-style cleanup before execution, and zsh `path` clobbered `PATH` across two subjects; both held back. |
| [`nix.md`](nix.md) | Nix, home-manager, WSL. What a store symlink can and cannot own, what a switch actually rewrites, the activation order. |
| [`agents.md`](agents.md) | Claude, Codex, cursor-agent. Where each reads its rules, skills and subagent definitions from, the `library-admin` gate on writing to the library, the five-observation bar for a causal claim, and the standing yes on pushing to `development`. |
| [`repo.md`](repo.md) | This repo's own rules. Branch flow, what may be committed where, the numbers we hold ourselves to. |
| [`bootstrap.md`](bootstrap.md) | Standing this repo up on a new machine. The nine things that broke doing it on 2026-09-02: the hardcoded username, the 127 that closes WezTerm instantly, the Windows half home-manager never touches. |
| [`web.md`](web.md) | Fetching from the public internet. How to enumerate a YouTube channel's videos and read a video's title, views and full description with `curl`, and the grep that wrongly reports an empty page. |
| [`testing.md`](testing.md) | Test and command walls: cwd and source-path discovery, sandbox comparisons, plus held-back patch, packaging, Chrome reload/navigation, and Computer Use reliability failures. |
| [`npm.md`](npm.md) | npm package execution walls. `n8n@2.45.5` stayed in installation for 7:54:08, grew a 3.0G cache, and required KILL; cause held back at n=1. |
| [`stream/`](stream/INDEX.md) | The live stream and its numbers, eight subtopics: titles, descriptions, going live, the machine, the overlay, measuring, platforms, credentials. Largest file is 66 lines. |
| [`tooling/`](tooling/INDEX.md) | The kunchenguid agent toolchain: treehouse, no-mistakes, gnhf, firstmate. A file per tool. Versions, install, and what fought back. |

---

## Writing to it

Write generously. The three levels mean nobody reads past a row that does not match, so
the cost of an entry is not what it costs to read: it is one line in a table. Volume is
affordable here in a way it never is in an always-on prompt. That is the whole point of
the shape.

So the bar is not rarity. Write down anything with value past this session: a number, a
limit, a version, a rule, a measured result, a decision and what it rejected, or a
failure the next agent would walk straight into. When in doubt, write it.

What is still not worth an entry: a typo, and a thing you worked around without ever
understanding. The first has no value, and the second is a guess wearing the clothes of
a fact.

**Descriptions carry the content, not a gesture at it.** A row or a title that says
"notes on keybindings" is invisible - nobody can match it. Put the actual number, the
exact key, the version, the rule in the line. Under five sentences everywhere: the index
row is one, the subject title is one, the entry body is at most five.

The entry format:

```markdown
## <the fact or the failure, in one line, with the number in it>

**verified:** 2026-09-01, `the command or file that proves it`
**where:** the file, tool or command it applies to

At most five sentences. The number, the exact string, the version, the rule as a rule.
No hedging prose around it.

**Fix:** what worked. Failures only, and it is what worked, not what should have.
```

Add the subject's title to the contents block at the top of the topic file at the same
time. An entry nobody can find from the contents block is not in the library.

## Growing it

A new topic file when the thing has no home on the table. Add its row here, written so a
stranger could match against it in one read.

A topic file past roughly 150 lines becomes a directory: `tooling/INDEX.md` holding the
table, and one file per subject beside it. `tooling/` is the worked example, split at 213
lines. That is the third level, and it only appears when a topic has earned it. Until
then the contents block at the top of the file does the same job for free.

Splitting is maintenance, not a favour. A topic nobody splits stops being three cheap
reads and becomes one expensive one, which is the failure this whole shape exists to
avoid. If you notice a topic over the line, split it then, in that session.

## Two rules about the contents

**Only what happened, or what was measured.** Verified on this machine, with the real
output or the real error text. A number from memory is not a number. If a cause was
never confirmed, write UNCONFIRMED in the line rather than a smooth guess, because the
next agent will act on it.

**Wrong entries are deleted, not corrected in place.** A library nobody trusts costs
more than no library.
