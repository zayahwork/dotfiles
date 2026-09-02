# agents

Claude Code, Codex and cursor-agent, and how this repo reaches them.

## Contents

- [One source rules file, `home/AGENTS.md`, deployed to three paths. Never edit the copies.](#three-agents-one-rules-file-three-destinations)
- [Skills reach Claude only. Codex and cursor-agent see `AGENTS.md` and nothing else.](#skills-reach-claude-code-only)
- [`home/.claude/agents/` holds a file per subagent, and `library-admin` is the only thing that writes to `library/`.](#homeclaudeagents-holds-a-file-per-subagent-and-library-admin-is-the-only-thing-that-writes-to-library)
- [Five observations, one direction, bigger than the untouched drift, or the claim is not written.](#five-observations-one-direction-bigger-than-the-untouched-drift-or-the-claim-is-not-written)
- [Push to `development` on commit. Standing yes. Staging and main still need a person.](#push-to-development-on-commit-standing-yes-staging-and-main-still-need-a-person)
- [Playwright MCP is installed at user scope and needs a Claude restart before its tools appear.](#playwright-mcp-is-installed-at-user-scope-and-needs-a-claude-restart-before-its-tools-appear)
- [A logged-in page is not something an agent can reach on its own. The wall is the password, not the browser.](#a-logged-in-page-is-not-something-an-agent-can-reach-on-its-own-the-wall-is-the-password-not-the-browser)

---

## Three agents, one rules file, three destinations

**verified:** 2026-09-01, the three `AGENTS.md` deployments in `home.nix`. All three
targets symlink into the same store path.
**where:** `home/AGENTS.md`

The source is `home/AGENTS.md`. It lands at `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`
and `~/.config/opencode/AGENTS.md`, which are the same bytes on disk. Editing one of
those in place edits a store symlink and fails, and writing a second rules file for one
agent means the three drift.

**Fix:** edit `home/AGENTS.md`, then `home-manager switch`. Anything only sometimes
relevant does not belong in it at all: it goes in a skill behind a description, or in
`library/`.

---

## Skills reach Claude Code only

**verified:** 2026-09-01, `home.file.".claude/skills"` is the only skill deployment in
`home.nix`
**where:** `home/.claude/skills/`, deployed to `~/.claude/skills/`

Codex and cursor-agent read `AGENTS.md` and have no skill mechanism, so anything routed
purely through a skill description is invisible to two of the three agents.

**Fix:** when a thing has to reach all three, it needs a line in `home/AGENTS.md` as
well as the skill. Keep that line to a pointer, a path and when to follow it, because
`AGENTS.md` is sent on every single turn.

---

## `home/.claude/agents/` holds a file per subagent, and `library-admin` is the only thing that writes to `library/`

**verified:** 2026-09-02, `home.file.".claude/agents"` added to `home.nix`, `apply --check` clean
**where:** defining a subagent, or writing anything into `library/`

A definition in `home/.claude/agents/` is the only place a subagent is written down, so
an agent nobody can read is an agent nobody can fix. It deploys to `~/.claude/agents/`
exactly as skills do, with the same limit: Claude Code sees it, Codex and cursor-agent do
not. `library-admin` is the gate. Do not edit a library file directly; hand it the claim,
the rows behind it, and the topic it would live under.

**Why:** the agent proposing an entry already believes the claim, so an approver would
rubber stamp. The admin's job is to refute and its default verdict is reject.

## Five observations, one direction, bigger than the untouched drift, or the claim is not written

**verified:** 2026-09-02, the bar set for `library-admin` during the stream agent grill
**where:** any entry that claims one thing caused another

Five observations of the same class from five different subjects, all moving the same
direction, and the median effect larger than the largest swing over the same window in
the population nobody touched. Four is not five, and four-and-one is not four. A claim
that fails is not deleted: it goes to tier two of its subject under `Held back`, with the
reason and the numbers so far.

**Why:** things drift on their own, and the untouched population is a free control group
sitting right there. Without it an agent reports the drift as its own result, sincerely.

## Push to `development` on commit. Standing yes. Staging and main still need a person

**verified:** 2026-09-02, standing approval given by Zayah after commit links 404ed
**where:** every commit made in this repo

`commit-url` is how the work gets reviewed, and an unpushed commit makes that link a 404
even for the owner. So commit, `git push origin development`, then give the link.
Promoting to `staging` or `main` is unchanged and still needs a person to say yes.

**Why:** the 404 is not a permissions problem and not a broken link. The commit simply
was not on the remote yet, and the fix is to stop leaving it local.

---

## Playwright MCP is installed at user scope and needs a Claude restart before its tools appear

**verified:** 2026-09-02, `claude mcp add playwright -s user -- npx -y @playwright/mcp@latest` wrote to `/home/stuck/.claude.json`, and `claude mcp list` reports `playwright: ✔ Connected`
**where:** any task needing a real browser, and any session that just installed an MCP server

`claude mcp list` says Connected the moment it is added, but the tools do not exist in the
session that installed it: MCP servers are loaded at session start, so `ToolSearch` for
`mcp__playwright__*` returns nothing until Claude is restarted. **Its bundled chromium does not run on this machine.** `playwright install chromium
--with-deps` dies at `sudo: A terminal is required to authenticate`, and installing the
binary alone then fails at launch with `error while loading shared libraries:
libnspr4.so: cannot open shared object file`, exit 127. The host is Ubuntu 26.04 managed
by home-manager, so the missing libraries are an `apt` problem on a machine whose packages
come from nix, and `--with-deps` is the wrong tool for it either way. UNCONFIRMED whether
`pkgs.playwright-driver.browsers` plus `PLAYWRIGHT_BROWSERS_PATH` in `home.nix` fixes it;
that package has to version-match the npm `playwright`, which is its own trap.

**Fix:** add the server, then restart Claude before expecting the tools. For an actually
working browser today, use headless Edge on the Windows side - see `web.md` - which needs
no libraries and is not subject to the WSL egress allowlist either.

## A logged-in page is not something an agent can reach on its own. The wall is the password, not the browser

**verified:** 2026-09-02, four attempts on `reddit.com/prefs/apps` - no browser binary in WSL, headless Edge on Windows reached Reddit but as a fresh anonymous profile, reading the user's real Edge profile was refused by the auto mode classifier, and no browser-automation MCP was connected
**where:** any task phrased as "go get the credentials" or "log in and do what you need"

Every route fails at the same place and it is not the tooling. A browser lands on a login
form and stops, because the next thing needed is a password and a 2FA code that only the
human has. Installing a browser, a browser MCP, or a code sandbox moves the failure point
without removing it. The one route that skips the login is driving the human's existing
logged-in profile, which needs their browser fully closed, will usually trigger re-auth on
a settings page, and copies the secret into the session transcript.

**Fix:** ask for the value directly and have the human write it with a `!` heredoc into a
gitignored `.env`, so the secret never enters the transcript. Say the wall is the password
on the first reply rather than listing tool limitations one at a time across four turns.
