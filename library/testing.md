# testing

Test and build command failures whose real cause was the invocation or execution
environment rather than the source under test.

## Contents

- [Relative test paths follow the runner working directory: `../../tests/sample-desk.test.ts` and `test/paper-strategy.test.ts`.](#relative-test-paths-follow-the-runner-working-directory-testssample-desktestts-and-testpaper-strategytestts)
- [`getaddrinfo ENOTFOUND` and `curl: (6) Could not resolve host` are sandbox DNS boundaries when unchanged commands pass with approved network access.](#getaddrinfo-enotfound-and-curl-6-could-not-resolve-host-are-sandbox-dns-boundaries-when-unchanged-commands-pass-with-approved-network-access)
- [Held back: source-path, missing Python test runners, patch-context, loopback-bind, Chrome reload/navigation, and Computer Use API walls.](#held-back)

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

### `apply_patch verification failed: Failed to find expected lines` at n=4 across 2 file subjects

**verified:** 2026-09-22, three atomic failures against MemeCoin `content.ts` used the wrong file header or absent context beginning `let activeOverlayRoot` and `void scanSignalCards().finally`; a fourth four-file Home log patch expected `deep work start/end` where Meta Cognition said `deep work start`, then succeeded after fresh `sed` output corrected the hunk; no failed attempt changed a file
**where:** four patch attempts across MemeCoin `apps/extension/src/content.ts` and one Home Meta Cognition log file

All four failures mean the hunk context did not match the named target file; they cover two file subjects, not five independent subjects.

**Why:** still held back at n=4 across two file subjects; there are not five observations from five different subjects.
**Fix:** read each target's current numbered lines with `sed`, keep each hunk under its correct Update File header, and split large patches into smaller anchored hunks before retrying them as one verified batch.

### `listen EPERM: operation not permitted 127.0.0.1` disappeared on the exact escalated `npm run verify` at n=1

**verified:** 2026-09-22, sandboxed `npm run verify` in `/private/tmp/memecoin-standalone-20260922` failed only when the local listener returned `EPERM`; the unchanged approved rerun passed 26 core tests, every typecheck and build, 27 extension/backend/Windows tests, and artifact checks
**where:** one MemeCoin verification pair using `server.listen(0, "127.0.0.1")`

The same source and complete command passed when only sandbox authority changed, isolating this occurrence to loopback-bind permission.

**Why:** held back at n=1 from one project subject; there are not five observations from five different subjects.
**Fix:** rerun the complete unchanged gate with approved escalation, then use its full counts and artifact output.

### Reloading one unpacked Chrome extension left old page contexts active at n=2 from one subject

**verified:** 2026-09-22, one MemeCoin reload produced two old unhandled `Extension context invalidated` storage Promise errors and blank surfaces until `chrome://restart`, while a later v0.3.1 reload left the already-open Padre tab on its old injected context until the page was refreshed; catches prevented new errors on the final reload
**where:** two reload observations from the same MemeCoin unpacked extension in Chrome

Both observations show that reloading the extension does not replace the context already injected into an open page; the historical errors remained because clearing them would be destructive.

**Why:** still held back at n=2 from one extension subject; there are not five observations from five different subjects.
**Fix:** catch Promise rejections at Chrome storage reads, writes, and the scanner entrypoint, then refresh the open target page after reloading the extension; use `chrome://restart` when the browser surfaces remain blank.

### `chromeApp.getState()` failed after compaction; `getAXState({disableDiffing:true})` returned Padre state at n=1

**verified:** 2026-09-22, after task compaction `chromeApp.getState()` failed because the App surface exposes `getAXState()`; `cua.rewriteDocumentation()` restored the API reference and `chromeApp.getAXState({disableDiffing:true})` returned the live Padre state
**where:** one compacted Computer Use session controlling Chrome

The failure was an API-method mismatch after context loss, not evidence that the Chrome surface had disappeared.

**Why:** REJECT at n=1 from one session subject; there are not five observations from five different subjects.
**Fix:** call `cua.rewriteDocumentation()` after a compacted Computer Use task, then use the documented App method `getAXState()`.

### BrowserTab `getSnapshot`, `fill`, `getState`, `domContentLoaded`, and `waitForTimeout` were not functions on 9 calls from 3 documented tab subjects

**verified:** 2026-09-29, `cua.createBrowserTab("iab", URL, { visible: false })` returned tab 6 with a valid initial accessibility tree, then `simpleClosureTab.getSnapshot` returned exactly `simpleClosureTab.getSnapshot is not a function`; 2026-10-03, `trainerTab.fill` returned exactly `trainerTab.fill is not a function` during a 24 Hour Fitness application workflow; 2026-10-04, a tab returned by `cua.createBrowserTab` produced exactly `mailTab.getState is not a function` when a fresh Gmail snapshot was needed after waiting, an initialized cua_repl session returned exactly `mailTab.getSnapshot is not a function`, and after `cua.rewriteDocumentation()` listed `tab.playwright.domSnapshot()`, `nodeRepl.write(await mailTab.playwright.domSnapshot())` succeeded and returned the Gmail DOM snapshot; later that date, calling `tab.playwright.domContentLoaded()` on an IAB tab failed with an error ending exactly `is not a function`
**verified:** 2026-10-05, after filling Gmail search and pressing Enter, `gmailTab.waitForTimeout(1800)` returned exactly `waitForTimeout is not a function` before the requested DOM snapshot
**verified:** 2026-10-05 at the 10:32 am Pacific heartbeat, `gmailTab.getState()` returned exactly `gmailTab.getState is not a function` immediately and changed no external state
**verified:** 2026-10-05, after `cua.createBrowserTab()` returned the Gmail inbox tab binding, `mailTab.getSnapshot()` returned exactly `mailTab.getSnapshot is not a function`; the already verified snapshot method is `tab.playwright.domSnapshot()`
**verified:** 2026-10-05, after `let inboxTab = await cua.createBrowserTab(...)` returned a live Gmail tab, `await inboxTab.getState()` returned exactly `inboxTab.getState is not a function`; `cua.rewriteDocumentation()` listed `getAXState(options?)`, and `await inboxTab.getAXState({disableDiffing:true})` then returned the Gmail search results
**where:** three unified-computer-use BrowserTab subjects across application and Gmail workflows

The returned tab objects did not expose those methods; direct accessibility input uses `setValue(elementIndex, value)`, while `fill` belongs to a Playwright locator.

**Why:** still held back after nine calls from three documented tab subjects; there are not five observations from five different subjects.
**Fix:** use BrowserTab `setValue(elementIndex, value)` for direct accessibility input or Playwright locator `fill` in a Playwright context; use the observed `getAXState({disableDiffing:true})` for accessibility state or `tab.playwright.domSnapshot()` for a DOM snapshot; for load waits, `tab.playwright.waitForLoadState({state:"domcontentloaded", timeoutMs:...})` remains UNCONFIRMED until run; for a timed delay, `await new Promise(r => setTimeout(r, ms))` in the CUA JS runtime remains UNCONFIRMED until followed by a successful snapshot.

### `No browser is available` at n=1

**verified:** 2026-09-22, the first `cua.getBrowser({ url: "https://pump.fun/" })` call returned exactly `No browser is available`, and no browser state changed
**where:** `/Users/zayah/Downloads/home-main`, Pump.fun UI inspection

The read-only Jina-rendered content and real-shaped DOM harness are fallback evidence only; acceptance of selectors against the real Pump.fun UI remains unverified.

**Why:** REJECT at n=1; there are not five observations from five different subjects.
**Fix:** run the selector acceptance check in a browser-enabled session before claiming real-UI compatibility.

### `packages/core/src/rating.ts` did not exist; `rg --files packages/core/src` found `research-indicator.ts` at n=1

**verified:** 2026-09-22, `sed -n ... packages/core/src/rating.ts` failed in the MemeCoin repository, while `rg --files packages/core/src` listed the implementation as `packages/core/src/research-indicator.ts`
**where:** one MemeCoin core-source lookup in `/private/tmp/memecoin-standalone-20260922`

The failed read came from guessing a concept-based filename instead of enumerating the repository's current files.

**Why:** REJECT at n=1 from one repository subject; there are not five observations from five different subjects.
**Fix:** run `rg --files` in the narrow source directory before reading an assumed implementation path.

### On Padre, `ctrl+l` typed `/extensions` into page search instead of Chrome's address bar at n=1

**verified:** 2026-09-22, sending `ctrl+l` on Padre put `/extensions` into Padre's own search; refreshing AX state, setting Chrome's `Address and search bar` element to `chrome://extensions`, activating it, and pressing Return navigated correctly, and reloading Padre cleared the accidental filter
**where:** one Computer Use session controlling Google Chrome on Padre

The page intercepted the shortcut, so the keystroke did not prove that Chrome's address bar had focus.

**Why:** REJECT at n=1 from one page/session subject; there are not five observations from five different subjects.
**Fix:** refresh AX state, target the Chrome `Address and search bar` element directly, set and activate it, then press Return; reload the page to clear accidental page-level input.

### Chrome Computer Use returned `element ID is no longer valid` twice after fresh AX reads at n=2 from one subject

**verified:** 2026-09-22, two index clicks on the MemeCoin Reload button at `chrome://extensions` returned `element ID is no longer valid` immediately after fresh AX reads; a current screenshot and direct coordinate click on the visible reload glyph succeeded, and the next AX state showed `Reloaded`
**where:** one Computer Use session and page subject in Google Chrome

Refreshing AX state did not make index-based clicks stable for this control, while the screenshot anchored the successful coordinate action to the visible current surface.

**Why:** REJECT at n=2 from one page/session subject; there are not five observations from five different subjects.
**Fix:** after one refreshed AX click still reports a stale element ID, take a current screenshot, click the visible control by coordinates, then confirm the resulting state through a new AX read.

### `fatal: Unable to create '/Users/zayah/github/dotfiles/.git/index.lock': Operation not permitted` at n=1

**verified:** 2026-09-22, `git add -N library/testing.md` from `/Users/zayah/github/dotfiles` failed with the title's exact error before changing the index, then the identical operation succeeded with approved filesystem escalation
**where:** a Home-sandboxed session updating the separate `/Users/zayah/github/dotfiles` repository

The library file was writable through the patch tool, but the sandbox did not permit Git to create the dotfiles repository's index lock.

**Why:** REJECT at n=1; there are not five observations from five different subjects.
**Fix:** rerun the scoped Git index operation with approved filesystem escalation.

### From `apps/extension`, the repository root is `../..`: use `../../evidence/...` and run verify from root at n=2 from one subject

**verified:** 2026-09-22, from `/private/tmp/memecoin-standalone-20260922/apps/extension`, one packaging run found the archive at `../../evidence/...` and showed that `zip -r` updated an existing archive; a later `zip -q -FS ../../../evidence/...` failed because it climbed one level too far, then the combined command ran `npm run verify` from `@memecoin/extension`, which has no verify script, and no file was overwritten
**where:** two MemeCoin extension packaging invocations from `/private/tmp/memecoin-standalone-20260922/apps/extension`

Both invocations show that artifact paths and npm scripts resolve from the command's actual cwd; they remain one workdir and repository subject, and the older run also showed `zip`'s incremental update behavior.

**Why:** still held back at n=2 from one workdir subject; there are not five observations from five different subjects.
**Fix:** from `apps/extension`, write the archive to `../../evidence/...`; then return to the repository root before `npm run verify`, and inspect the archive with `unzip -l` before accepting it.

### An 80-byte CRLF checksum file made macOS `shasum` read `MemeCoin.exe\r` at n=1

**verified:** 2026-09-22, the downloaded PowerShell-generated `MemeCoin.exe.sha256` was 80 bytes and ended with CRLF; `shasum -a 256 -c MemeCoin.exe.sha256` treated the filename as `MemeCoin.exe\r` and could not open it, although its printed digest exactly matched the independently computed hash
**where:** one MemeCoin v0.2.1 checksum validation on macOS

The digest matched; the observed failure came from the carriage return retained in the filename field for this one cross-platform artifact.

**Why:** REJECT at n=1; there are not five observations from five different subjects.
**Fix:** preserve the downloaded asset and normalize only the validation stream with `tr -d '\r' < MemeCoin.exe.sha256 | shasum -a 256 -c -`.

### Bundled Python `-m pytest -q` returned `No module named pytest`; direct `unittest` ran 17 tests at n=1

**verified:** 2026-10-05, `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 -m pytest -q` exited 1 with exactly `No module named pytest`, while the same interpreter running `tests/test_pipeline.py -q` exited 0 and printed `Ran 17 tests in 1.596s` and `OK`
**where:** one test-runner subject in `/Users/zayah/Documents/Codex/2026-09-29/job-applications/job-pipeline`

The repository test file imports `unittest` and calls `unittest.main()`, so direct execution uses its supported runner without adding a dependency.

**Why:** REJECT at n=1 from one repository and runtime subject; there are not five observations from five different subjects.
**Fix:** run `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 tests/test_pipeline.py -q` and require exit 0 plus the expected test count; do not install pytest without approval.
