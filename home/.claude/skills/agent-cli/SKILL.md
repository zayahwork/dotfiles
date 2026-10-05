---
name: agent-cli
description: The bar for any small command line tool we write, in home/bin or anywhere else, that an agent or a status bar will read the output of. Adapted from the AXI principles. Read it before writing or changing one, not after.
---

# agent-cli

Our scripts get read by agents and by status bars far more often than by a person at a
prompt. That changes what good output is. Every token the tool prints is a token the
agent pays for, and every ambiguous line is a round trip.

Adapted from **AXI**, ten design principles measured against real benchmarks:
<https://github.com/kunchenguid/axi>, MIT, read 2026-09-01.

## The checks

Run down these before you call a script finished.

1. **Say the least that answers.** Three or four fields per item, not everything you
   have. A caller who wants the rest can ask with a flag.
2. **Truncate long content, and say you did.** Print the size and give a `--full`
   escape hatch. Never dump an unbounded blob into an agent's context.
3. **Pre-compute the thing they would count.** If the caller would immediately have to
   total, group or filter your output, do it and print the total. That is one fewer
   round trip.
4. **Empty is a result, not silence.** Print `0 results` or the equivalent. A tool that
   exits 0 with no output is indistinguishable from a tool that failed to run.
5. **Errors are structured and exit non-zero.** Say what failed, where, and what to do
   instead. Fail loud on an unknown flag rather than ignoring it. Never prompt
   interactively: nothing is there to answer.
6. **Mutations are idempotent.** Running it twice does what running it once did.
7. **No arguments shows live data, not help.** The common case is the default.
8. **Suggest the next step.** After the output, name the one flag or command the caller
   is most likely to want next.
9. **`--help` exists and is short.** One screen, per subcommand, no ceremony.

## What we dropped from AXI and why

Their list is written for published npm CLIs. Three of the ten do not apply here and
pretending otherwise would be cargo cult:

- **TOON output format.** Worth ~40% over JSON at scale. Our scripts print a line or
  two, so the format is not where the tokens are. Revisit if one ever returns a list of
  any size.
- **Self-update and version commands.** Ours are deployed by `home-manager switch` from
  a git tree. There is nothing to self-update.
- **Install an opt-in session integration first.** That is packaging advice for a tool
  someone else installs.

## Where this applies

`home/bin/`, and anything we write that an agent shells out to. Not one-off scripts in
the scratchpad, and not code with a real test suite behind it, which has its own
standards.

Applying it to a script that already exists is a change like any other: make it, check
it by running it, and say in the commit which of the checks it now passes that it did
not before.
