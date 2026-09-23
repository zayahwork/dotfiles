# testing

Test and build command failures whose real cause was the invocation or execution
environment rather than the source under test.

## Contents

- [Relative test paths follow the runner working directory: `../../tests/sample-desk.test.ts` and `test/paper-strategy.test.ts`.](#relative-test-paths-follow-the-runner-working-directory-testssample-desktestts-and-testpaper-strategytestts)
- [`getaddrinfo ENOTFOUND` and `curl: (6) Could not resolve host` are sandbox DNS boundaries when unchanged commands pass with approved network access.](#getaddrinfo-enotfound-and-curl-6-could-not-resolve-host-are-sandbox-dns-boundaries-when-unchanged-commands-pass-with-approved-network-access)
- [Held back: patch-context, loopback-bind, browser-extension reload, and Computer Use API walls.](#held-back)

---

## Relative test paths follow the runner working directory: ../../tests/sample-desk.test.ts and test/paper-strategy.test.ts

**verified:** 2026-09-20, from Cove's `source/cove-crm`, `node --test ../../../tests/sample-desk.test.ts` exited 1 with `Could not find`, while `node --test ../../tests/sample-desk.test.ts` exited 0 with `tests 1`, `pass 1`, and `fail 0`; 2026-09-22, from the MemeCoin monorepo root, `npm test -- --run packages/core/test/paper-strategy.test.ts` exited 1 after npm changed cwd to `packages/core`, and Vitest printed `No test files found`
**where:** `Home/09 🏗️ Builds/Nate Pool Studio/source/cove-crm`; `/private/tmp/memecoin-standalone-20260922`

Relative test filters are resolved from the runner's actual working directory, including a workspace cwd selected by npm, not necessarily from the repository root where the outer command began.

**Why:** both failing paths were calculated from the repository layout instead of the cwd used by the test runner.
**Fix:** from Cove's `source/cove-crm`, run `node --test ../../tests/sample-desk.test.ts`; from the MemeCoin root workspace script, run `npm test -- --run test/paper-strategy.test.ts`, or run Vitest from `packages/core`.

---

## getaddrinfo ENOTFOUND and curl: (6) Could not resolve host are sandbox DNS boundaries when unchanged commands pass with approved network access

**verified:** 2026-09-20, sandboxed `npm run build` failed on `getaddrinfo ENOTFOUND fonts.googleapis.com` and the unchanged command completed the Next.js 15.5.25 build with approved network access; 2026-09-22, sandboxed `curl --max-time 20 --show-error --include https://r.jina.ai/https://pump.fun/` failed immediately with `curl: (6) Could not resolve host: r.jina.ai`, while the identical escalated command returned HTTP/2 200 and 26,172 decompressed bytes; 2026-09-22, three parallel `curl --max-time 20 --show-error` reads of `https://docs.typesafe.ai/llms.txt`, `/patterns/composite-scoring.md`, and `/confidence.md` each failed immediately with `curl: (6) Could not resolve host: docs.typesafe.ai`, then identical escalated reads succeeded with 16,019, 13,545, and 11,396 bytes respectively; 2026-09-22, sandboxed `curl -sS --max-time 20 https://r.jina.ai/https://docs.typesafe.ai/llms.txt` failed immediately with `curl: (6) Could not resolve host: r.jina.ai` during TypeSafe indicator work, while the exact escalated read returned the current `llms.txt` index in 4.3 seconds, four targeted composite-scoring, citation-checking, confidence, and primitives reads completed in 23.7 seconds, and a filtered citation/confidence read completed in 5.2 seconds
**where:** `Home/09 🏗️ Builds/Nate Pool Studio/source/cove-crm`; `/Users/zayah/Downloads/home-main`

Build-time font fetching and read-only Jina fetching both require DNS, so a sandbox network boundary can fail before source or target-page behavior is evaluated.

**Why:** in every completed comparison pair, the identical command passed when only network authority changed, isolating the failure to the sandbox boundary.
**Fix:** rerun the identical read-only command with approved network access; investigate the source or endpoint only if that rerun still fails.

---

## Held back

### `apply_patch verification failed: Failed to find expected lines in apps/extension/src/content.ts` at n=3 from one subject

**verified:** 2026-09-22, three atomic failures against the same MemeCoin `content.ts`: a test-file hunk sat under the wrong Update File header, a later hunk expected `let activeOverlayRoot: ShadowRoot | null = null;` at the wrong position, and another expected absent context beginning `void scanSignalCards().finally`; no failed attempt changed a file
**where:** `/Users/zayah/Downloads/home-main`, three patches touching the same MemeCoin `apps/extension/src/content.ts` subject

All three failures mean the hunk context did not match the named target file, but they come from one file and project rather than independent subjects.

**Why:** still held back at n=3 from one subject; there are not five observations from five different subjects.
**Fix:** read the target's current numbered lines, keep each hunk under its correct Update File header, and split large patches into smaller anchored hunks before retrying them as one verified batch.

### `listen EPERM: operation not permitted 127.0.0.1` disappeared on the exact escalated `npm run verify` at n=1

**verified:** 2026-09-22, sandboxed `npm run verify` in `/private/tmp/memecoin-standalone-20260922` failed only when the local listener returned `EPERM`; the unchanged approved rerun passed 26 core tests, every typecheck and build, 27 extension/backend/Windows tests, and artifact checks
**where:** one MemeCoin verification pair using `server.listen(0, "127.0.0.1")`

The same source and complete command passed when only sandbox authority changed, isolating this occurrence to loopback-bind permission.

**Why:** held back at n=1 from one project subject; there are not five observations from five different subjects.
**Fix:** rerun the complete unchanged gate with approved escalation, then use its full counts and artifact output.

### Reloading one unpacked Chrome extension left 2 historical `Extension context invalidated` Promise errors at n=1

**verified:** 2026-09-22, reloading the unpacked MemeCoin extension produced two old unhandled Chrome storage Promise errors and blank web surfaces until `chrome://restart`; catches added to Promise-based storage reads, writes, and the scanner entrypoint prevented new errors on the final reload
**where:** one MemeCoin unpacked-extension reload sequence in Chrome

The two old errors remained in UI history because clearing them would be a destructive UI action; the final reload proves only that no new error appeared in this sequence.

**Why:** REJECT at n=1 from one extension subject; there are not five observations from five different subjects.
**Fix:** catch Promise rejections at Chrome storage reads, writes, and the scanner entrypoint, then restart Chrome and distinguish historical console rows from new ones.

### `chromeApp.getState()` failed after compaction; `getAXState({disableDiffing:true})` returned Padre state at n=1

**verified:** 2026-09-22, after task compaction `chromeApp.getState()` failed because the App surface exposes `getAXState()`; `cua.rewriteDocumentation()` restored the API reference and `chromeApp.getAXState({disableDiffing:true})` returned the live Padre state
**where:** one compacted Computer Use session controlling Chrome

The failure was an API-method mismatch after context loss, not evidence that the Chrome surface had disappeared.

**Why:** REJECT at n=1 from one session subject; there are not five observations from five different subjects.
**Fix:** call `cua.rewriteDocumentation()` after a compacted Computer Use task, then use the documented App method `getAXState()`.

### `No browser is available` at n=1

**verified:** 2026-09-22, the first `cua.getBrowser({ url: "https://pump.fun/" })` call returned exactly `No browser is available`, and no browser state changed
**where:** `/Users/zayah/Downloads/home-main`, Pump.fun UI inspection

The read-only Jina-rendered content and real-shaped DOM harness are fallback evidence only; acceptance of selectors against the real Pump.fun UI remains unverified.

**Why:** REJECT at n=1; there are not five observations from five different subjects.
**Fix:** run the selector acceptance check in a browser-enabled session before claiming real-UI compatibility.

### `fatal: Unable to create '/Users/zayah/github/dotfiles/.git/index.lock': Operation not permitted` at n=1

**verified:** 2026-09-22, `git add -N library/testing.md` from `/Users/zayah/github/dotfiles` failed with the title's exact error before changing the index, then the identical operation succeeded with approved filesystem escalation
**where:** a Home-sandboxed session updating the separate `/Users/zayah/github/dotfiles` repository

The library file was writable through the patch tool, but the sandbox did not permit Git to create the dotfiles repository's index lock.

**Why:** REJECT at n=1; there are not five observations from five different subjects.
**Fix:** rerun the scoped Git index operation with approved filesystem escalation.

### `zip -r ../../evidence/...` updated the existing archive instead of replacing it at n=1

**verified:** 2026-09-22, from `/private/tmp/memecoin-standalone-20260922/apps/extension`, `mv evidence/memecoin-extension-0.2.1.zip /private/tmp/...` failed because the archive was two directories above, then `zip -r ../../evidence/... manifest.json dist/content.js` updated that existing archive and left both wrong `apps/extension/...` entries and correct root entries
**where:** one MemeCoin extension packaging occurrence in `/private/tmp/memecoin-standalone-20260922/apps/extension`

The occurrence combines a current-workdir path mistake with `zip`'s incremental update behavior, so neither cause has an independent comparison.

**Why:** REJECT at n=1; there are not five observations from five different subjects.
**Fix:** resolve and check the archive's exact path from the current workdir, move the existing archive to a recoverable temporary path, create a fresh archive, then verify `unzip -l` contains only `manifest.json` and `dist/content.js`.

### An 80-byte CRLF checksum file made macOS `shasum` read `MemeCoin.exe\r` at n=1

**verified:** 2026-09-22, the downloaded PowerShell-generated `MemeCoin.exe.sha256` was 80 bytes and ended with CRLF; `shasum -a 256 -c MemeCoin.exe.sha256` treated the filename as `MemeCoin.exe\r` and could not open it, although its printed digest exactly matched the independently computed hash
**where:** one MemeCoin v0.2.1 checksum validation on macOS

The digest matched; the observed failure came from the carriage return retained in the filename field for this one cross-platform artifact.

**Why:** REJECT at n=1; there are not five observations from five different subjects.
**Fix:** preserve the downloaded asset and normalize only the validation stream with `tr -d '\r' < MemeCoin.exe.sha256 | shasum -a 256 -c -`.
