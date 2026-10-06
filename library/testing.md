# testing

Test and build command failures whose real cause was the invocation or execution
environment rather than the source under test.

## Contents

- [Relative test paths follow the runner working directory: `../../tests/sample-desk.test.ts` and `test/paper-strategy.test.ts`.](#relative-test-paths-follow-the-runner-working-directory-testssample-desktestts-and-testpaper-strategytestts)
- [`getaddrinfo ENOTFOUND` and `curl: (6) Could not resolve host` are sandbox DNS boundaries when unchanged commands pass with approved network access.](#getaddrinfo-enotfound-and-curl-6-could-not-resolve-host-are-sandbox-dns-boundaries-when-unchanged-commands-pass-with-approved-network-access)
- [Held back: source-path and artifact marker arguments, tracker count bounds, missing PDF fallback paths, Python runtime, dynamic-import and test-runner walls, openpyxl dimensions and short rows, artifact-tool copy behavior, Git push and revision-flag failures, patch-context and patch-format, loopback-bind, Chrome reload/navigation, and Computer Use API walls.](#held-back)

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

### BrowserTab `getSnapshot`, `snapshot`, `fill`, `getState`, `domContentLoaded`, `waitForTimeout`, and `getByRole` were not functions on 25 calls from 7 documented tab subjects

**verified:** 2026-09-29, `cua.createBrowserTab("iab", URL, { visible: false })` returned tab 6 with a valid initial accessibility tree, then `simpleClosureTab.getSnapshot` returned exactly `simpleClosureTab.getSnapshot is not a function`; 2026-10-03, `trainerTab.fill` returned exactly `trainerTab.fill is not a function` during a 24 Hour Fitness application workflow; 2026-10-04, a tab returned by `cua.createBrowserTab` produced exactly `mailTab.getState is not a function` when a fresh Gmail snapshot was needed after waiting, an initialized cua_repl session returned exactly `mailTab.getSnapshot is not a function`, and after `cua.rewriteDocumentation()` listed `tab.playwright.domSnapshot()`, `nodeRepl.write(await mailTab.playwright.domSnapshot())` succeeded and returned the Gmail DOM snapshot; later that date, calling `tab.playwright.domContentLoaded()` on an IAB tab failed with an error ending exactly `is not a function`
**verified:** 2026-10-05, after filling Gmail search and pressing Enter, `gmailTab.waitForTimeout(1800)` returned exactly `waitForTimeout is not a function` before the requested DOM snapshot
**verified:** 2026-10-05, `await searchTab.waitForTimeout(1500)` returned exactly `searchTab.waitForTimeout is not a function` during a browser job-search workflow
**verified:** 2026-10-05 at the 10:32 am Pacific heartbeat, `gmailTab.getState()` returned exactly `gmailTab.getState is not a function` immediately and changed no external state
**verified:** 2026-10-05, after `cua.createBrowserTab()` returned the Gmail inbox tab binding, `mailTab.getSnapshot()` returned exactly `mailTab.getSnapshot is not a function`; the already verified snapshot method is `tab.playwright.domSnapshot()`
**verified:** 2026-10-05, after `let inboxTab = await cua.createBrowserTab(...)` returned a live Gmail tab, `await inboxTab.getState()` returned exactly `inboxTab.getState is not a function`; `cua.rewriteDocumentation()` listed `getAXState(options?)`, and `await inboxTab.getAXState({disableDiffing:true})` then returned the Gmail search results
**verified:** 2026-10-05, `gmailTab.getSnapshot()` returned exactly `gmailTab.getSnapshot is not a function`, and refreshed documentation listed `Target.getAXState(options?)`; the same BrowserTab method had already returned a fresh Gmail accessibility tree as `await inboxTab.getAXState({disableDiffing:true})`
**verified:** 2026-10-05, after `cua.createBrowserTab("iab", ...)` returned the YMCA careers tab and its accessibility tree exposed an `Okay` button ID, `ymcaTab.getByRole("button", {name:"Okay"}).click()` returned exactly `ymcaTab.getByRole is not a function`; current CUA documentation lists no `getByRole` method on `Tab` and routes DOM selectors through Playwright locators
**verified:** 2026-10-05 at 9:18 pm Pacific, after a Gmail BrowserTab was created, `await mailTab.snapshot()` returned exactly `mailTab.snapshot is not a function`; `getAXState({disableDiffing:true})` remains the observed accessibility-state method
**verified:** 2026-10-05, `await gmailTab.waitForTimeout(1500); await gmailTab.snapshot();` stopped with exactly `gmailTab.waitForTimeout is not a function`; replacing only the wait with `await new Promise(resolve => setTimeout(resolve, 1500))` completed the timer, then the subsequent `await gmailTab.snapshot()` returned exactly `gmailTab.snapshot is not a function`
**verified:** 2026-10-05 at about 10:17 pm Pacific, after `cua.createBrowserTab` returned a Gmail tab and its initial accessibility state, `mailTab.snapshot()` returned exactly `mailTab.snapshot is not a function`; the observed fresh-state method remains `getAXState({disableDiffing:true})`
**verified:** 2026-10-06, after `let gmail = await cua.createBrowserTab(...)`, `gmail.getState()` returned exactly `gmail.getState is not a function`; a separate `gmailTab.getState()` call returned the same TypeError class
**verified:** 2026-10-06, `hdTab.getByRole(...)` returned exactly `hdTab.getByRole is not a function` on the first attempt to click the Home Depot Apply link
**verified:** 2026-10-06, while continuing a summarized Computer Use context on hidden Gmail tab `mailTab2`, `mailTab2.playwright.domContentLoaded()`, `mailTab2.getState()`, and `mailTab2.snapshot()` each returned an exact error ending `is not a function`
**verified:** 2026-10-06, after `cua.createBrowserTab` returned hidden IAB binding `paycomTab` on a JavaScript Paycom careers page, `await paycomTab.getState()` returned exactly `paycomTab.getState is not a function`; no Paycom recovery call was supplied
**verified:** 2026-10-06 at 2:55 am Pacific, `gmailTab.getState()` returned exactly `gmailTab.getState is not a function`; `gmailTab.getAXState({disableDiffing:true})` then succeeded and returned the complete Gmail search results
**verified:** 2026-10-06 at about 4:19 am Pacific, after `cua.createBrowserTab(...)` returned an initial accessibility snapshot, `gmail.snapshot()` returned exactly `gmail.snapshot is not a function`; no recovery call was supplied in that observation
**where:** seven unified-computer-use BrowserTab subjects across application, Gmail, job-search, and careers workflows

The returned tab objects did not expose those methods; direct accessibility actions use element IDs, while `fill` and `getByRole` belong under the tab's Playwright interface.

**Why:** still held back after twenty-five calls from seven documented tab subjects because no untouched control was measured; the subject count alone does not pass the causal bar.
**Fix:** after a summarized Computer Use task, call `cua.rewriteDocumentation()` before interacting. Wait with the verified JavaScript runtime form `await new Promise(resolve => setTimeout(resolve, ms))`; then use the observed `getAXState({disableDiffing:true})` for accessibility state or `tab.playwright.domSnapshot()` for a DOM snapshot, not `tab.snapshot()`. Use BrowserTab `setValue(elementIndex, value)` for direct accessibility input or `tab.playwright.getByRole(...)` and `tab.playwright.locator(...)` for DOM selection; the Paycom recovery and the YMCA and Home Depot role-click results remain UNCONFIRMED until run and visibly verified.

### ALDI AX tree exposed 2 `APPLY` links while the exact Playwright role locator matched 0 at n=1

**verified:** 2026-10-06, the ALDI careers accessibility tree exposed two links named `APPLY`, then `aldiTab.playwright.getByRole("link", { name: "APPLY", exact: true }).first().click()` timed out with no matches
**where:** one ALDI careers page in unified computer use

The two observation surfaces disagreed about the exact-role match; whether the links are absent from the DOM, renamed, or represented differently is UNCONFIRMED.

**Why:** REJECT at n=1 from one page and selector subject; there are not five observations from five different subjects.
**Fix:** UNCONFIRMED; inspect `aldiTab.playwright.domSnapshot()`, locate the exact employer application `href`, navigate through that verified URL, and confirm the destination before continuing.

### `setValue(15, "All job types")` returned `Select did not retain the requested option` at n=1

**verified:** 2026-10-05 at about 5:48 pm Pacific, the YMCA of Snohomish County SaaS HR category control appeared as an accessibility pop-up button with Value `Housekeeping`; `tab.setValue(15, "All job types")` returned exactly `Select did not retain the requested option`, and `performSecondaryAction(..., "Expand")` returned no expanded state
**where:** one unified-computer-use category-filter interaction on the YMCA of Snohomish County careers site

The accessibility control did not retain the requested option or expose an expanded state in this interaction; its underlying widget implementation is UNCONFIRMED.

**Why:** REJECT at n=1 from one control and site subject; there are not five observations from five different subjects.
**Fix:** UNCONFIRMED; target the control with a Playwright DOM locator or use site-specific visible navigation, then verify both the displayed filter label and result count.

### `No browser is available` at n=1

**verified:** 2026-09-22, the first `cua.getBrowser({ url: "https://pump.fun/" })` call returned exactly `No browser is available`, and no browser state changed
**where:** `/Users/zayah/Downloads/home-main`, Pump.fun UI inspection

The read-only Jina-rendered content and real-shaped DOM harness are fallback evidence only; acceptance of selectors against the real Pump.fun UI remains unverified.

**Why:** REJECT at n=1; there are not five observations from five different subjects.
**Fix:** run the selector acceptance check in a browser-enabled session before claiming real-UI compatibility.

### 8 guessed, stale, or wrong-cwd local paths failed across 9 invocations; current paths found source, tracker, test, and counter targets

**verified:** 2026-09-22, `sed -n ... packages/core/src/rating.ts` failed in the MemeCoin repository, while `rg --files packages/core/src` listed the implementation as `packages/core/src/research-indicator.ts`
**verified:** 2026-10-06, `wc -c job-pipeline/application-tracker.csv` returned `No such file or directory`; `rg --files /Users/zayah/Documents/Codex/2026-09-29/job-applications | rg '(^|/)(application-tracker|job-application-tracker)\\.(csv|xlsx)$'` found only `outputs/job-application-tracker.xlsx`, and `wc -c` reported 17,517 bytes for that file
**verified:** 2026-10-06, `wc -c job-pipeline/output/application-tracker.xlsx` returned `No such file or directory`, and a later byte-count command against guessed filename `Zayah Nelson - Job Application Tracker.xlsx` returned `open: No such file or directory`; the verified tracker path remained `outputs/job-application-tracker.xlsx`
**verified:** 2026-10-06, a test-command lookup found neither `job-pipeline/package.json` nor `job-pipeline/scripts/`; `rg --files job-pipeline` instead returned `job-pipeline/tests/test_pipeline.py` and no package or scripts path
**verified:** 2026-10-06 at 5:24 am Pacific, Node failed with `MODULE_NOT_FOUND` for stale prior-turn path `job-pipeline/work/heartbeat-2026-10-06-0409/count_tracker.mjs`; a current `rg --files job-pipeline | rg '(^|/)count_tracker\.mjs$'` lookup later returned that path plus the `heartbeat-2026-10-05-2222` and `heartbeat-2026-10-06-0356` copies
**verified:** 2026-10-06, bundled Node in `job-pipeline/work/heartbeat-2026-10-06-0557` ran `FileBlob.load("outputs/job-application-tracker.xlsx")` and returned `ENOENT` with the eval stack rooted in that heartbeat directory; an isolated reproduction returned the same error, while loading `/Users/zayah/Documents/Codex/2026-09-29/job-applications/outputs/job-application-tracker.xlsx` from the same cwd printed `{"loaded":true,"size":null}`
**where:** nine failed reads of eight guessed, stale, or wrong-cwd paths across five local path-discovery subjects in the MemeCoin and job-applications workspaces

Six reads used guessed concept paths; the seventh used a prior-turn path that was absent when Node ran but appeared later, and the eighth paired a heartbeat-cwd failure with a successful absolute-path load.

**Why:** still held back at n=9 failures from five workspace and path subjects because no untouched population control was measured; the failure count alone does not pass the causal bar.
**Fix:** run `rg --files` in the narrow source directory immediately before reading, measuring, or selecting a script or test command. For artifact paths, run from the repository root or pass the absolute path, require the resolved file to exist, and require nonempty output; the absolute `FileBlob.load` recovery is verified, while the stale counter execution recovery remains UNCONFIRMED.

### `Applications!A7:J65` omitted row 66 while reporting 55 tracker rows and 21 blocked at n=1

**verified:** 2026-10-06 at 5:25 am Pacific, the then-current `count_tracker.mjs` read fixed range `Applications!A7:J65` and printed 55 tracker rows plus 21 blocked after Nordstrom was added at row 66; the current script reads `sheet.getUsedRange().rowCount`, selects `A8:J${usedRowCount}`, filters for nonempty status, and a same-window rerun printed 55 tracker rows plus 22 blocked
**where:** one tracker-count script and `outputs/job-application-tracker.xlsx` state

The source and output establish the row-66 omission for this one script state but do not establish behavior in other workbooks.

**Why:** REJECT at n=1 from one workbook and count-script subject; there are not five observations from five different subjects.
**Fix:** derive the application-row end from the current used range or table, start below the header, and count only rows with a nonempty status; the current used-range implementation and nonempty rerun are verified.

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

### `mallTab.click(18)` returned `Could not check the click target's shadow root` at n=1

**verified:** 2026-10-05, on `https://shopsatpalmdesert.com/careers`, `await mallTab.click(18)` returned exactly `Could not check the click target's shadow root`; `await mallTab.goto("https://shopsatpalmdesert.com/job/part-time-seasonal-associate")` followed by `await mallTab.getAXState(...)` succeeded
**where:** one unified-computer-use navigation subject on The Shops at Palm Desert careers site

The failed accessibility click did not establish whether the page or tool caused the shadow-root check failure, while direct navigation reached the intended visible job URL.

**Why:** REJECT at n=1 from one page and click subject; there are not five observations from five different subjects.
**Fix:** when this exact click fails and the intended visible link URL is known, navigate the same tab directly to that URL and verify the destination with `getAXState(...)`.

### `exec_module` without `sys.modules` registration raised `AttributeError: 'NoneType' object has no attribute '__dict__'` at n=1

**verified:** 2026-10-05, bundled Python 3.12 loaded `job-pipeline/pipeline.py` through `spec_from_file_location`, `module_from_spec`, and `exec_module` without first registering the module, then failed at `@dataclass(frozen=True)` in `dataclasses._is_type` with exactly `AttributeError: 'NoneType' object has no attribute '__dict__'` because `sys.modules.get(cls.__module__)` was `None`
**verified:** 2026-10-05, `tests/test_pipeline.py` registered `sys.modules[SPEC.name] = pipeline` before `SPEC.loader.exec_module(pipeline)`; direct execution with the bundled Python completed 18 tests in 1.368 seconds, printed `OK`, and exited 0
**where:** one dynamic test import of a module declaring `@dataclass`

The failed import and passing registered-module run isolate the observed failure to this dynamic import setup rather than the pipeline execution, but broader Python-version behavior is unconfirmed.

**Why:** REJECT at n=1 from one import subject; there are not five observations from five different subjects.
**Fix:** set `sys.modules[SPEC.name] = module` before `SPEC.loader.exec_module(module)`, then run the test file and require exit 0 plus its expected test count.

### Direct `pipeline.py` execution was denied; system Python lacked `docx` and `pypdf`; bundled Python passed 18 then 24 tests

**verified:** 2026-10-05, `python3 pipeline.py run` in `/Users/zayah/Documents/Codex/2026-09-29/job-applications/job-pipeline` exited with a traceback at `pipeline.py` line 29 on `from docx import Document`; a direct check confirmed `/opt/homebrew/bin/python3` returned exactly `ModuleNotFoundError: No module named 'docx'`, while `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3` imported `docx` from its Python 3.12 site-packages
**verified:** 2026-10-05 at 11:43 am Pacific, `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 pipeline.py run` completed successfully and printed `discovered_count 187`, `scored_count 178`, `skipped_duplicate_count 9`, `ready_count 0`, `blocked_count 0`, and `source_failures []`
**verified:** 2026-10-05 at 4:24 pm Pacific, default `/opt/homebrew/bin/python3` 3.14.7 running `python3 -m unittest job-pipeline/tests/test_pipeline.py` failed with `ModuleNotFoundError: No module named 'docx'`, and a `python3` PDF validation snippet failed with exactly `ModuleNotFoundError: No module named 'pypdf'`; a paired check showed the bundled Python imported `docx` 1.2.0 and `pypdf` 6.10.0, then ran `job-pipeline/tests/test_pipeline.py -q` with `Ran 18 tests in 0.843s`, `OK`, and exit 0
**verified:** 2026-10-05 at about 5:08 pm Pacific, `/opt/homebrew/bin/python3` 3.14.7 running both `python3 job-pipeline/pipeline.py run` and `python3 -m unittest discover -s job-pipeline/tests -v` failed with exactly `ModuleNotFoundError: No module named 'docx'`; this repeats the same runtime and workspace subject
**verified:** 2026-10-05, direct execution of `job-pipeline/pipeline.py` returned `permission denied`; invoking it through system `python3` then failed with `ModuleNotFoundError: No module named 'docx'`, while the bundled Python path remained the verified successful runtime for the script and tests
**verified:** 2026-10-05, another Homebrew `python3` pair failed immediately because `python-docx` was absent: the pipeline exited 1 with exactly `ModuleNotFoundError: No module named 'docx'`, and unittest reported one failed import followed by `FAILED (errors=1)`; the bundled Python path remained the verified recovery
**verified:** 2026-10-05 at about 10:13 pm Pacific, `python3 job-pipeline/pipeline.py run` again failed immediately at `pipeline.py` line 29 with exactly `ModuleNotFoundError: No module named 'docx'`; no job-applications file was changed
**verified:** 2026-10-06, system `python3` running the pipeline and its tests failed at import with exactly `ModuleNotFoundError: No module named 'docx'`, while the bundled workspace Python completed the working test invocation with 24 tests passed
**where:** job-pipeline tests, pipeline execution, and PDF validation from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The paired checks establish runtime selection as the wall in this workspace, not a failing test suite.

**Why:** REJECT across one workspace and machine environment; there are not five observations from five different environment subjects.
**Fix:** invoke the script and dependency-bearing tests with `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3` instead of executing `pipeline.py` directly or using system `python3`, then verify the command's real output and exit status.

### `apply_patch verification failed: Failed to find expected lines` at n=15 across 7 file subjects

**verified:** 2026-09-22, three atomic failures against MemeCoin `content.ts` used the wrong file header or absent context beginning `let activeOverlayRoot` and `void scanSignalCards().finally`; a fourth four-file Home log patch expected `deep work start/end` where Meta Cognition said `deep work start`, then succeeded after fresh `sed` output corrected the hunk; no failed attempt changed a file
**verified:** 2026-10-05, two patches bundled stable source and test edits with a generated `job-pipeline/state/seen-job-keys.json` reset whose exact key list changed after context was drafted; both whole patches were rejected when verification could not find the expected JSON lines
**verified:** 2026-10-05, one library/web.md patch expected a generated Markdown anchor containing `reactive-resume-reactive-resume`, while the current line contained `reactive-resumereactive-resume`; `apply_patch` returned `Failed to find expected lines` and changed no file
**verified:** 2026-10-05, one library/testing.md patch expected `Why: REJECT after nine calls` while the current entry said `Why: still held back after nine calls`; `apply_patch` returned `Failed to find expected lines` and changed no file
**verified:** 2026-10-05, one library/web.md patch expected the truncation-entry Fix without its current `UNCONFIRMED;` prefix; `apply_patch` returned `Failed to find expected lines` and changed no file
**verified:** 2026-10-05, one library/testing.md patch expected the patch-context entry to be followed by the openpyxl entry, while the current file placed `listen EPERM` next; `apply_patch` returned `Failed to find expected lines` and changed no file
**verified:** 2026-10-05, one library/terminal.md patch expected the indexed detailed Held back contents row while the working file contained a broader generic row; `apply_patch` returned `Failed to find expected lines` and changed no file
**verified:** 2026-10-05, one temporary indexed library/web.md patch expected Jina OfferUp and Ashby rows that existed only in the dirty working file; `apply_patch` returned `Failed to find expected lines` and changed no file
**verified:** 2026-10-05, one temporary indexed library/testing.md patch expected an uncommitted artifact-tool module-resolution subject that was absent from the index; `apply_patch` returned `Failed to find expected lines` and changed no file
**verified:** 2026-10-05, one library/web.md patch expected the GitHub field entry to be followed immediately by OpenCLI while intervening GitHub API subjects were present; `apply_patch` returned `Failed to find expected lines` and changed no file
**verified:** 2026-10-06, one spreadsheet-builder patch expected bare `Date.UTC(...)` lines, while the current source used `Date.UTC(...) / 86400000 + 25569`; `apply_patch` returned exactly `apply_patch verification failed: Failed to find expected lines` and changed no file
**where:** fifteen patch attempts across MemeCoin `apps/extension/src/content.ts`, one Home Meta Cognition log file, generated `job-pipeline/state/seen-job-keys.json`, one spreadsheet builder, `library/web.md`, `library/testing.md`, and `library/terminal.md`

All fifteen failures mean the hunk context did not match the named target file; they cover seven file subjects.

**Why:** still held back at n=15 across seven file subjects because no untouched control was measured; the subject count alone does not pass the causal bar.
**Fix:** read each target immediately before editing and patch only current exact context; the third-recurrence rule now requires a reusable preflight check, which remains UNCONFIRMED until built and exercised.

### `rm -f style commands are not permitted` rejected one narrow QA cleanup before execution

**verified:** 2026-10-06, a resume QA command containing `rm -rf job-pipeline/work/qa-home-depot-2026-10-06-0014` returned exactly `rm -f style commands are not permitted. Use a safer approach`, with no child-process output
**where:** one exec command-gate decision in `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The gate rejected the full command before the intended QA work ran, even though the removal target was one named work directory.

**Why:** REJECT at n=1 from one command and gate subject; there are not five observations from five different subjects.
**Fix:** create a fresh unique output directory or use `mktemp -d`, leave the old directory in place, and run QA against the new path without destructive cleanup.

### `git apply --cached --check` rejected 8 generated patches across 6 patch files before staging

**verified:** 2026-10-05, three generated patches returned `corrupt patch` at lines 23, 25, and 12 because their unified-diff hunk counts did not match the lines supplied; correcting each header count made every patch pass `git apply --cached --check` and apply cleanly
**verified:** 2026-10-05, one zero-context `library/web.md` hunk returned `patch failed: library/web.md:15` twice without `--unidiff-zero`; the same patch passed the check and applied cleanly with `git apply --cached --unidiff-zero`
**verified:** 2026-10-05, an OpenCLI Reddit two-hunk patch returned `patch failed: library/web.md:204` twice, and a split entry-only patch returned the same failure once even though its preimage matched the index; exporting the index file with `git checkout-index`, editing that copy, hashing it, and updating only the named index path produced the intended cached diff and passed `git diff --cached --check`
**where:** eight staging preflight attempts across six generated patch files for scoped dotfiles-library commits

All eight failures occurred in the preflight command and left the index unchanged; why the three OpenCLI patches failed despite a matching preimage is UNCONFIRMED.

**Why:** REJECT after eight calls across six patch-file subjects because no untouched control was measured; the subject count alone does not pass the causal bar.
**Fix:** run `git apply --cached --check` before every scoped patch; correct hunk counts before retrying and use `--unidiff-zero` only for deliberate zero-context hunks; if an exact preimage still fails, export only the indexed file with `git checkout-index`, edit the copy, stage its verified blob for that path, and inspect `git diff --cached --check` plus the full cached diff before committing.

### `git rev-parse --short` with 3 refs returned `fatal: Needed a single revision` at n=1

**verified:** 2026-10-05, `git rev-parse --short origin/development origin/staging origin/main` returned exactly `fatal: Needed a single revision`; three separate `git rev-parse --short` calls then printed `7603bef`, `c37ac01`, and `40170b4`
**where:** one post-promotion branch verification in `/Users/zayah/github/dotfiles`

The combined invocation did not print any branch hash, while one invocation per ref returned all three abbreviated revisions.

**Why:** REJECT at n=1 from one Git command and repository subject; there are not five observations from five different subjects.
**Fix:** call `git rev-parse --short` once per revision, and verify that every call prints one nonempty hash.

### openpyxl read-only tracker reported `None` dimensions and 148 five-cell rows; positional reads failed 3 times

**verified:** 2026-10-05, `openpyxl.load_workbook(..., read_only=True)` opened the then 12,974-byte `outputs/job-application-tracker.xlsx` workbook and returned `Worksheet.max_row` and `max_column` as `None`, so `min(sheet.max_row, 8)` raised exactly `TypeError: '<' not supported between instances of 'int' and 'NoneType'`; a later pipeline run failed at `pipeline.py:292` with exactly `IndexError: tuple index out of range` on `row[5]`
**verified:** 2026-10-05, re-reading the current 14,303-byte workbook yielded 194 tuples from row 7, including 148 tuples of length 5 beginning at worksheet row 53; `pipeline.py` now skips `len(row) < 6`, and bundled Python completed `Ran 21 tests in 1.168s` with `OK`
**verified:** 2026-10-05, a separate bundled-Python status comprehension also indexed `r[5]` without checking row length and failed with exactly `IndexError: list index out of range` on the workbook's shorter trailing note rows
**verified:** 2026-10-05 at about 9:12 pm Pacific, iterating `ws.iter_rows(min_row=8, values_only=True)` and unpacking application columns raised exactly `ValueError: not enough values to unpack (expected at least 6, got 5)` on a short row; 2026-10-05 at about 9:20 pm Pacific, another read-only load returned `max_row` and `max_column` as `None`, so `min(ws.max_row, 5)` raised exactly `TypeError: '<' not supported between instances of 'int' and 'NoneType'`
**where:** one `Applications` worksheet and openpyxl read-only subject in `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The short tuples begin immediately after the visible A1:J52 range, but the reason openpyxl emitted them is UNCONFIRMED.

**Why:** REJECT after three positional-read failures and two dimension failures from one workbook subject; there are not five observations from five different subjects.
**Fix:** pass `max_col=10` when ten application columns are required, guard row length before every optional positional read, and avoid `max_row` or `max_column` arithmetic in read-only mode unless the values are non-`None`; load normally for dimension-sensitive inspection or verify `calculate_dimension(force=True)` before relying on it.

### `codex-primary-runtime/node/bin/node` was absent; `dependencies/node/bin/node` ran Node v24.19.0

**verified:** 2026-10-06, invoking `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/node/bin/node` for an Artifact Tool read script returned exactly `zsh:1: no such file or directory`; a fresh check found that path absent, found `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node` executable at 121,306,800 bytes, and its `--version` printed `v24.19.0`
**where:** one bundled workspace Node executable lookup on macOS

The failed path inferred a runtime layout and omitted the verified `dependencies` component.

**Why:** REJECT at n=1 from one runtime bundle and executable-path subject; there are not five observations from five different subjects.
**Fix:** call `load_workspace_dependencies`, use its reported Node executable, and require that exact path to be executable and return a nonempty version before running the script.

### Bundled `bin/fallback` lacked `pdfinfo` and `pdftoppm`; `bin/override` resolved Poppler 26.05.0 at n=1

**verified:** 2026-10-05, `load_workspace_dependencies` listed `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/bin/fallback` as the fallback binary directory; direct calls to its `pdfinfo` and `pdftoppm` paths each returned exactly `no such file or directory`, while `command -v pdfinfo` and `command -v pdftoppm` resolved both under `dependencies/bin/override` and each reported version 26.05.0
**where:** one Codex workspace dependency bundle on macOS

The fallback directory was available but did not contain these two Poppler programs; the reason for that layout is UNCONFIRMED.

**Why:** REJECT at n=1 from one bundle and machine subject; there are not five observations from five different subjects.
**Fix:** resolve `pdfinfo` and `pdftoppm` with `command -v` before calling them, then run the returned paths and verify their real version or output.

### artifact-tool copy operations lost formatting, retained merges, or corrupted overlapping sources on 7 observations from one workbook

**verified:** 2026-10-02, `copyFrom(..., "all")` on an imported workbook did not transfer formatting into blank tracker rows, and overlapping `copyFrom` from `A36:J39` to `A39:J42` overwrote the last source row; writing explicit values, unmerging the destination, and applying formatting directly produced the intended workbook; 2026-10-05, overlapping `A43:J46.copyTo(A46:J49, "all")` propagated the changed source during the copy, and the render showed row 49 duplicated `Take-home estimate assumptions` instead of preserving the original tax-basis row
**verified:** 2026-10-05, overlapping `A49:J52.copyTo(A50:J53, "all")` on four individually merged rows made all four destination rows contain `Take-home estimate assumptions`, replacing the three distinct body rows
**verified:** 2026-10-05, overlapping `copyFrom(A51:J54 -> A54:J57, "all")` corrupted the last copied note row; its copied formats also retained existing A:J merges in the destination, so inspection contained written B:J values while the render hid them
**verified:** 2026-10-06, after `table.rows.add` extended the imported table, overlapping destination `A67:J70.copyFrom(A66:J69, "all")` replaced the four distinct source note rows with `Take-home estimate assumptions` in all four destination rows on inspection
**where:** one imported tracker workbook edited with artifact-tool

The evidence establishes all seven copy results in this workbook but does not establish their cause or behavior in other workbooks.

**Why:** REJECT after seven observations from one workbook subject; there are not five observations from five different subjects.
**Fix:** read source values into a JavaScript matrix before mutation and write that matrix to the shifted destination; copy formatting only from non-overlapping template rows or reconstruct it, explicitly unmerge target rows with `sheet.unmergeCells`, then inspect values and render every affected column.

### Git SSH operations failed 4 times and HTTPS push failed 3 times across 2 sessions, then unchanged SSH retries succeeded

**verified:** 2026-10-05 at 4:58 pm Pacific, two `git push origin development` attempts returned exactly `git@github.com: Permission denied (publickey)` while `ssh-add -l` listed one ED25519 key; three HTTPS push attempts, including one forced to HTTP/1.1, reached `github.com` but were rejected with exactly `remote: Internal Server Error`
**verified:** 2026-10-05, HTTPS `git ls-remote` successfully returned development at `15c0988`, while GitHub's public status API returned `indicator: none` and `All Systems Operational`
**verified:** 2026-10-05, a later identical `git push origin development` succeeded without a configuration change and advanced the remote from `15c0988` to `3d2ea69`
**verified:** 2026-10-06, two unchanged `git fetch origin` attempts returned exactly `git@github.com: Permission denied (publickey)` while HTTPS `git ls-remote` returned development, staging, and main; a later SSH push advanced development from `3c06ee6` to `454c2da`, and the following unchanged SSH fetch succeeded and resolved origin/development to `454c2da`
**where:** two `/Users/zayah/github/dotfiles` Git transport sessions

The failures and later recoveries establish transient SSH and HTTPS walls in these sessions, but their cause is UNCONFIRMED.

**Why:** REJECT at n=2 sessions from one repository and authentication environment subject; there are not five observations from five different subjects.
**Fix:** retry the same scoped SSH fetch or push after the credential path recovers, then require the exact fetched SHA or pushed remote ref range before promotion; both unchanged SSH recoveries are verified.

### `mark_artifact_operation_started.mjs` rejected `docx,pdf`; the single-DOCX marker exited 0 and produced 37,821-byte DOCX plus 67,804-byte PDF

**verified:** 2026-10-05, running `mark_artifact_operation_started.mjs` with no arguments exited 1 and printed exactly `usage: mark_artifact_operation_started.mjs --operation-kind <create|edit> --expected-output-count <1-100> --output-format <supported format>`
**verified:** 2026-10-05, `mark_artifact_operation_started.mjs --operation-kind create --expected-output-count 2 --output-format docx,pdf` failed and printed only the same usage text; the combined comma-separated output-format token was not accepted
**verified:** 2026-10-05, `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node /Users/zayah/.codex/plugins/cache/openai-primary-runtime/documents/26.905.11957/container_tools/mark_artifact_operation_started.mjs --operation-kind create --expected-output-count 1 --output-format docx` exited 0 with no output, followed by successful creation of a 37,821-byte DOCX and a 67,804-byte rendered PDF
**where:** spreadsheet and document artifact marker invocations from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The two failures show that the marker requires all named arguments and did not accept two formats encoded as one comma-separated value.

**Why:** REJECT at n=2 from two marker invocation subjects; there are not five observations from five different subjects.
**Fix:** for a document authoring operation, mark the authored file with `--operation-kind create --expected-output-count 1 --output-format docx`, require exit 0, and treat the rendered PDF as renderer output; this sequence is verified by the two nonempty artifacts.

### `@oai/artifact-tool` import failed in 6 bundled-Node setups; a local symlink produced 1,426 bytes

**verified:** 2026-09-29, bundled Node v24.19.0 run with `--input-type=module -e` from `/Users/zayah/Documents/Codex/2026-09-29/job-applications` exited 1 with `ERR_MODULE_NOT_FOUND: Cannot find package '@oai/artifact-tool'`; `import.meta.resolve` from the sibling `work` directory resolved `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs`
**verified:** 2026-10-05, importing `@oai/artifact-tool` returned `ERR_MODULE_NOT_FOUND` when `node_modules` was symlinked to missing `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/node_modules`; the package existed under `dependencies/node/node_modules/@oai/artifact-tool`
**verified:** 2026-10-05, a temporary directory whose `node_modules` symlink targeted `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules` imported the package and printed 1,175 exports; importing its absolute `dist/artifact_tool.mjs` printed the same count
**verified:** 2026-10-05, a spreadsheet artifact script run with the bundled Node binary failed with `ERR_MODULE_NOT_FOUND` for `@oai/artifact-tool` because its working directory had no conversation-specific `node_modules` link to the bundled dependencies
**verified:** 2026-10-06, a builder under `job-pipeline/work/heartbeat-2026-10-06-0014` returned `ERR_MODULE_NOT_FOUND` for `@oai/artifact-tool` even with `ARTIFACT_TOOL_NODE_MODULES` set; only the prior work directory had a script-directory `node_modules` symlink to the bundled `dependencies/node/node_modules`
**verified:** 2026-10-06, `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node job-pipeline/work/heartbeat-2026-10-06-0124/inspect_peopleready.mjs` returned `Error [ERR_MODULE_NOT_FOUND]: Cannot find package '@oai/artifact-tool' imported from .../inspect_peopleready.mjs`; the script directory had no `node_modules`
**verified:** 2026-10-06, copying the same script to a temporary directory with `node_modules` symlinked to `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules` made the bundled Node command exit 0 and produce 1,426 bytes of expected PeopleReady tracker JSON
**verified:** 2026-10-06, bundled Node v24.19.0 running a workspace `.mjs` with `NODE_PATH=/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules` still returned `ERR_MODULE_NOT_FOUND: Cannot find package '@oai/artifact-tool'` and suggested its `dist/artifact_tool.mjs` entry; this one failure was reported twice
**where:** six failed spreadsheet import setups and three successful recovery probes on this machine

Bare-package resolution failed from eval or script-directory contexts without the correct local symlink and from a symlink whose target did not exist; setting `ARTIFACT_TOOL_NODE_MODULES` did not change the observed ESM lookup, while both recovery paths resolved the package's actual runtime location.

**Why:** still held back after six failed setups from one machine and package subject because no untouched control was measured; the subject count alone does not pass the causal bar.
**Fix:** symlink the script's conversation-specific `node_modules` to `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules`, or import `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs` directly; both recovery paths are verified. The third recurrence requires a preflight that verifies the symlink target and a real package import before running the artifact script; that check remains UNCONFIRMED until built and exercised.

### `2026-10-05T18:20:29-07:00` rendered as `10/06/26 1:20 AM`; UTC wall-clock components rendered `10/05/26 6:20 PM`

**verified:** 2026-10-05, artifact-tool wrote `new Date('2026-10-05T18:20:29-07:00')` and the XLSX displayed `10/06/26 1:20 AM`; writing `new Date('2026-10-05T18:20:29Z')` displayed the intended `10/05/26 6:20 PM`
**where:** one date-cell edit in an artifact-tool XLSX workflow

The paired display values establish that this workbook used the serialized UTC components as an Excel wall-clock value, but not a universal rule for every spreadsheet engine.

**Why:** REJECT at n=1 from one workbook and runtime subject; there are not five observations from five different subjects.
**Fix:** treat Excel serials as timezone-free wall-clock values and encode the intended displayed components in UTC, then render the formatted cell and verify its exact date and time.

### `pipeline.py` without `run` exited 2 with `the following arguments are required: command` at n=3

**verified:** 2026-10-05, `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 job-pipeline/pipeline.py` exited 2 and printed `usage: pipeline.py [-h] {run} ...` followed by exactly `pipeline.py: error: the following arguments are required: command`; the same bundled runtime with `pipeline.py run` had already completed successfully and printed pipeline counts
**verified:** 2026-10-06, after selecting the bundled Python runtime, invoking `pipeline.py` without `run` again returned exactly `error: the following arguments are required: command`; the same bundled runtime passed the separate 24-test invocation
**verified:** 2026-10-06 at about 3:25 am Pacific, bundled Python invoked as `job-pipeline/pipeline.py` without a subcommand returned nonempty stderr containing `usage: pipeline.py [-h] {run} ...` and exactly `error: the following arguments are required: command`
**where:** three job-pipeline CLI invocations from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The nonempty parser stderr establishes that no pipeline run occurred; exit code alone is not execution proof.

**Why:** REJECT at n=3 from one CLI parser subject; there are not five observations from five different subjects.
**Fix:** invoke `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 job-pipeline/pipeline.py run`, then require exit 0 and inspect the printed counts.

### 5 jq root-shape assumptions failed on object `source-log.json` and array `job-pool.json` across 2 files

**verified:** 2026-10-05, `jq '.[-12:]' job-pipeline/state/source-log.json` failed with exactly `jq: error (at job-pipeline/state/source-log.json:860): Cannot index object with object ({"start":-12,"end":null})`; the file root had keys `last_run` and `checked_domains`, and `jq '.checked_domains[-12:]' job-pipeline/state/source-log.json` returned the latest 12 source-log entries
**verified:** 2026-10-05, `jq '{generated_at,total:(.jobs|length), keys:(.jobs[0]|keys), first:.jobs[0]}' job-pipeline/state/job-pool.json` failed at line 5239 with exactly `Cannot index array with string ("generated_at")`; inspection verified that the root was an array, and `jq '{total:length, keys:(.[0]|keys), first:.[0]}'` was the matching root-level query
**verified:** 2026-10-06, `jq '.[-4:]' job-pipeline/state/source-log.json` failed with `Cannot index object with object ({"start":-4,"end":null})`; the earlier verified root keys were `last_run` and `checked_domains`, not `entries`
**verified:** 2026-10-06, `jq 'length, .[-2:]' job-pipeline/state/source-log.json` failed with `Cannot index object with object ({"start":-2,"end":null})` because the source-log root is an object
**verified:** 2026-10-06, `jq '.[-8:]' job-pipeline/state/source-log.json` failed with `Cannot index object with object ({"start":-8,"end":null})`; this was one command reported twice, and the verified nested array remains `checked_domains`
**where:** five jq commands against `job-pipeline/state/source-log.json` and `job-pipeline/state/job-pool.json` under `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The two files use different root shapes, so neither an object-key assumption nor an array-root assumption transfers between them; the source-log array field remains `checked_domains` in the verified inspection.

**Why:** still held back at n=5 command observations across two JSON file and schema subjects because no untouched control was measured; the command count alone does not pass the causal bar.
**Fix:** inspect the root type and keys first; use `jq '.checked_domains[-2:]'` for the requested object-root source-log slice and `jq '{total:length, keys:(.[0]|keys), first:.[0]}'` for the array-root job pool, then require nonempty expected output.

### Direct `web__run` input returned `Script error: SyntaxError: Unexpected string`; object assignment succeeded at n=1

**verified:** 2026-10-05, a `functions.exec` call containing a direct `web__run` request failed with exactly `Script error: SyntaxError: Unexpected string` and returned zero results; retrying as `const args={search_query:[...],response_length:"long"}; await tools.web__run(args);` succeeded
**where:** one hourly-application-questions heartbeat web-search input

The first JavaScript input failed before the web request could return results, while the explicit object binding produced a valid tool call in the same workflow.

**Why:** REJECT at n=1 from one exec-input subject; there are not five observations from five different subjects.
**Fix:** assign the web request to a JavaScript object before calling `await tools.web__run(args)`, then require nonempty returned content before accepting the search.

### Artifact marker paths were missing in 4 lookups across 2 skills; skill-cache paths existed

**verified:** 2026-10-03, `ls -l container_tools/mark_artifact_operation_started.mjs` returned `No such file or directory`, while `rg --files /Users/zayah/.codex /Users/zayah/.cache/codex-runtimes | rg '/mark_artifact_operation_started\.mjs$'` found `/Users/zayah/.codex/plugins/cache/openai-primary-runtime/pdf/26.905.11957/skills/pdf/container_tools/mark_artifact_operation_started.mjs` and the runtime-cache equivalent
**verified:** 2026-10-05, the Spreadsheets skill requested `node container_tools/mark_artifact_operation_started.mjs ...`, but `ls` on `/Users/zayah/.codex/plugins/cache/openai-primary-runtime/spreadsheets/26.905.11957/container_tools` returned exactly `No such file or directory`; `rg --files` found the marker at `/Users/zayah/.codex/plugins/cache/openai-primary-runtime/spreadsheets/26.905.11957/skills/spreadsheets/container_tools/mark_artifact_operation_started.mjs` and the runtime-cache equivalent
**verified:** 2026-10-05 at about 10:00 pm Pacific, the required runtime Node invocation of `/Users/zayah/.codex/plugins/cache/openai-primary-runtime/spreadsheets/26.905.11957/container_tools/mark_artifact_operation_started.mjs` exited 1 with `MODULE_NOT_FOUND`; the deployed `/Users/zayah/.codex/plugins/cache/openai-primary-runtime/spreadsheets/26.905.11957/skills/spreadsheets/container_tools/mark_artifact_operation_started.mjs` existed at 743 bytes, and invoking it with the same runtime reached the script and printed its usage line
**verified:** 2026-10-06, the same Spreadsheets plugin-root marker path under `spreadsheets/26.905.11957/container_tools/` again failed under Node v24.19.0 with `MODULE_NOT_FOUND`; the deployed skill-cache path remained the verified recovery
**where:** four PDF and Spreadsheets skill marker lookups from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The workspace-relative and spreadsheet plugin-root paths were absent, while skill-specific cache searches returned the marker files.

**Why:** REJECT at n=4 lookups across two skill-path subjects; there are not five observations from five different subjects.
**Fix:** invoke the verified Spreadsheets marker at `/Users/zayah/.codex/plugins/cache/openai-primary-runtime/spreadsheets/26.905.11957/skills/spreadsheets/container_tools/mark_artifact_operation_started.mjs`; the third recurrence requires an automated preflight that resolves the marker with `rg --files` and rejects an absent workspace or plugin-root guess, which remains UNCONFIRMED until built and exercised.

### `zsh:1: command not found: python` at n=2

**verified:** 2026-10-04 at 10:21 am Pacific, `python - <<'PY'` returned exactly `zsh:1: command not found: python`
**verified:** 2026-10-05 at about 8:00 pm Pacific, another `python - <<'PY'` invocation returned exactly `zsh:1: command not found: python`, exited 127, while `command -v python3` resolved `/opt/homebrew/bin/python3` and the bundled Python reported version 3.12.14
**where:** two source-inspection commands in `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The shell did not expose a command named `python` in either invocation.

**Why:** REJECT at n=2 from one machine environment subject; there are not five observations from five different subjects.
**Fix:** use `python3` or `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3`, select the runtime that contains the required dependency, and verify the replacement command's real output.

### System Python `ModuleNotFoundError: No module named 'openpyxl'`; bundled Python imported openpyxl 3.1.5 at n=2

**verified:** 2026-10-02, system `python3` failed with exactly `ModuleNotFoundError: No module named 'openpyxl'`, while `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3` successfully imported `openpyxl` and read the tracker
**verified:** 2026-10-05, system `python3` again failed with exactly `ModuleNotFoundError: No module named 'openpyxl'` and exited 1 in the same workspace; the bundled Python imported openpyxl and printed version 3.1.5
**where:** two spreadsheet-inspection invocations in `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The paired checks establish package availability only for these Python runtimes on this machine and dates.

**Why:** REJECT at n=2 from one environment subject; there are not five observations from five different subjects.
**Fix:** use `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3` for `openpyxl` tracker reads in this workspace, or inspect the workbook through artifact-tool, and require nonempty output from the chosen route.

### Spreadsheet plugin Python path was absent on 2 commands; workspace Python 3.12.14 imported `docx` 1.2.0 and `openpyxl` 3.1.5

**verified:** 2026-10-06, `/Users/zayah/.codex/plugins/cache/openai-primary-runtime/spreadsheets/26.905.11957/python/bin/python3 pipeline.py run` and the same executable path running unittest each exited 127 with exactly `zsh:1: no such file or directory: /Users/zayah/.codex/plugins/cache/openai-primary-runtime/spreadsheets/26.905.11957/python/bin/python3`
**verified:** 2026-10-06, the verified workspace runtime `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3` resolved to Python 3.12.14 and imported `docx` 1.2.0 plus `openpyxl` 3.1.5
**where:** two job-pipeline commands using one inferred Spreadsheets plugin Python path, plus one workspace-runtime verification

Neither failed command started Python, the pipeline, or unittest; the nonzero shell result and stderr are path-resolution evidence, not test results.

**Why:** REJECT at n=2 commands from one guessed runtime-layout subject; there are not five observations from five different subjects.
**Fix:** use `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3`, then run `pipeline.py run` and the repository's actual tests and require their real nonempty output.

### Saved tabs 133, 114, 160, and 249 failed across 4 heartbeat subjects

**verified:** 2026-10-04, calling `markHandoff` on a saved CUA tab from an earlier heartbeat returned exactly `Tab 133 is not part of browser session 01a0ef86-6745-7363-848e-8d443ce640fc` and stopped the loop while the JavaScript binding persisted; later that date, waiting on Gmail's Refresh button through saved binding `mailTab` returned exactly `Error: Tab 114 is not part of browser session 01a0ef86-6745-7363-848e-8d443ce640fc`
**verified:** 2026-10-05 at the 10:38 am Pacific heartbeat, reusing prior-turn Gmail handle `gmailCheck` for `goto(...)` returned exactly `Tab 160 is not part of browser session 01a0ef86-6745-7363-848e-8d443ce640fc` and changed no external state; the agent-created tab had not been marked for handoff before the earlier turn ended
**verified:** 2026-10-05 at about 9:16 pm Pacific, `await cua.getTab("249", {browser:"iab"})` returned exactly `Tab not found in browser 2` on the heartbeat after tab 249 had been valid
**where:** four saved IAB tab handles across heartbeat and browser-session state

The retained objects show that a JavaScript binding or `typeof` existence guard did not prove that a tab still belonged to the current browser session.

**Why:** REJECT at n=4 from four tab subjects in one browser-session context; there are not five observations from five different subjects, and one unmarked tab does not establish the general survival cause.
**Fix:** UNCONFIRMED; call `cua.getState()` at the start of a new heartbeat to rediscover current tabs, then reacquire by current URL or ID or create a fresh tab before using a saved binding; mark an agent-created tab for handoff before ending the turn only after that path is verified on a current tab.

### Home Depot resume PDF retained the title `Pacific Reign Gymnastics Front Desk Staff` at n=1

**verified:** 2026-10-06, `pdfinfo` on a newly rendered Home Depot resume reported Title `Zayah Nelson resume for Pacific Reign Gymnastics Front Desk Staff`, while visual rendering showed the new Home Depot resume content
**where:** one resume created by editing a prior DOCX and rendering it to PDF

The visible page and PDF core metadata disagreed; whether every reused DOCX retains the prior title is UNCONFIRMED.

**Why:** REJECT at n=1 from one reused document and PDF subject; there are not five observations from five different subjects.
**Fix:** UNCONFIRMED; set `document.core_properties.title` and the other relevant core properties before saving, re-render the PDF, and require `pdfinfo` to report the new title.

### `pdftotext` was missing on 18 attempts across 5 dates; 3 other PDF text routes were unavailable in one environment

**verified:** 2026-09-29, system `pdftotext` returned exactly `zsh: command not found: pdftotext`, system `python3` failed to import `pypdf` with `ModuleNotFoundError`, and direct `firecrawl` returned `command not found`; `npx firecrawl-cli parse` installed `firecrawl-cli@1.24.6` and produced 2,344 bytes of expected resume text; 2026-10-02, `from pypdf import PdfReader` returned exactly `ModuleNotFoundError: No module named 'pypdf'`, and `mdls -name kMDItemTextContent` returned null for the resume PDFs; 2026-10-03, six separate read-only resume extraction attempts, including `outputs/office-operations/Zayah Nelson - Office Operations resume.pdf` and a 3,565-byte IT Support resume whose `pdfinfo` showed one letter-size page, each returned exactly `zsh:1: command not found: pdftotext`, and a fresh `command -v pdftotext` exited 1; 2026-10-04, three earlier resume checks returned `command not found: pdftotext`, including Office Operations and Palm Springs Guest Service files, and a fresh `command -v pdftotext` exited 1; at 5:29 pm Pacific, another Office Operations check returned exactly `zsh:1: command not found: pdftotext`, `mdls -raw -name kMDItemTextContent` returned exactly `(null)`, and the adjacent `build_resume.py` supplied the usable source text
**verified:** 2026-10-04, `/Users/zayah/Documents/Codex/2026-09-29/job-applications/outputs/office-operations/Zayah Nelson - Office Operations resume.pdf` existed at 65,337 bytes while its `pdftotext` inspection returned exactly `zsh:1: command not found: pdftotext`; this enriches an already counted Office Operations attempt and does not increase n
**verified:** 2026-10-04, system `python3` in the same workspace failed to import pypdf with exactly `ModuleNotFoundError: No module named 'pypdf'`; this is a new date for the already counted unavailable pypdf route, not a new environment subject
**verified:** 2026-10-05, `pdftotext 'outputs/office-operations/Zayah Nelson - Office Operations resume.pdf' -` returned exactly `zsh:1: command not found: pdftotext` from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`
**verified:** 2026-10-05 at 9:42 am Pacific, three local-resume inspection invocations returned exactly `zsh: command not found: pdftotext`; counting conservatively, this batch adds two net attempts because one October 5 Office Operations invocation was already recorded
**verified:** 2026-10-05, two generated-resume verification attempts returned exactly `zsh:1: command not found: pdftotext`, while `pdfinfo` was available and confirmed both outputs were valid one-page tagged PDFs
**verified:** 2026-10-05, another PDF text check in the job-applications environment returned exactly `zsh: command not found: pdftotext`; the bundled Python runtime with pypdf remained the available extraction route
**verified:** 2026-10-06, `pdfinfo` was available for resume QA while `pdftotext` again returned `command not found: pdftotext`; the bundled Python runtime with pypdf remained the selected extraction route
**where:** `/Users/zayah/Documents/Codex/2026-09-29/job-applications`, PDF resume inspection in one macOS zsh environment

The eighteen `pdftotext` failures establish that the default shell PATH did not provide the command in one environment but do not establish whether the binary is absent elsewhere on the machine; different PDF paths do not provide independent environment subjects.

**Why:** still held back after eighteen `pdftotext` attempts and three other unavailable routes in one environment; there are not five observations from five different environment subjects.
**Fix:** read the artifact's source script when present, or use `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3` with pypdf and require non-empty expected text.

### Git commands exited 128 with `fatal: not a git repository` across 3 job-workspace sessions

**verified:** 2026-10-05, from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`, both `git status` and `git log -- outputs/job-application-tracker.xlsx` exited 128 and printed exactly `fatal: not a git repository (or any of the parent directories): .git`
**verified:** 2026-10-06, a library verification command accidentally ran `git fetch origin` and `git show origin/development:library/testing.md` from the same job-applications directory, and both returned the same exact `fatal: not a git repository` error
**verified:** 2026-10-06 at 5:25 am Pacific, `git status --short` from the same directory returned exactly `fatal: not a git repository (or any of the parent directories): .git`; a current comparison repeated that error while `git -C /Users/zayah/github/dotfiles rev-parse --show-toplevel` printed `/Users/zayah/github/dotfiles`
**where:** three command sessions in one non-Git job-applications workspace

Git history cannot recover earlier tracker rows from this directory because the workspace is not inside a Git repository.

**Why:** REJECT at n=3 command sessions from one workspace subject; there are not five observations from five different subjects.
**Fix:** check the target with `git -C <candidate> rev-parse --show-toplevel` before applying commit or promotion rules, then run repository commands through `git -C` against the returned root. For tracker recovery, inspect the current workbook, source log, generated artifacts, and explicit backups instead of relying on Git history; do not initialize a repository as a recovery shortcut. A reusable preflight guard remains UNCONFIRMED until built and exercised.

### DesignFiles was absent from Applications A7:J59 while source log recorded tracker sync and a 67,781-byte resume at n=1

**verified:** 2026-10-05, the current `Applications` range `A7:J59` contained no DesignFiles row, while `source-log.json` at 8:43 pm Pacific recorded that DesignFiles was added and tracker sync succeeded; the exact DesignFiles resume PDF existed at 67,781 bytes
**where:** one `outputs/job-application-tracker.xlsx` state, its source log, and its generated resume artifact

The missing current row and surviving log and artifact establish tracker data loss; whether a later updater's fixed footer rows 57:60 or hard-coded nearby shifts caused this loss is UNCONFIRMED.

**Why:** REJECT at n=1 from one missing-row and workbook subject; there are not five observations from five different subjects.
**Fix:** UNCONFIRMED; replace fixed-row footer reconstruction with one dynamic append-before-footer helper, compare the company and role key set before and after every edit, refuse to save if an existing application key disappears, and render the affected boundary rows before accepting the workbook.

### TJX Workday `Decline` matched 1 visible enabled button but timed out in `Input.dispatchMouseEvent` at n=1

**verified:** 2026-10-05 at about 10:27 pm Pacific, Playwright on TJX in-app-browser tab 260 found the cookie `Decline` button with `matchCount 1`, `visibleCount 1`, and `disabled false`, but its click timed out in CDP `Input.dispatchMouseEvent`
**where:** one TJX Workday cookie-banner interaction through unified computer use

The locator diagnostics establish that the control was matched, visible, and enabled before the input-dispatch timeout, but do not establish why CDP could not complete the click.

**Why:** REJECT at n=1 from one page and interaction subject; there are not five observations from five different subjects.
**Fix:** UNCONFIRMED; confirm the page still responds with a fresh state read, then use the current accessibility element ID for one direct click and verify that the cookie banner disappears before continuing.
