---
name: browser
description: Drive a real browser with Playwright MCP - render a JavaScript page, reach a host the sandbox blocks, or fill and submit a form. Read this before reaching for a browser, because three of its four failure modes cost a session each and one of them cannot be solved by tooling at all.
---

# browser

Playwright MCP is installed at user scope. Its tools appear as `mcp__playwright__*`.

Reach for it when `curl` genuinely will not do: a page that renders from JavaScript, a host
the sandbox blocks for Node, or a form that has to be filled and submitted. For fetching
HTML or JSON, `curl` is faster, cheaper and already works.

## Before anything else: can this be done at all?

**A page behind a login is not reachable by an agent.** The browser lands on the login form
and stops, because the next thing required is a password and a 2FA code that only the human
has. Installing a browser does not change this, and neither does a browser MCP or a code
sandbox - each one moves the failure point without removing it.

So when a task is phrased as *"go log in and get X"*, say on the first reply that the wall
is the credential rather than the tooling. Listing tool limitations one at a time across
several turns wastes the human's time and reads as excuses.

Ask for the value instead, and have the human write it themselves so it never enters the
transcript:

```
! cat > path/to/.env <<'ENVEOF'
SOME_SECRET=paste_here
ENVEOF
```

The one route that skips a login is driving the human's **existing logged-in profile**. It
needs their browser fully closed, usually triggers re-auth on a settings page, and copies
whatever is on screen into the session transcript. Offer it, name those three costs, and let
them choose. Never read a browser profile without asking.

## The three install and runtime traps

**The tools do not exist in the session that installed the server.** `claude mcp list` says
`✔ Connected` immediately, but MCP servers load at session start, so `ToolSearch` for
`mcp__playwright__*` finds nothing until Claude restarts. Add the server, then tell the
human to restart. Do not spend a turn wondering why the tools are missing.

**Playwright's bundled chromium does not currently run on this machine.** `--with-deps`
dies at `sudo: A terminal is required to authenticate`, and the binary alone then fails at
launch with `libnspr4.so: cannot open shared object file`, exit 127. The host is Ubuntu
under home-manager, so those libraries are an `apt` problem on a nix-managed box. Until
that is resolved in `home.nix`, **use the Windows Edge route below instead** - do not spend
a session fighting it.

**A browser does not escape the sandbox's network limits.** A Linux browser under WSL is a
WSL process, so it hits the same per-host egress allowlist that makes Node's `fetch` time
out on hosts `curl` reaches fine. Test reachability before building anything on top of it.
See `library/web.md`.

## When the sandbox blocks the host

Headless Edge on the Windows side is a Windows process and is not subject to the WSL
allowlist:

```
"/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" \
  --headless=new --disable-gpu --no-first-run \
  --user-data-dir='C:\Users\Public\edge-probe' \
  --dump-dom "https://example.com"
```

Use a Windows-style throwaway profile path, never a WSL one. This reaches the page; it does
not log anyone in.

## Rules

- Read the page before acting on it. A 403 block page and an empty result look identical to
  a caller that only checks for a parse failure.
- Never submit a form that sends, posts, buys or publishes without a person saying yes.
- Never read the human's browser profile without asking first.
- Close what you open. A leaked headless browser survives the session.
- Every wall goes in `library/`, in the session you hit it.
