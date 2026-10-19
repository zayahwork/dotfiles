# testing

Test and build command failures whose real cause was the invocation or execution
environment rather than the source under test.

## Contents

- [Relative test paths follow the runner working directory, including `unittest discover -s tests`.](#relative-test-paths-follow-the-runner-working-directory-including-unittest-discover--s-tests)
- [`getaddrinfo ENOTFOUND` and `curl: (6) Could not resolve host` are sandbox DNS boundaries when unchanged commands pass with approved network access.](#getaddrinfo-enotfound-and-curl-6-could-not-resolve-host-are-sandbox-dns-boundaries-when-unchanged-commands-pass-with-approved-network-access)
- [Held back: source-path and artifact marker arguments, Codex dependency-loader and runtime paths, pipeline partial-source timeouts, tracker count and idempotency bounds, missing PDF fallback paths, Python runtime and python-docx enum imports, dynamic-import and test-runner walls, jq shape, syntax, and row normalization, openpyxl dimensions and short rows, artifact-tool date, row, and copy behavior, Git push and revision-flag failures, patch-context and patch-format, loopback-bind, Chrome reload/navigation, browser creation, and Computer Use API walls.](#held-back)

---

## Relative test paths follow the runner working directory, including unittest discover -s tests

**verified:** 2026-09-20, from Cove's `source/cove-crm`, `node --test ../../../tests/sample-desk.test.ts` exited 1 with `Could not find`, while `node --test ../../tests/sample-desk.test.ts` exited 0 with `tests 1`, `pass 1`, and `fail 0`; 2026-09-22, from the MemeCoin monorepo root, `npm test -- --run packages/core/test/paper-strategy.test.ts` exited 1 after npm changed cwd to `packages/core`, and Vitest printed `No test files found`
**verified:** 2026-10-07, `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 -m unittest discover -s tests -v` from a dotfiles promotion worktree failed with `ImportError: Start directory is not importable: 'tests'`; the unchanged command from `/Users/zayah/Documents/Codex/2026-09-29/job-applications/job-pipeline` ran all 24 tests in 1.327 seconds and printed `OK`
**where:** `Home/09 🏗️ Builds/Nate Pool Studio/source/cove-crm`; `/private/tmp/memecoin-standalone-20260922`; `/Users/zayah/Documents/Codex/2026-09-29/job-applications/job-pipeline`

Relative test filters are resolved from the runner's actual working directory, including a workspace cwd selected by npm, not necessarily from the repository root where the outer command began.

**Why:** all three failing paths were calculated from the repository layout instead of the cwd used by the test runner.
**Fix:** calculate relative test paths from the runner cwd. For this job pipeline, run the bundled Python command from `job-pipeline`, or pass an absolute discovery start directory; for Cove use `../../tests/sample-desk.test.ts`, and for MemeCoin use `test/paper-strategy.test.ts` inside its package workspace.

---

## getaddrinfo ENOTFOUND and curl: (6) Could not resolve host are sandbox DNS boundaries when unchanged commands pass with approved network access

**verified:** 2026-09-20, sandboxed `npm run build` failed on `getaddrinfo ENOTFOUND fonts.googleapis.com` and the unchanged command completed the Next.js 15.5.25 build with approved network access; 2026-09-22, sandboxed `curl --max-time 20 --show-error --include https://r.jina.ai/https://pump.fun/` failed immediately with `curl: (6) Could not resolve host: r.jina.ai`, while the identical escalated command returned HTTP/2 200 and 26,172 decompressed bytes; 2026-09-22, three parallel `curl --max-time 20 --show-error` reads of `https://docs.typesafe.ai/llms.txt`, `/patterns/composite-scoring.md`, and `/confidence.md` each failed immediately with `curl: (6) Could not resolve host: docs.typesafe.ai`, then identical escalated reads succeeded with 16,019, 13,545, and 11,396 bytes respectively; 2026-09-22, sandboxed `curl -sS --max-time 20 https://r.jina.ai/https://docs.typesafe.ai/llms.txt` failed immediately with `curl: (6) Could not resolve host: r.jina.ai` during TypeSafe indicator work, while the exact escalated read returned the current `llms.txt` index in 4.3 seconds, four targeted composite-scoring, citation-checking, confidence, and primitives reads completed in 23.7 seconds, and a filtered citation/confidence read completed in 5.2 seconds
**where:** `Home/09 🏗️ Builds/Nate Pool Studio/source/cove-crm`; `/Users/zayah/Downloads/home-main`

Build-time font fetching and read-only Jina fetching both require DNS, so a sandbox network boundary can fail before source or target-page behavior is evaluated.

**Why:** in every completed comparison pair, the identical command passed when only network authority changed, isolating the failure to the sandbox boundary.
**Fix:** rerun the identical read-only command with approved network access; investigate the source or endpoint only if that rerun still fails.

---

## Held back

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

### App `getState()` was not a function in 2 Chrome sessions; `getAXState({disableDiffing:true})` recovered one

**verified:** 2026-09-22, after task compaction `chromeApp.getState()` failed because the App surface exposes `getAXState()`; `cua.rewriteDocumentation()` restored the API reference and `chromeApp.getAXState({disableDiffing:true})` returned the live Padre state
**verified:** 2026-10-06, in a persistent CUA session, `let app = await cua.getApp("Google Chrome")` returned an App binding and `await app.getState()` then returned exactly `app.getState is not a function`; the proposed documentation refresh and replacement call were not supplied, so recovery in this session is UNCONFIRMED
**where:** two Computer Use sessions controlling Google Chrome through an App surface

Both failures were App API-method mismatches, not evidence that the Chrome surface had disappeared.

**Why:** still held back at n=2 from two session subjects; there are not five observations from five different subjects.
**Fix:** call `cua.rewriteDocumentation()` after a compacted Computer Use task, then use the documented App method `getAXState()`.

### BrowserTab `act`, `getSnapshot`, `snapshot`, `fill`, `getState`, `domContentLoaded`, `waitForTimeout`, and `getByRole` were not functions on 29 calls from 7 documented tab subjects

**verified:** 2026-09-29, `cua.createBrowserTab("iab", URL, { visible: false })` returned tab 6 with a valid initial accessibility tree, then `simpleClosureTab.getSnapshot` returned exactly `simpleClosureTab.getSnapshot is not a function`; 2026-10-03, `trainerTab.fill` returned exactly `trainerTab.fill is not a function` during a 24 Hour Fitness application workflow; 2026-10-04, a tab returned by `cua.createBrowserTab` produced exactly `mailTab.getState is not a function` when a fresh Gmail snapshot was needed after waiting, an initialized cua_repl session returned exactly `mailTab.getSnapshot is not a function`, and after `cua.rewriteDocumentation()` listed `tab.playwright.domSnapshot()`, `nodeRepl.write(await mailTab.playwright.domSnapshot())` succeeded and returned the Gmail DOM snapshot; later that date, calling `tab.playwright.domContentLoaded()` on an IAB tab failed with an error ending exactly `is not a function`
**verified:** 2026-10-05, after filling Gmail search and pressing Enter, `gmailTab.waitForTimeout(1800)` returned exactly `waitForTimeout is not a function` before the requested DOM snapshot
**verified:** 2026-10-05, `await searchTab.waitForTimeout(1500)` returned exactly `searchTab.waitForTimeout is not a function` during a browser job-search workflow
**verified:** 2026-10-06, after navigation in an in-app browser tab, `searchTab.waitForTimeout(1500)` returned exactly `searchTab.waitForTimeout is not a function`; no page state changed through that failed call
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
**verified:** 2026-10-06 at 6:16 am Pacific, after `cua.createBrowserTab` returned a Gmail tab, `mailTab.getState()` returned exactly `mailTab.getState is not a function`; the already verified fresh-state methods are `getAXState({disableDiffing:true})` and `tab.playwright.domSnapshot()`, not `getSnapshot()`
**verified:** 2026-10-06, a bound Gmail Tab returned by `cua.createBrowserTab` produced exactly `mail.snapshot is not a function`; refreshed CUA documentation listed `getAXState()`, `getScreenshot()`, and `getAXStateAndScreenshot()` on the Target or Tab surface, and `await mail.getAXState({disableDiffing:true})` immediately succeeded with the Gmail accessibility tree
**verified:** 2026-10-11, during read-only Gmail work, `await tab.act({kind:"click", ref:"71"})` returned exactly `tab.act is not a function`; refreshed CUA documentation listed the direct `await tab.click(71)` form followed by `getAXState()`, or Playwright locators
**where:** seven unified-computer-use BrowserTab subjects across application, Gmail, job-search, and careers workflows

The returned tab objects did not expose those methods; direct accessibility actions use numeric snapshot indices, while `fill` and `getByRole` belong under the tab's Playwright interface.

**Why:** still held back after twenty-nine calls from seven documented tab subjects because no untouched control was measured; the subject count alone does not pass the causal bar.
**Fix:** after a summarized Computer Use task, call `cua.rewriteDocumentation()` before interacting. Wait with the verified JavaScript runtime form `await new Promise(resolve => setTimeout(resolve, ms))`; then use the observed `getAXState({disableDiffing:true})` for accessibility state or `tab.playwright.domSnapshot()` for a DOM snapshot, not `tab.snapshot()` or `tab.getSnapshot()`. Use `tab.click(elementIndex)` for a direct accessibility click, BrowserTab `setValue(elementIndex, value)` for direct accessibility input, or `tab.playwright.getByRole(...)` and `tab.playwright.locator(...)` for DOM selection; do not call `tab.act(...)`, and keep the Paycom, YMCA, and Home Depot recoveries UNCONFIRMED until run and visibly verified.

### 4 object-shaped BrowserTab clicks returned `Accessibility action requires an element index or point`; `click(index)` succeeded

**verified:** 2026-10-06 at about 9:00 am Pacific, `mailTab.click({ref:90})` returned exactly `Accessibility action requires an element index or point`; refreshed CUA documentation showed the positional element-index form, `mailTab.click(90)` succeeded, and the refreshed Gmail accessibility tree showed no change
**verified:** 2026-10-06, `gmailTab.click({ nodeId: 120 })` and `gmailTab.click({ index: 120 })` each returned exactly `Accessibility action requires an element index or point`; current CUA documentation specified `Target.click(target: number | Vec2, options?)`
**verified:** 2026-10-12, `tab.click({ref: 121})` in Gmail returned exactly `Accessibility action requires an element index or point`; the specific `tab.click(121)` retry was not supplied, while the earlier positional index 90 recovery remains verified
**where:** four object-shaped click calls across three Gmail accessibility interactions through unified-computer-use BrowserTab objects

The four rejected objects and one successful positional call show that accessibility snapshot numbers are passed as the numeric `target`, not under `ref`, `nodeId`, or `index`; coordinate behavior was documented but not exercised.

**Why:** still held back at n=4 calls from three Gmail interaction attempts in one BrowserTab environment; there are not five observations from five different subjects.
**Fix:** call `cua.rewriteDocumentation()`, pass the current accessibility element index directly as `tab.click(index)`, and refresh the accessibility state before reusing an index because the numbered tree can change. The general positional form is verified; the specific index 121 recovery remains UNCONFIRMED.

### Gmail `Back to Search Results` matched 1 visible enabled node but click returned `No node found at given location` at n=1

**verified:** 2026-10-11, `getByRole("button", {name:"Back to Search Results", exact:true})` matched exactly one visible enabled Gmail `div`, but `.click()` returned exactly `Error: No node found at given location`; `tab.back()` then recovered history navigation
**where:** one read-only Gmail search-results interaction through unified computer use

The diagnostics establish a live locator match before the click failure, but do not establish why the input target was unavailable when the click executed.

**Why:** REJECT at n=1 from one page and interaction subject; there are not five observations from five different subjects.
**Fix:** for this history-navigation control, use `tab.back()` after the exact click failure and refresh with `getAXState()` before continuing.

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

### `failed to start Node runtime: No such file or directory (os error 2)` on 2 documented CUA first actions

**verified:** 2026-10-05, the first documented `mcp__cua_repl.js` action `cua.getApp("Visual Studio Code")` failed with exactly `failed to start Node runtime: No such file or directory (os error 2)`; 2026-10-14, the first documented action `cua.createBrowserTab("iab", "https://servicetitan.wd1.myworkdayjobs.com/ServiceTitan/job/US-Remote/Sales-Development-Representative--Convex-_JR115010", { visible: true })` failed with the same exact error
**where:** two unified-computer-use initialization subjects across app selection and in-app browser creation on two dates

Both failures occurred before the requested app or browser surface could be inspected, but the missing Node runtime path and recovery route remain UNCONFIRMED.

**Why:** REJECT at n=2 from two first-action subjects; there are not five observations from five different subjects or a successful runtime control.
**Fix:** UNCONFIRMED for Browser automation; use public employer feeds and web reads only for fields they expose, and report UI-only fields as unavailable until a later CUA initialization succeeds.

### 4 hidden Gmail, FedEx, and GovernmentJobs `createBrowserTab` calls returned `Timed out waiting for the Browser webview to attach for this browser-use page`

**verified:** 2026-10-06, `cua.createBrowserTab("2", <Gmail search URL>, {visible:false})` returned exactly `Timed out waiting for the Browser webview to attach for this browser-use page`; the Gmail tab did not appear in the subsequent tab list, the selected in-app browser had no Gmail tab, and no Chrome or Edge browser was available
**verified:** 2026-10-07, `cua.createBrowserTab("iab", <Gmail all-categories application search URL>, {visible:false})` failed after 15.2 seconds with exactly `Timed out waiting for the Browser webview to attach for this browser-use page`
**verified:** 2026-10-07, `cua.createBrowserTab("iab", "https://fedex.paradox.ai/iKU18pZn", {visible:false})` returned exactly `Timed out waiting for the Browser webview to attach for this browser-use page`, blocking read-only reinspection of the FedEx application questions while the previously open Gmail reminder remained readable
**verified:** 2026-10-14, `cua.createBrowserTab("iab", "https://www.governmentjobs.com/jobs/5373106-0/recreation-leader-1", {visible:false})` returned the same exact timeout during a read-only City of SeaTac application-gate check; the following `cua.getState()` reported `Native apps: Error: The Mac is locked and automatic unlock could not unlock it. Ask the user to unlock the Mac manually before continuing.`, listed no browser, and no GovernmentJobs tab was created; a fresh reproduction returned `Browser is not available: iab`, and no application was submitted
**where:** four hidden tab-creation attempts across Gmail, FedEx, and GovernmentJobs destinations through unified computer use from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The failed attachments prove that none of the four attempts produced fresh destination state. The locked Mac and absent browser were verified blocking conditions on October 14, but whether either condition alone caused the earlier timeout is UNCONFIRMED.

**Why:** still held back at n=4 across three destination subjects in one browser-attachment environment; there are not five observations from five different subjects.
**Fix:** call `cua.getState()` before creating a tab. If it reports a locked Mac or no browser, stop and ask the user to unlock the Mac rather than retrying or bypassing the gate; otherwise treat the requested inspection as unavailable if attachment still times out. Preserve prior verified state, do not claim fresh application questions or inbox results, and retry only in a later browser-enabled run.

### 14 guessed, stale, wrong-cwd, or wrong-base local paths failed across 17 invocations; current paths found source, tracker, facts, test, counter, and skill targets

**verified:** 2026-09-22, `sed -n ... packages/core/src/rating.ts` failed in the MemeCoin repository, while `rg --files packages/core/src` listed the implementation as `packages/core/src/research-indicator.ts`
**verified:** 2026-10-06, `wc -c job-pipeline/application-tracker.csv` returned `No such file or directory`; `rg --files /Users/zayah/Documents/Codex/2026-09-29/job-applications | rg '(^|/)(application-tracker|job-application-tracker)\\.(csv|xlsx)$'` found only `outputs/job-application-tracker.xlsx`, and `wc -c` reported 17,517 bytes for that file
**verified:** 2026-10-06, `wc -c job-pipeline/output/application-tracker.xlsx` returned `No such file or directory`, and a later byte-count command against guessed filename `Zayah Nelson - Job Application Tracker.xlsx` returned `open: No such file or directory`; the verified tracker path remained `outputs/job-application-tracker.xlsx`
**verified:** 2026-10-06, a test-command lookup found neither `job-pipeline/package.json` nor `job-pipeline/scripts/`; `rg --files job-pipeline` instead returned `job-pipeline/tests/test_pipeline.py` and no package or scripts path
**verified:** 2026-10-06 at 5:24 am Pacific, Node failed with `MODULE_NOT_FOUND` for stale prior-turn path `job-pipeline/work/heartbeat-2026-10-06-0409/count_tracker.mjs`; a current `rg --files job-pipeline | rg '(^|/)count_tracker\.mjs$'` lookup later returned that path plus the `heartbeat-2026-10-05-2222` and `heartbeat-2026-10-06-0356` copies
**verified:** 2026-10-06, bundled Node in `job-pipeline/work/heartbeat-2026-10-06-0557` ran `FileBlob.load("outputs/job-application-tracker.xlsx")` and returned `ENOENT` with the eval stack rooted in that heartbeat directory; an isolated reproduction returned the same error, while loading `/Users/zayah/Documents/Codex/2026-09-29/job-applications/outputs/job-application-tracker.xlsx` from the same cwd printed `{"loaded":true,"size":null}`
**verified:** 2026-10-06, reading Firecrawl `SKILL.md` through mistyped plugin id `app-6a314a73f8ac8191b8b47dc98fe5a052` returned `No such file or directory`; the catalog path with id `app-6a314a73f8ac819195b0d55e36b9c609` existed at 3,181 bytes and was read successfully
**verified:** 2026-10-07, `wc` and `sed` reads of `workflows/edit_workflows.md`, `artifact_tool_docs/API_QUICK_START.md`, and `style_guidelines.md` under the Spreadsheets package parent `.../skills/` each returned `No such file or directory`; the references are relative to the directory containing `SKILL.md`, `.../skills/spreadsheets/`, where the three files existed at 2,481, 25,830, and 10,103 bytes, and `workspace-dependencies-fallback spreadsheets` verified all three
**verified:** 2026-10-12, `candidate-profile.json` referenced `.private/job-application-facts.json`, but resolving that path from the Job Pipeline directory and running `stat` returned exactly `No such file or directory`; a hidden-file search across `/Users/zayah/Documents/Codex` found the sole matching file at `/Users/zayah/Documents/Codex/life/.private/job-application-facts.json`, where `stat` reported 796 bytes and `jq` verified an object root without exposing its values
**verified:** 2026-10-19, the same profile still named `.private/job-application-facts.json`; `jq` on the pipeline-relative target returned `No such file or directory`, and a search limited to `/Users/zayah/Documents/Codex/life/01 💼 Jobs` found zero matches, while the broader `/Users/zayah/Documents/Codex/life` search found exactly one 796-byte object at `/Users/zayah/Documents/Codex/life/.private/job-application-facts.json`
**verified:** 2026-10-12, macOS accepted `/Users/zayah/.codex/plugins/cache/openai-primary-runtime/spreadsheets/26.905.11957/skills/Spreadsheets/SKILL.md`, but `realpath` returned the on-disk lowercase path ending in `skills/spreadsheets/SKILL.md`; resolving `workflows/edit_workflows.md` from the package parent returned exactly `No such file or directory`, while the canonical skill-relative path existed at 2,481 bytes
**verified:** 2026-10-16, from the authoritative Job Pipeline directory, `jq` on job-applications-relative path `outputs/hourly-application-questions/tracker-edit/brooks-blocker-fixed2/after.json` returned exactly `Could not open file ...: No such file or directory` and exited 2; the absolute path under `/Users/zayah/Documents/Codex/2026-09-29/job-applications` exited 0 and reported 199 application rows
**where:** seventeen failed reads of fourteen guessed, stale, wrong-cwd, mistyped, or wrong-base paths across nine local path-discovery subjects in the MemeCoin, job-applications, life job-pipeline, and Codex skill-cache trees

The failures used guessed concept paths, stale work paths, wrong cwd resolution, a retyped catalog identifier, or the parent of a relative-reference base; verified lookup paths resolved the intended files.

**Why:** still held back at n=17 failures from nine workspace and path subjects because no untouched population control was measured; the failure count alone does not pass the causal bar.
**Fix:** run `rg --files -uu` in the narrow source tree immediately before reading, measuring, or selecting a hidden file, script, or test command; resolve relative references against the canonical `realpath` directory containing the selected file instead of a case-insensitive alias, package parent, or current directory. Use an absolute cross-workspace path or run from the workspace that owns the relative path; for the facts file, use the verified `/Users/zayah/Documents/Codex/life/.private/job-application-facts.json` path, and for Spreadsheets use `/Users/zayah/github/dotfiles/home/bin/workspace-dependencies-fallback spreadsheets` to verify the lowercase skill root and edit references.

### `Applications!A7:J65` omitted row 66 while reporting 55 tracker rows and 21 blocked at n=1

**verified:** 2026-10-06 at 5:25 am Pacific, the then-current `count_tracker.mjs` read fixed range `Applications!A7:J65` and printed 55 tracker rows plus 21 blocked after Nordstrom was added at row 66; the current script reads `sheet.getUsedRange().rowCount`, selects `A8:J${usedRowCount}`, filters for nonempty status, and a same-window rerun printed 55 tracker rows plus 22 blocked
**where:** one tracker-count script and `outputs/job-application-tracker.xlsx` state

The source and output establish the row-66 omission for this one script state but do not establish behavior in other workbooks.

**Why:** REJECT at n=1 from one workbook and count-script subject; there are not five observations from five different subjects.
**Fix:** derive the application-row end from the current used range or table, start below the header, and count only rows with a nonempty status; the current used-range implementation and nonempty rerun are verified.

### `count_tracker.mjs` without its first argument failed with `Invalid end timestamp: undefined` at n=1

**verified:** 2026-10-06, `node job-pipeline/work/heartbeat-2026-10-06-0557/count_tracker.mjs` failed at line 18 with exactly `Error: Invalid end timestamp: undefined`; the 2,192-byte source reads `process.argv[2]`, and rerunning with `2026-10-06T15:00:00.000Z` returned a nonempty report containing 60 tracker rows, 39 submitted, and 4 submitted in the rolling 24-hour window
**where:** one tracker-count script invocation from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The source and paired execution prove that this script requires a parseable ISO timestamp as its first positional argument; they do not establish the interface of other counter scripts.

**Why:** REJECT at n=1 from one script and argument subject; there are not five observations from five different subjects.
**Fix:** compute or supply the exact run-end ISO timestamp as the first positional argument, for example `node job-pipeline/work/heartbeat-2026-10-06-0557/count_tracker.mjs "$run_end"`, then require a nonempty JSON count report.

### Idempotency scan `Applications!A8:J69` duplicated Direct Meds and dropped the Tax basis footer

**verified:** 2026-10-06, an idempotent tracker update checked only `Applications!A8:J69` for Direct Meds after its first run had inserted that company and role at row 70; the timestamp-patch retry missed row 70, shifted the footer again, and inspection showed Direct Meds in rows 70 and 71 before verification failed with exactly `Assumption footer verification failed` because the footer began at row 72
**verified:** 2026-10-06, the original insertion loop copied footer rows 73 through 70 downward while the four footer rows occupied 70:73; on retry after the first insertion, the same hard-coded loop shifted only rows 70:73 and overwrote the fourth footer line already at row 74, and cleanup verification returned the footer header, monthly assumptions, hourly assumptions, and `null` instead of the Tax basis row
**verified:** 2026-10-06, the corrected workbook was reopened and visually rendered with exactly one Direct Meds company-and-role match at row 70, all four take-home estimate and footer rows intact through row 74, and a clean layout
**where:** one failed retry and one corrected export of `outputs/job-application-tracker.xlsx`

The fixed duplicate-check range excluded the script's own insertion row, and the fixed footer range excluded the footer's post-insertion last row; behavior in other update scripts is UNCONFIRMED.

**Why:** REJECT at n=1 from one script and workbook subject; there are not five observations from five different subjects.
**Fix:** scan the full possible application area including the insertion row, remove duplicate company-and-role keys, and reconstruct or shift all four footer rows as one explicit block before export. Reopening and rendering verified exactly one Direct Meds match plus all four footer rows through row 74.

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

### System and bundled Python `-m pytest -q` returned `No module named pytest`; bundled `unittest discover` ran 75 tests at n=2

**verified:** 2026-10-05, `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 -m pytest -q` exited 1 with exactly `No module named pytest`, while the same interpreter running `tests/test_pipeline.py -q` exited 0 and printed `Ran 17 tests in 1.596s` and `OK`
**verified:** 2026-10-12, system `python3 -m pytest -q` in the authoritative pipeline exited 1 and printed exactly `/opt/homebrew/opt/python@3.14/bin/python3.14: No module named pytest`; `tests/test_pipeline.py` imported `unittest` and called `unittest.main()`, while bundled Python running `-m unittest discover -s tests -q` exited 0 and printed `Ran 75 tests in 3.518s` plus `OK`
**where:** two test-runner subjects in `/Users/zayah/Documents/Codex/2026-09-29/job-applications/job-pipeline` and `/Users/zayah/Documents/Codex/life/01 💼 Jobs/03 🛠️ Tools/⚙️ Job Pipeline`

Both pipeline test files use the standard-library `unittest` runner, and neither observed Python environment supplied pytest.

**Why:** REJECT at n=2 from two pipeline and runtime subjects; there are not five observations from five different subjects.
**Fix:** from the pipeline directory, run `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 -m unittest discover -s tests -q` and require exit 0 plus a nonzero test count; do not install pytest without approval.

### BrowserTab `click(...)` returned `Could not check the click target's shadow root` on 2 job links

**verified:** 2026-10-05, on `https://shopsatpalmdesert.com/careers`, `await mallTab.click(18)` returned exactly `Could not check the click target's shadow root`; `await mallTab.goto("https://shopsatpalmdesert.com/job/part-time-seasonal-associate")` followed by `await mallTab.getAXState(...)` succeeded
**verified:** 2026-10-06 at about 7:04 am Pacific, BrowserTab `click(54)` on a Dayforce job-card link failed immediately with exactly `Could not check the click target's shadow root`; the AX state exposed direct href `https://jobs.dayforcehcm.com/en-US/goodwillhome/CANDIDATEPORTAL/jobs/23715`
**where:** two unified-computer-use navigation subjects on The Shops at Palm Desert and Dayforce careers sites

Both accessibility clicks failed at the shadow-root check, but the evidence does not establish whether the page, target structure, or tool caused the failure.

**Why:** still held back at n=2 from two page and click subjects; there are not five observations from five different subjects.
**Fix:** when this exact click fails and the intended visible link URL is known, navigate the same tab directly to that URL and verify the destination with `getAXState(...)`. This recovery succeeded for The Shops at Palm Desert; the Dayforce recovery remains UNCONFIRMED until its detail page is loaded and inspected.

### `exec_module` without `sys.modules` registration raised `AttributeError: 'NoneType' object has no attribute '__dict__'` at n=1

**verified:** 2026-10-05, bundled Python 3.12 loaded `job-pipeline/pipeline.py` through `spec_from_file_location`, `module_from_spec`, and `exec_module` without first registering the module, then failed at `@dataclass(frozen=True)` in `dataclasses._is_type` with exactly `AttributeError: 'NoneType' object has no attribute '__dict__'` because `sys.modules.get(cls.__module__)` was `None`
**verified:** 2026-10-05, `tests/test_pipeline.py` registered `sys.modules[SPEC.name] = pipeline` before `SPEC.loader.exec_module(pipeline)`; direct execution with the bundled Python completed 18 tests in 1.368 seconds, printed `OK`, and exited 0
**where:** one dynamic test import of a module declaring `@dataclass`

The failed import and passing registered-module run isolate the observed failure to this dynamic import setup rather than the pipeline execution, but broader Python-version behavior is unconfirmed.

**Why:** REJECT at n=1 from one import subject; there are not five observations from five different subjects.
**Fix:** set `sys.modules[SPEC.name] = module` before `SPEC.loader.exec_module(module)`, then run the test file and require exit 0 plus its expected test count.

### python-docx 1.2.0 raised `ImportError` for `WD_CELL_VERTICAL_ALIGNMENT` from `docx.enum.text`; `docx.enum.table` imported it

**verified:** 2026-10-06, bundled Python 3.12.14 with python-docx 1.2.0 ran `from docx.enum.text import WD_CELL_VERTICAL_ALIGNMENT` and returned exactly `ImportError: cannot import name 'WD_CELL_VERTICAL_ALIGNMENT' from 'docx.enum.text'`; importing the same name from `docx.enum.table` exited 0 and printed module `docx.enum.table` plus name `WD_CELL_VERTICAL_ALIGNMENT`
**where:** one resume-builder import and one isolated paired import check in `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The failed import stopped the builder before output, while the paired check establishes the enum's working module in this installed version.

**Why:** REJECT at n=1 from one python-docx version and import subject; there are not five observations from five different subjects.
**Fix:** import with `from docx.enum.table import WD_CELL_VERTICAL_ALIGNMENT`, then run the builder and require a nonempty document output; the isolated import is verified, while the builder rerun remains UNCONFIRMED.

### System Python 3.14 lacked `docx` on 15 pipeline or test invocations across 2 workspaces; shell-preflight blocks unbundled `pipeline.py`

**verified:** 2026-10-05, `python3 pipeline.py run` in `/Users/zayah/Documents/Codex/2026-09-29/job-applications/job-pipeline` exited with a traceback at `pipeline.py` line 29 on `from docx import Document`; a direct check confirmed `/opt/homebrew/bin/python3` returned exactly `ModuleNotFoundError: No module named 'docx'`, while `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3` imported `docx` from its Python 3.12 site-packages
**verified:** 2026-10-05 at 11:43 am Pacific, `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 pipeline.py run` completed successfully and printed `discovered_count 187`, `scored_count 178`, `skipped_duplicate_count 9`, `ready_count 0`, `blocked_count 0`, and `source_failures []`
**verified:** 2026-10-05 at 4:24 pm Pacific, default `/opt/homebrew/bin/python3` 3.14.7 running `python3 -m unittest job-pipeline/tests/test_pipeline.py` failed with `ModuleNotFoundError: No module named 'docx'`, and a `python3` PDF validation snippet failed with exactly `ModuleNotFoundError: No module named 'pypdf'`; a paired check showed the bundled Python imported `docx` 1.2.0 and `pypdf` 6.10.0, then ran `job-pipeline/tests/test_pipeline.py -q` with `Ran 18 tests in 0.843s`, `OK`, and exit 0
**verified:** 2026-10-05 at about 5:08 pm Pacific, `/opt/homebrew/bin/python3` 3.14.7 running both `python3 job-pipeline/pipeline.py run` and `python3 -m unittest discover -s job-pipeline/tests -v` failed with exactly `ModuleNotFoundError: No module named 'docx'`; this repeats the same runtime and workspace subject
**verified:** 2026-10-05, direct execution of `job-pipeline/pipeline.py` returned `permission denied`; invoking it through system `python3` then failed with `ModuleNotFoundError: No module named 'docx'`, while the bundled Python path remained the verified successful runtime for the script and tests
**verified:** 2026-10-05, another Homebrew `python3` pair failed immediately because `python-docx` was absent: the pipeline exited 1 with exactly `ModuleNotFoundError: No module named 'docx'`, and unittest reported one failed import followed by `FAILED (errors=1)`; the bundled Python path remained the verified recovery
**verified:** 2026-10-05 at about 10:13 pm Pacific, `python3 job-pipeline/pipeline.py run` again failed immediately at `pipeline.py` line 29 with exactly `ModuleNotFoundError: No module named 'docx'`; no job-applications file was changed
**verified:** 2026-10-06, system `python3` running the pipeline and its tests failed at import with exactly `ModuleNotFoundError: No module named 'docx'`, while the bundled workspace Python completed the working test invocation with 24 tests passed
**verified:** 2026-10-06 at about 6:58 am Pacific, system Python 3.14 running `python3 job-pipeline/pipeline.py` and `python3 -m unittest discover -s job-pipeline/tests -v` each failed at `pipeline.py` line 29 with exactly `ModuleNotFoundError: No module named 'docx'`; switching to `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3` passed the dependency-bearing replacement run
**verified:** 2026-10-14, default Python 3.14.7 running `python3 pipeline.py --help` in the authoritative pipeline exited 1 at `pipeline.py` line 29 with exactly `ModuleNotFoundError: No module named 'docx'`; bundled Python 3.12.14 running the same command exited 0 and printed the complete `{run}` help, while README lines 27 and 33 named that exact bundled interpreter for normal and target runs
**verified:** 2026-10-18, system `python3 pipeline.py --help` again failed at line 29 with exactly `ModuleNotFoundError: No module named 'docx'`; on 2026-10-19, a paired reproduction showed system Python 3.14.7 fail identically with exit 1 while bundled Python 3.12.14 exited 0 and printed the complete `{run}` help
**where:** pipeline execution, tests, and PDF validation across `/Users/zayah/Documents/Codex/2026-09-29/job-applications/job-pipeline` and `/Users/zayah/Documents/Codex/life/01 💼 Jobs/03 🛠️ Tools/⚙️ Job Pipeline`

The paired checks establish runtime selection as the wall in both job-pipeline workspaces, not a failing test suite or parser.

**Why:** still REJECT after fifteen documented invocations across two workspace subjects in one machine environment; there are not five observations from five different environment subjects. The third recurrence triggered a reusable command check instead of another note alone.
**Fix:** `home/bin/shell-preflight` now rejects unbundled `python3 ...pipeline.py` commands and names `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3`; use that interpreter for every pipeline command and dependency-bearing test, then verify real output and exit status.

### `apply_patch verification failed: Failed to find expected lines` at n=16 across 9 file subjects

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
**verified:** 2026-10-07, one combined update placed test context `def test_required_undated_experience_is_excluded(self):` under the `pipeline.py` header and returned exactly `apply_patch verification failed: Failed to find expected lines in .../pipeline.py`; splitting the code and test changes under the correct `pipeline.py` and `tests/test_pipeline.py` headers removed the mismatch, and `patch-preflight --self-test` printed `patch-preflight: 3 fixtures passed`
**where:** sixteen patch attempts across MemeCoin `apps/extension/src/content.ts`, one Home Meta Cognition log file, generated `job-pipeline/state/seen-job-keys.json`, one spreadsheet builder, `library/web.md`, `library/testing.md`, `library/terminal.md`, and job-pipeline `pipeline.py` plus `tests/test_pipeline.py`

All sixteen failures mean the hunk context did not match the named target file; they cover nine file subjects.

**Why:** still held back at n=16 across nine file subjects because no untouched control was measured; the subject count alone does not pass the causal bar.
**Fix:** read each target immediately before editing, keep every hunk under its correct `Update File` header, and run `patch-preflight --root <workspace>` before applying a multi-file patch; the check rejects old context absent from the named file and its three-fixture self-test covers the verified wrong-header case.

### `apply_patch` rejected delete plus add for one path with `multiple operations target` at n=2

**verified:** 2026-10-10, one patch containing both `*** Delete File` and `*** Add File` for `state/local-run-latest.json` returned exactly `multiple operations target .../state/local-run-latest.json`
**verified:** 2026-10-10, an isolated patch containing both operations for `/tmp/library-duplicate-op.json` returned exactly `apply_patch verification failed: invalid patch: multiple operations target /tmp/library-duplicate-op.json` and left the original file unchanged
**where:** two apply_patch requests against two JSON file targets

Both patches named the same path twice inside one patch envelope; the evidence does not establish behavior for other operation combinations.

**Why:** REJECT at n=2 across two file targets; there are not five observations from five different subjects.
**Fix:** express the replacement as one `*** Update File` diff, or perform delete and add as two sequential apply_patch calls when replacement cannot be represented as an update.

### `rm -f style commands are not permitted` rejected 3 narrow cleanups before execution

**verified:** 2026-10-06, a resume QA command containing `rm -rf job-pipeline/work/qa-home-depot-2026-10-06-0014` returned exactly `rm -f style commands are not permitted. Use a safer approach`, with no child-process output
**verified:** 2026-10-16, an exec request containing `rm -rf /tmp/job-tracker-2026-10-16-edit-final` returned the same exact rejection before execution; using fresh directory `/tmp/job-tracker-2026-10-16-edit-final-2` instead produced a 23,247-byte workbook
**verified:** 2026-10-16, a heartbeat command chained `rm -rf /tmp/brooks-resume-render-2026-10-16` with artifact marking and rendering, and the command gate rejected it at zero elapsed time with exactly `rejected: rm -f style commands are not permitted. Use a safer approach`; `shell-preflight` rejected the same command class with status 1 and accepted a `mktemp -d` replacement with status 0
**where:** three exec command-gate decisions in `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The gate rejected all three full commands before their intended work ran, even though each removal target was one named task-local directory; the installed preflight now covers this recurring class.

**Why:** REJECT at n=3 from one command-gate subject; there are not five observations from five different subjects.
**Fix:** run `shell-preflight` before execution, create a fresh directory with `mktemp -d`, and invoke artifact marking and rendering as separate commands without destructive cleanup. The preflight's 33 fixtures include blocked `rm -rf` and allowed `mktemp -d` cases.

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

### openpyxl read-only trackers returned `None` dimensions or short tuples; 7 reads failed across 2 workbooks

**verified:** 2026-10-05, `openpyxl.load_workbook(..., read_only=True)` opened the then 12,974-byte `outputs/job-application-tracker.xlsx` workbook and returned `Worksheet.max_row` and `max_column` as `None`, so `min(sheet.max_row, 8)` raised exactly `TypeError: '<' not supported between instances of 'int' and 'NoneType'`; a later pipeline run failed at `pipeline.py:292` with exactly `IndexError: tuple index out of range` on `row[5]`
**verified:** 2026-10-05, re-reading the current 14,303-byte workbook yielded 194 tuples from row 7, including 148 tuples of length 5 beginning at worksheet row 53; `pipeline.py` now skips `len(row) < 6`, and bundled Python completed `Ran 21 tests in 1.168s` with `OK`
**verified:** 2026-10-05, a separate bundled-Python status comprehension also indexed `r[5]` without checking row length and failed with exactly `IndexError: list index out of range` on the workbook's shorter trailing note rows
**verified:** 2026-10-05 at about 9:12 pm Pacific, iterating `ws.iter_rows(min_row=8, values_only=True)` and unpacking application columns raised exactly `ValueError: not enough values to unpack (expected at least 6, got 5)` on a short row; 2026-10-05 at about 9:20 pm Pacific, another read-only load returned `max_row` and `max_column` as `None`, so `min(ws.max_row, 5)` raised exactly `TypeError: '<' not supported between instances of 'int' and 'NoneType'`
**verified:** 2026-10-11, bundled Python opened the 19,251-byte authoritative tracker read-only and an unguarded Company-header generator indexed `r[0]` on an empty tuple, raised exactly `IndexError: list index out of range`, and exited 1; the guarded retry inspected 200 rows, counted 1 empty tuple and 123 tuples shorter than six cells, found the Company header at row 7, and exited 0
**verified:** 2026-10-13, bundled Python with openpyxl 3.1.5 opened the authoritative tracker with `read_only=True, data_only=False` and printed `ReadOnlyWorksheet None None`; `range(1, ws.max_column + 1)` then raised exactly `TypeError: unsupported operand type(s) for +: 'NoneType' and 'int'`, while reopening with `read_only=False, data_only=False` without saving printed `Worksheet 200 10` and returned all ten row-7 headers from `Company` through `Estimated monthly take-home`
**where:** two `Applications` worksheets and openpyxl read-only workbook subjects at `/Users/zayah/Documents/Codex/2026-09-29/job-applications/outputs/job-application-tracker.xlsx` and `/Users/zayah/Documents/Codex/life/01 💼 Jobs/01 💼 Jobs Applied For/📊 Application Tracker/job-application-tracker.xlsx`

The older workbook's short tuples began after its visible A1:J52 range, while the authoritative tracker yielded both an empty tuple and `None` dimensions in read-only mode; why openpyxl emitted either shape is UNCONFIRMED.

**Why:** REJECT after four positional-read failures and three dimension failures from two workbook subjects; there are not five observations from five different subjects.
**Fix:** use `len(r) > 0` before `r[0]` in the Company-header scan, guard `len(r) > index` before every optional positional read, and pass `max_col=10` when ten application columns are required. For dimension-sensitive inspection, load with `read_only=False, data_only=False`, do not save, and verify the worksheet name, `max_row`, `max_column`, and expected headers before reading ranges; this returned `Applications`, 200 rows, 10 columns, and all ten headers on 2026-10-13.

### `ReadOnlyCell` had no `style_id`; normal-mode `Cell.style_id` returned 20 at n=1

**verified:** 2026-10-12, bundled Python with openpyxl 3.1.5 opened the authoritative tracker with `read_only=True`, and reading `Applications!A7.style_id` raised exactly `AttributeError: 'ReadOnlyCell' object has no attribute 'style_id'. Did you mean: '_style_id'?`; reopening the same workbook with `read_only=False` returned `Cell 20 True` for its type, `style_id`, and `has_style` without saving the workbook
**where:** one style-inspection pair on `/Users/zayah/Documents/Codex/life/01 💼 Jobs/01 💼 Jobs Applied For/📊 Application Tracker/job-application-tracker.xlsx`

The paired reads establish the public-property difference for this workbook and openpyxl version; whether other read-only cell types expose a public style identifier is UNCONFIRMED.

**Why:** REJECT at n=1 from one workbook and runtime subject; there are not five observations from five different subjects.
**Fix:** when an exact public style ID is required, load the workbook with `read_only=False`, inspect `Cell.style_id`, and do not save. For streaming inspection, use the public `ReadOnlyCell` style components and `has_style` rather than depending on private `_style_id`.

### `load_workspace_dependencies({})` returned `The app could not load this tool. Please try again.` at n=8

**verified:** 2026-10-06 at about 8:25 am Pacific, `mcp__codex_app__load_workspace_dependencies({})` returned exactly `The app could not load this tool. Please try again.`, while the previously verified runtimes under `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/` remained usable for the work
**verified:** 2026-10-06, two consecutive calls returned the same exact error and no dependency paths; a fourth verification call from the dotfiles task returned the same error, while cached `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3` printed `Python 3.12.14`, imported `docx` 1.2.0, and the installed Documents skill `SKILL.md` existed at 40,679 bytes
**verified:** 2026-10-07, following the Spreadsheets skill before read-only inspection of `/Users/zayah/Documents/Codex/life/01 💼 Jobs/01 💼 Jobs Applied For/📊 Application Tracker/job-application-tracker.xlsx`, another loader call from the job-applications cwd returned the same exact error and no paths; `workspace-dependencies-fallback spreadsheets` then printed Python 3.12.14, Node v24.19.0, openpyxl 3.1.5, and a 63,930-byte Spreadsheets `SKILL.md`
**verified:** 2026-10-10 at about 1:00 pm Pacific, another loader call returned exactly `The app could not load this tool. Please try again.` and no paths; the shell did not expose `workspace-dependencies-fallback` on `PATH`, while `/Users/zayah/github/dotfiles/home/bin/workspace-dependencies-fallback spreadsheets` verified Python 3.12.14, Node v24.19.0, openpyxl 3.1.5, the 63,930-byte skill, and three references of 2,481, 25,830, and 10,103 bytes
**verified:** 2026-10-12, a loader call while preparing an Artifact Tool workbook edit returned the same exact error and no paths; `/Users/zayah/github/dotfiles/home/bin/workspace-dependencies-fallback spreadsheets` then verified Python 3.12.14, Node v24.19.0, openpyxl 3.1.5, the 63,930-byte skill, and the three required references, while `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules` and its `@oai/artifact-tool` package directory both existed
**verified:** 2026-10-14, during a spreadsheet tracker edit from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`, another loader call returned the same exact error and no paths; `/Users/zayah/github/dotfiles/home/bin/workspace-dependencies-fallback spreadsheets` verified Python 3.12.14, Node v24.19.0, openpyxl 3.1.5, the 63,930-byte skill, and references of 2,481, 25,830, and 10,103 bytes, while the cached `node_modules` and `@oai/artifact-tool` directories existed without modifying either dependency directory
**where:** eight Codex desktop dependency-loader calls across job-applications, dotfiles, and spreadsheet-inspection task contexts on one machine

All eight calls returned no dependency payload, but the cached runtime and skill checks show that these loader failures did not establish missing installed dependencies; the loader cause is UNCONFIRMED.

**Why:** still held back at n=8 from one app-tool and machine subject; there are not five independent subjects or an untouched control, so the failures do not establish a cause.
**Fix:** retry the loader once; if it still fails and the installed fallback command is unavailable, run `/Users/zayah/github/dotfiles/home/bin/workspace-dependencies-fallback <skill-name>` and use only the nonempty paths and versions it verifies. For Spreadsheets, the cached Node runtime and `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules` root are verified; other skill names remain UNCONFIRMED until exercised.

### `zsh:1: command not found: workspace-dependencies-fallback` at n=1

**verified:** 2026-10-10, invoking `workspace-dependencies-fallback spreadsheets` from the dotfiles repository returned exactly `zsh:1: command not found: workspace-dependencies-fallback`; invoking `/Users/zayah/github/dotfiles/home/bin/workspace-dependencies-fallback spreadsheets` then printed verified Python 3.12.14, Node v24.19.0, openpyxl 3.1.5, skill bytes, and all three reference byte counts
**where:** one dotfiles shell before the Home Manager configuration containing the fallback command was applied to that shell environment

The source command was executable and complete, so this occurrence proves only that its installed command name was absent from `PATH` in that shell.

**Why:** REJECT at n=1 from one shell and configuration state; there are not five observations from five different subjects.
**Fix:** run the repository source path shown above until the configuration has been applied and a fresh shell resolves `command -v workspace-dependencies-fallback`; do not treat a missing wrapper name as missing cached runtimes.

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

### `json.loads` rejected GovernmentJobs text at `line 1 column 513 (char 512)`; `strict=False` produced 30/30 descriptions

**verified:** 2026-10-16, `/tmp/govjobs_details_2026_10_16.py` first failed with exactly `Invalid control character at: line 1 column 513 (char 512)` while decoding an embedded GovernmentJobs description; changing that capture to `json.loads(..., strict=False)` completed 30 of 30 descriptions with 256,105 total description bytes
**where:** one GovernmentJobs embedded-description parser and 30 detail pages

The paired run verifies the recovery for this captured JSON string; whether other GovernmentJobs fields contain the same control character is UNCONFIRMED.

**Why:** REJECT at n=1 from one parser and source subject; there are not five observations from five different subjects.
**Fix:** apply `strict=False` only to the captured embedded JSON string, then unescape and parse its HTML, and require every requested description to be nonempty. The corrected run returned 30 of 30 descriptions and 256,105 bytes.

### Bundled Python 3.12.14 and system Python 3.14.7 lacked `bs4` across 2 HTML parsers

**verified:** 2026-10-16, bundled Python 3.12.14 importing `bs4` raised exactly `ModuleNotFoundError: No module named 'bs4'`; the GovernmentJobs parser instead imported `html.parser.HTMLParser`, and its output contained 30 of 30 nonempty descriptions totaling 256,105 bytes
**verified:** 2026-10-16, `/opt/homebrew/bin/python3` 3.14.7 importing `bs4` returned exactly `ModuleNotFoundError: No module named 'bs4'` while parsing downloaded Lever application-form HTML; the same interpreter imported `html.parser.HTMLParser`, fed a form fragment, and printed `HTMLParser ok`
**where:** bundled Python for one GovernmentJobs parser and system Python for one Lever form parser

Beautiful Soup was unavailable in both tested runtimes, while the standard-library parser was sufficient for the GovernmentJobs extraction and loaded successfully for the Lever parser; exact Lever field extraction with it is UNCONFIRMED.

**Why:** REJECT at n=2 across two runtime and source subjects; there are not five observations from five different subjects.
**Fix:** use `html.parser.HTMLParser` for simple text or form parsing rather than assuming Beautiful Soup or installing it without approval, then verify expected fields, record counts, and nonempty output. The bundled runtime is not a BeautifulSoup fallback because its `bs4` import also fails.

### Bundled lxml `.cssselect()` raised `cssselect does not seem to be installed`; XPath returned one form

**verified:** 2026-10-16, bundled Python 3.12.14 imported lxml but `html.fromstring('<form><label>Name</label></form>').cssselect('form')` raised exactly `ImportError: cssselect does not seem to be installed`; the same interpreter and document using `.xpath('//form')` exited 0 and printed `1 form`
**where:** one Lever form-parser dependency probe in `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3`

The paired probe establishes that lxml itself was installed and XPath worked while the optional `cssselect` package was absent in this runtime; it does not establish selector behavior in other Python environments.

**Why:** REJECT at n=1 from one runtime and parser subject; there are not five observations from five different subjects.
**Fix:** use lxml XPath expressions such as `.xpath('//form')` instead of `.cssselect()` in this runtime, and verify the expected node count before extracting fields.

### `getUsedRange().values[20]` was worksheet row 22 because the used range began at A2; A1 addressing was correct at n=1

**verified:** 2026-10-16, artifact-tool 2.8.94 imported a 23,247-byte tracker and returned `getUsedRange().values[0]` as `Job application tracker`, the value at `A2`; array index 20 and `getRange('A22:B22')` both returned `Adaptive Biotechnologies` and `IT Support Technician I`, while `getRange('A21:B21')` and zero-based `getRangeByIndexes(20,0,1,2)` both returned `Coperniq` and `Founding BDR`
**where:** one imported `job-application-tracker.xlsx` read through artifact-tool 2.8.94 in workspace bundle 26.1013.11914

The reported one-row difference was real, but the paired A1 and zero-based reads refute an A1 parser bug: `getUsedRange().values` was indexed relative to a used range whose first nonempty row was worksheet row 2.

**Why:** REJECT at n=1 from one workbook and artifact-tool runtime subject; there are not five observations from five different subjects.
**Fix:** treat used-range array indices as relative to the used range's own start, not to worksheet A1. Use exact A1 ranges for worksheet-row checks, or carry the used-range start when translating array offsets, then verify the expected labels after reopening the workbook.

### `Unexpected existing Applications value change at row 88 column 0` rejected one authorized append

**verified:** 2026-10-16, the first tracker-builder verification failed with exactly `Unexpected existing Applications value change at row 88 column 0` after writing the authorized target row; the corrected loop contains `if (row === nextApplicationIndex) continue`, then separately asserts the Brooks value at that index, and the 23,881-byte exported workbook reopened with `Applications!A90:J90` containing the intended Brooks Running row and zero formula-error matches
**where:** one artifact-tool tracker append and preservation check in `outputs/hourly-application-questions/tracker-edit/tracker_blocked_brooks_2026_10_16.mjs`

The saved before state had ten nulls at used-range index 88 and the after state had the authorized record there, so the preservation failure came from treating the intended target mutation as an unexpected existing-value change.

**Why:** REJECT at n=1 from one builder and workbook subject; there are not five observations from five different subjects.
**Fix:** skip only `nextApplicationIndex` in the existing-value preservation loop, then verify that row separately by its expected key and inspect the reopened workbook range. Preserve and compare every other pre-existing row.

### artifact-tool copy operations lost formatting, retained merges, or corrupted overlapping sources on 7 observations from one workbook

**verified:** 2026-10-02, `copyFrom(..., "all")` on an imported workbook did not transfer formatting into blank tracker rows, and overlapping `copyFrom` from `A36:J39` to `A39:J42` overwrote the last source row; writing explicit values, unmerging the destination, and applying formatting directly produced the intended workbook; 2026-10-05, overlapping `A43:J46.copyTo(A46:J49, "all")` propagated the changed source during the copy, and the render showed row 49 duplicated `Take-home estimate assumptions` instead of preserving the original tax-basis row
**verified:** 2026-10-05, overlapping `A49:J52.copyTo(A50:J53, "all")` on four individually merged rows made all four destination rows contain `Take-home estimate assumptions`, replacing the three distinct body rows
**verified:** 2026-10-05, overlapping `copyFrom(A51:J54 -> A54:J57, "all")` corrupted the last copied note row; its copied formats also retained existing A:J merges in the destination, so inspection contained written B:J values while the render hid them
**verified:** 2026-10-06, after `table.rows.add` extended the imported table, overlapping destination `A67:J70.copyFrom(A66:J69, "all")` replaced the four distinct source note rows with `Take-home estimate assumptions` in all four destination rows on inspection
**where:** one imported tracker workbook edited with artifact-tool

The evidence establishes all seven copy results in this workbook but does not establish their cause or behavior in other workbooks.

**Why:** REJECT after seven observations from one workbook subject; there are not five observations from five different subjects.
**Fix:** read source values into a JavaScript matrix before mutation and write that matrix to the shifted destination; copy formatting only from non-overlapping template rows or reconstruct it, explicitly unmerge target rows with `sheet.unmergeCells`, then inspect values and render every affected column.

### `table.rows.add` overwrote 3 non-table rows once and blanked the last table row once in one workbook

**verified:** 2026-10-05, `table.rows.add(null, [[...], [...], [...]])` extended an imported Applications table into occupied worksheet rows 35:37 and replaced three non-table Coalition Technologies records; a rendered PNG showed the earlier Remote Office Assistant, Digital Producer Trainee, and Remote Recruiter rows missing
**verified:** 2026-10-06, `job-pipeline/work/heartbeat-2026-10-06-0557/update_tracker.mjs` called `table.rows.add(null, [[null, ...]])` when the Applications table address was `A7:J43` and 24 Hour Fitness Sales and Service Associate occupied the last data row; reopening the export showed row 43 empty, rows 44 onward unchanged, the submitted record missing, dashboard submitted total still 39, and source-log evidence for its October 5, 2026 10:34 pm Pacific submission
**where:** two artifact-tool row-add operations in `outputs/job-application-tracker.xlsx`

The two operations establish destructive row changes in this workbook but do not establish artifact-tool behavior in other workbooks.

**Why:** REJECT at n=2 operations from one workbook subject; there are not five observations from five different subjects.
**Fix:** do not use `table.rows.add` when worksheet content or a footer exists outside the table. Shift explicit worksheet ranges, restore overwritten rows from durable source data, write the new row, then reopen the exported workbook and verify the exact previous row, new row, table address, dashboard total, and footer rows.

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

### 2 Artifact Tool Date writes rendered UTC clock components; direct serial rendered `10/06/26 8:03 AM`

**verified:** 2026-10-05, artifact-tool wrote `new Date('2026-10-05T18:20:29-07:00')` and the XLSX displayed `10/06/26 1:20 AM`; writing `new Date('2026-10-05T18:20:29Z')` displayed the intended `10/05/26 6:20 PM`
**verified:** 2026-10-06, an update script wrote `new Date("2026-10-06T15:03:35.791Z")` into a cell formatted `mm/dd/yy h:mm AM/PM`; inspection returned serial `46301.627497581016` and the rendered row 70 showed `10/06/26 3:03 PM` instead of the trigger's intended `8:03:35 am` Pacific wall time
**verified:** 2026-10-06, the corrected workbook wrote the intended Pacific wall-clock components as an explicit Excel serial, then reopening and visually rendering showed Direct Meds row 70 as exactly `10/06/26 8:03 AM`
**where:** two wrong Date writes and one corrected serial write in one Artifact Tool XLSX tracker and runtime subject

The three rendered display values establish that this tracker path used serialized UTC clock components as timezone-free Excel wall-clock values, but not a universal rule for every spreadsheet engine.

**Why:** still held back at n=2 from one workbook and runtime subject; there are not five observations from five different subjects.
**Fix:** write the desired timezone-free wall-clock components as an explicit Excel serial, such as `Date.UTC(2026,9,6,8,3,35,791) / 86400000 + 25569`, then reopen and render the formatted cell. The corrected workbook verified this recovery at `10/06/26 8:03 AM`.

### `pipeline.py` without `run` exited 2 with `the following arguments are required: command` at n=4

**verified:** 2026-10-05, `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 job-pipeline/pipeline.py` exited 2 and printed `usage: pipeline.py [-h] {run} ...` followed by exactly `pipeline.py: error: the following arguments are required: command`; the same bundled runtime with `pipeline.py run` had already completed successfully and printed pipeline counts
**verified:** 2026-10-06, after selecting the bundled Python runtime, invoking `pipeline.py` without `run` again returned exactly `error: the following arguments are required: command`; the same bundled runtime passed the separate 24-test invocation
**verified:** 2026-10-06 at about 3:25 am Pacific, bundled Python invoked as `job-pipeline/pipeline.py` without a subcommand returned nonempty stderr containing `usage: pipeline.py [-h] {run} ...` and exactly `error: the following arguments are required: command`
**verified:** 2026-10-06, `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 job-pipeline/pipeline.py` exited 2 with exactly `usage: pipeline.py [-h] {run} ...` and `pipeline.py: error: the following arguments are required: command`; adding `run` exited 0 and produced generated_at `2026-10-06T14:26:51.111617+00:00`, 201 discovered, 184 scored, 17 duplicates skipped, 1 ready, 5 blocked, and `source_failures: []`
**where:** four job-pipeline CLI invocations from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The nonempty parser stderr establishes that no pipeline run occurred; exit code alone is not execution proof.

**Why:** still held back at n=4 from one CLI parser subject; there are not five observations from five different subjects.
**Fix:** invoke `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 job-pipeline/pipeline.py run`, then require exit 0 and inspect the printed counts.

### We Work Remotely returned `TimeoutError: The read operation timed out` once; the pipeline still reported 163 discovered and 147 scored

**verified:** 2026-10-06, `python3 job-pipeline/pipeline.py run` exited 0 with nonempty output containing `discovered_count 163`, `scored_count 147`, `skipped_duplicate_count 16`, `ready_count 1`, `blocked_count 5`, and a We Work Remotely source failure of exactly `TimeoutError: The read operation timed out`; `job-pipeline/state/approval-batch.json` recorded the same counts and exact source failure at `2026-10-06T13:35:51.055240+00:00`
**where:** one job-pipeline run and its generated approval batch in `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The completed run proves that one source can fail while the pipeline still returns a nonempty batch, but it does not establish whether a retry would recover that source.

**Why:** REJECT at n=1 from one source and pipeline-run subject; there are not five observations from five different subjects.
**Fix:** UNCONFIRMED for the source timeout; inspect `source_failures` even when the command exits 0, retain the run's verified counts, and mark We Work Remotely coverage unavailable for that run rather than treating exit 0 as proof that every source succeeded.

### 8 jq root-shape assumptions failed or expanded output on object `source-log.json` and array `job-pool.json` across 3 files

**verified:** 2026-10-05, `jq '.[-12:]' job-pipeline/state/source-log.json` failed with exactly `jq: error (at job-pipeline/state/source-log.json:860): Cannot index object with object ({"start":-12,"end":null})`; the file root had keys `last_run` and `checked_domains`, and `jq '.checked_domains[-12:]' job-pipeline/state/source-log.json` returned the latest 12 source-log entries
**verified:** 2026-10-05, `jq '{generated_at,total:(.jobs|length), keys:(.jobs[0]|keys), first:.jobs[0]}' job-pipeline/state/job-pool.json` failed at line 5239 with exactly `Cannot index array with string ("generated_at")`; inspection verified that the root was an array, and `jq '{total:length, keys:(.[0]|keys), first:.[0]}'` was the matching root-level query
**verified:** 2026-10-06, `jq '.[-4:]' job-pipeline/state/source-log.json` failed with `Cannot index object with object ({"start":-4,"end":null})`; the earlier verified root keys were `last_run` and `checked_domains`, not `entries`
**verified:** 2026-10-06, `jq 'length, .[-2:]' job-pipeline/state/source-log.json` failed with `Cannot index object with object ({"start":-2,"end":null})` because the source-log root is an object
**verified:** 2026-10-06, `jq '.[-8:]' job-pipeline/state/source-log.json` failed with `Cannot index object with object ({"start":-8,"end":null})`; this was one command reported twice, and the verified nested array remains `checked_domains`
**verified:** 2026-10-06, `jq 'keys, (.[-12:] // empty)' job-pipeline/state/source-log.json` exited 5 with exactly `Cannot index object with object ({"start":-12,"end":null})`; the replacement `jq '{last_run, checked_domains_type:(.checked_domains|type), checked_domains_length:(.checked_domains|length), last_entries:(.checked_domains[-12:])}' ...` exited 0, reported `checked_domains_type` as `array`, length 617, and returned 12 entries
**verified:** 2026-10-06, `jq -r '.entries[-24:][]' job-pipeline/state/source-log.json` failed with exactly `Cannot iterate over null (null)`; `jq 'keys'` returned `checked_domains` and `last_run`, and `jq '.checked_domains[-1] | keys'` returned the actual entry fields `domain`, `result`, and `track`
**verified:** 2026-10-18, `jq 'keys' state/job-pool.json` printed all 7,336 array indexes; on 2026-10-19, `jq 'keys | length'` confirmed 7,336, `jq 'type,length,.[0]|keys'` failed with exactly `string ("array") has no keys`, and `jq 'type, length, (.[0] | keys)'` exited 0 with root type `array`, length 7,336, and 21 first-record keys
**where:** eight jq commands against three `source-log.json` and `job-pool.json` files under `/Users/zayah/Documents/Codex/2026-09-29/job-applications` and the authoritative Job Pipeline

The two files use different root shapes, so neither an object-key assumption nor an array-root assumption transfers between them; the source-log array field remains `checked_domains` in the verified inspection.

**Why:** still held back at n=8 command observations across three JSON file and schema subjects because no untouched control was measured; the command count alone does not pass the causal bar.
**Fix:** inspect arrays with `jq 'type, length, (.[0] | keys)'` so pipe precedence cannot send `type` or `length` into `keys`; use `.checked_domains[-N:]` for the object-root source-log tail, then require the expected type and bounded count.

### `jq` unmatched closing `]` returned `syntax error, unexpected INVALID_CHARACTER` at n=1

**verified:** 2026-10-19, `jq '[.[] | select(.source == "governmentjobs")]] | length' state/job-pool.json` exited 3 with exactly `syntax error, unexpected INVALID_CHARACTER`; removing the extra closing bracket and running `jq '[.[] | select(.source == "governmentjobs")] | length' ...` exited 0 and printed `0`
**where:** one filter against `state/job-pool.json` in `/Users/zayah/Documents/Codex/life/01 💼 Jobs/03 🛠️ Tools/⚙️ Job Pipeline`

The compile error occurred before the input array was filtered.

**Why:** REJECT at n=1 from one jq expression and JSON subject; there are not five observations from five different subjects.
**Fix:** balance the array constructor as `[.[] | select(...)] | length`, then require exit 0 and a numeric result before accepting the inspection.

### jq object values without leading dots returned 7 `name/0 is not defined` errors at n=1

**verified:** 2026-10-16, a jq object expression beginning `{inspected:listings_inspected_new_local, ...}` exited 3 with `listings_inspected_new_local/0 is not defined` plus six analogous `/0 is not defined` errors; adding leading dots to all seven values exited 0 and returned inspected 210, qualified 1, prepared 0, approved 0, submitted 0, blocked 2, and remaining 200
**where:** one summary query against `state/local-run-latest.json` in the authoritative Job Pipeline

Bare jq identifiers in value position were parsed as zero-arity filter or function names rather than input-object fields.

**Why:** REJECT at n=1 from one query and JSON subject; there are not five observations from five different subjects.
**Fix:** prefix every input field with `.`, for example `{inspected:.listings_inspected_new_local}`, and require the corrected query to return the expected non-null keys and numeric values.

### Direct `web__run` input returned `Script error: SyntaxError: Unexpected string`; object assignment succeeded at n=2

**verified:** 2026-10-05, a `functions.exec` call containing a direct `web__run` request failed with exactly `Script error: SyntaxError: Unexpected string` and returned zero results; retrying as `const args={search_query:[...],response_length:"long"}; await tools.web__run(args);` succeeded
**verified:** 2026-10-06, `await tools.web__run({open:[...],response_length:"short"})` returned exactly `Script error: SyntaxError: Unexpected string`; assigning the same request first as `const args={open:[...],response_length:"short"};` then calling `await tools.web__run(args)` succeeded and returned both Kroger page results
**where:** two functions-exec web request inputs across job-search and library-verification workflows

Both direct JavaScript inputs failed before the web request could return results, while an explicit object binding produced a valid tool call in each workflow.

**Why:** REJECT at n=2 from two exec-input subjects; there are not five observations from five different subjects.
**Fix:** assign the web request to a JavaScript object before calling `await tools.web__run(args)`, then require nonempty returned content before accepting the search.

### Artifact marker paths were missing in 5 lookups across 3 skills; skill-cache paths existed

**verified:** 2026-10-03, `ls -l container_tools/mark_artifact_operation_started.mjs` returned `No such file or directory`, while `rg --files /Users/zayah/.codex /Users/zayah/.cache/codex-runtimes | rg '/mark_artifact_operation_started\.mjs$'` found `/Users/zayah/.codex/plugins/cache/openai-primary-runtime/pdf/26.905.11957/skills/pdf/container_tools/mark_artifact_operation_started.mjs` and the runtime-cache equivalent
**verified:** 2026-10-05, the Spreadsheets skill requested `node container_tools/mark_artifact_operation_started.mjs ...`, but `ls` on `/Users/zayah/.codex/plugins/cache/openai-primary-runtime/spreadsheets/26.905.11957/container_tools` returned exactly `No such file or directory`; `rg --files` found the marker at `/Users/zayah/.codex/plugins/cache/openai-primary-runtime/spreadsheets/26.905.11957/skills/spreadsheets/container_tools/mark_artifact_operation_started.mjs` and the runtime-cache equivalent
**verified:** 2026-10-05 at about 10:00 pm Pacific, the required runtime Node invocation of `/Users/zayah/.codex/plugins/cache/openai-primary-runtime/spreadsheets/26.905.11957/container_tools/mark_artifact_operation_started.mjs` exited 1 with `MODULE_NOT_FOUND`; the deployed `/Users/zayah/.codex/plugins/cache/openai-primary-runtime/spreadsheets/26.905.11957/skills/spreadsheets/container_tools/mark_artifact_operation_started.mjs` existed at 743 bytes, and invoking it with the same runtime reached the script and printed its usage line
**verified:** 2026-10-06, the same Spreadsheets plugin-root marker path under `spreadsheets/26.905.11957/container_tools/` again failed under Node v24.19.0 with `MODULE_NOT_FOUND`; the deployed skill-cache path remained the verified recovery
**verified:** 2026-10-06, `node container_tools/mark_artifact_operation_started.mjs ...` failed from the job-applications workspace because it had no `container_tools/` directory; `rg --files` returned `/Users/zayah/.codex/plugins/cache/openai-primary-runtime/documents/26.905.11957/skills/documents/container_tools/mark_artifact_operation_started.mjs` and the analogous PDF skill path
**where:** five PDF, Spreadsheets, and Documents skill marker lookups from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The workspace-relative and spreadsheet plugin-root paths were absent, while skill-specific cache searches returned the marker files for three skills.

**Why:** still held back at n=5 lookups across three skill-path subjects; there are not five observations from five different subjects.
**Fix:** resolve the active skill's marker with `rg --files`, then invoke its absolute skill-package path with the bundled Node runtime. The Spreadsheets recovery is verified; the new Documents and PDF absolute invocations remain UNCONFIRMED until their command output is captured. The third recurrence requires an automated preflight that rejects an absent workspace or plugin-root guess, which remains UNCONFIRMED until built and exercised.

### `zsh:1: command not found: python` at n=3

**verified:** 2026-10-04 at 10:21 am Pacific, `python - <<'PY'` returned exactly `zsh:1: command not found: python`
**verified:** 2026-10-05 at about 8:00 pm Pacific, another `python - <<'PY'` invocation returned exactly `zsh:1: command not found: python`, exited 127, while `command -v python3` resolved `/opt/homebrew/bin/python3` and the bundled Python reported version 3.12.14
**verified:** 2026-10-07, `python -m unittest discover -s tests -v` returned exactly `zsh:1: command not found: python` and exit 127; `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 -m unittest discover -s tests -v` ran all 24 tests in 1.315 seconds and printed `OK`
**where:** two source-inspection commands and one authoritative pipeline test invocation in `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The shell did not expose a command named `python` in any of the three invocations.

**Why:** REJECT at n=3 from one machine environment subject; there are not five observations from five different subjects.
**Fix:** use `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3` for this dependency-bearing pipeline and verify the replacement command's real output. The third recurrence added a `shell-preflight` guard that rejects `python` in command position, accepts the bundled interpreter, and its later expanded suite passes all 33 fixtures.

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

### Cached workspace Python `/Users/zayah/.cache/codex-workspace-deps/82d293e4/python/bin/python3` returned `zsh:1: no such file or directory` at n=1

**verified:** 2026-10-14, `/Users/zayah/.cache/codex-workspace-deps/82d293e4/python/bin/python3 --version` exited 127 with exactly `zsh:1: no such file or directory: /Users/zayah/.cache/codex-workspace-deps/82d293e4/python/bin/python3`; `/opt/homebrew/bin/python3` remained on `PATH` as Python 3.14.7, but importing `openpyxl` returned `ModuleNotFoundError: No module named 'openpyxl'`
**verified:** 2026-10-14, PATH Python's standard-library `zipfile` check of `outputs/job-application-tracker.xlsx` returned `{'is_zipfile': True, 'testzip': None, 'entries': 10}`; `/Users/zayah/github/dotfiles/home/bin/workspace-dependencies-fallback spreadsheets` resolved the current bundled Python to `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3`, printed Python 3.12.14, and imported openpyxl 3.1.5
**where:** one expired or absent hash-addressed workspace dependency path during XLSX verification from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The old absolute path is absent now; why it disappeared and how long hash-addressed workspace dependency paths remain valid are UNCONFIRMED. PATH Python verified the XLSX ZIP container in this run, but it could not perform openpyxl workbook inspection.

**Why:** REJECT at n=1 from one cached-path and machine subject; there are not five observations from five different subjects or an untouched control.
**Fix:** resolve the runtime again for each dependency-backed task. If `load_workspace_dependencies` fails, run `/Users/zayah/github/dotfiles/home/bin/workspace-dependencies-fallback spreadsheets` and use the nonempty Python path it verifies; use PATH Python with `zipfile` only for container-integrity checks, not openpyxl inspection.

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

### `pdftotext` was missing on 23 attempts across 6 dates; 3 other PDF text routes were unavailable in one environment

**verified:** 2026-09-29, system `pdftotext` returned exactly `zsh: command not found: pdftotext`, system `python3` failed to import `pypdf` with `ModuleNotFoundError`, and direct `firecrawl` returned `command not found`; `npx firecrawl-cli parse` installed `firecrawl-cli@1.24.6` and produced 2,344 bytes of expected resume text; 2026-10-02, `from pypdf import PdfReader` returned exactly `ModuleNotFoundError: No module named 'pypdf'`, and `mdls -name kMDItemTextContent` returned null for the resume PDFs; 2026-10-03, six separate read-only resume extraction attempts, including `outputs/office-operations/Zayah Nelson - Office Operations resume.pdf` and a 3,565-byte IT Support resume whose `pdfinfo` showed one letter-size page, each returned exactly `zsh:1: command not found: pdftotext`, and a fresh `command -v pdftotext` exited 1; 2026-10-04, three earlier resume checks returned `command not found: pdftotext`, including Office Operations and Palm Springs Guest Service files, and a fresh `command -v pdftotext` exited 1; at 5:29 pm Pacific, another Office Operations check returned exactly `zsh:1: command not found: pdftotext`, `mdls -raw -name kMDItemTextContent` returned exactly `(null)`, and the adjacent `build_resume.py` supplied the usable source text
**verified:** 2026-10-04, `/Users/zayah/Documents/Codex/2026-09-29/job-applications/outputs/office-operations/Zayah Nelson - Office Operations resume.pdf` existed at 65,337 bytes while its `pdftotext` inspection returned exactly `zsh:1: command not found: pdftotext`; this enriches an already counted Office Operations attempt and does not increase n
**verified:** 2026-10-04, system `python3` in the same workspace failed to import pypdf with exactly `ModuleNotFoundError: No module named 'pypdf'`; this is a new date for the already counted unavailable pypdf route, not a new environment subject
**verified:** 2026-10-05, `pdftotext 'outputs/office-operations/Zayah Nelson - Office Operations resume.pdf' -` returned exactly `zsh:1: command not found: pdftotext` from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`
**verified:** 2026-10-05 at 9:42 am Pacific, three local-resume inspection invocations returned exactly `zsh: command not found: pdftotext`; counting conservatively, this batch adds two net attempts because one October 5 Office Operations invocation was already recorded
**verified:** 2026-10-05, two generated-resume verification attempts returned exactly `zsh:1: command not found: pdftotext`, while `pdfinfo` was available and confirmed both outputs were valid one-page tagged PDFs
**verified:** 2026-10-05, another PDF text check in the job-applications environment returned exactly `zsh: command not found: pdftotext`; the bundled Python runtime with pypdf remained the available extraction route
**verified:** 2026-10-06, `pdfinfo` was available for resume QA while `pdftotext` again returned `command not found: pdftotext`; the bundled Python runtime with pypdf remained the selected extraction route
**verified:** 2026-10-14, system `pdfinfo` worked while a five-file generated-resume verification loop under `/tmp` printed exactly `zsh:4: command not found: pdftotext` once per PDF; no bundled runtime or pypdf extraction fallback was run for this batch
**where:** `/Users/zayah/Documents/Codex/2026-09-29/job-applications` and one `/tmp` generated-resume batch, PDF resume inspection in one macOS zsh environment

The twenty-three `pdftotext` failures establish that the default shell PATH did not provide the command in one environment but do not establish whether the binary is absent elsewhere on the machine; different PDF paths do not provide independent environment subjects.

**Why:** still held back after twenty-three `pdftotext` attempts and three other unavailable routes in one environment; there are not five observations from five different environment subjects, and the durable fix for the October 14 batch is UNCONFIRMED.
**Fix:** for previously verified files, read the artifact's source script when present or use `/Users/zayah/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3` with pypdf and require non-empty expected text; for the October 14 batch, the PDF skill's bundled-tool or pypdf fallback remains UNCONFIRMED until run against all five files.

### Git commands exited 128 with `fatal: not a git repository` across 6 sessions and 2 job workspaces

**verified:** 2026-10-05, from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`, both `git status` and `git log -- outputs/job-application-tracker.xlsx` exited 128 and printed exactly `fatal: not a git repository (or any of the parent directories): .git`
**verified:** 2026-10-06, a library verification command accidentally ran `git fetch origin` and `git show origin/development:library/testing.md` from the same job-applications directory, and both returned the same exact `fatal: not a git repository` error
**verified:** 2026-10-06 at 5:25 am Pacific, `git status --short` from the same directory returned exactly `fatal: not a git repository (or any of the parent directories): .git`; a current comparison repeated that error while `git -C /Users/zayah/github/dotfiles rev-parse --show-toplevel` printed `/Users/zayah/github/dotfiles`
**verified:** 2026-10-06, another compound library lookup ran `git fetch origin`, `git show origin/development:library/testing.md`, and revision lookups from the job-applications directory; each returned `fatal: not a git repository`, while rerunning from `/Users/zayah/github/dotfiles` fetched and printed the expected library subject and branch hashes
**verified:** 2026-10-07, `git rev-parse --show-toplevel` from authoritative pipeline directory `/Users/zayah/Documents/Codex/life/01 💼 Jobs/03 🛠️ Tools/⚙️ Job Pipeline` returned exactly `fatal: not a git repository`; `git-root-preflight` rejected that path with the same Git error, accepted `/Users/zayah/github/dotfiles`, and printed `git-root-preflight: 2 fixtures passed`
**verified:** 2026-10-13, `git rev-parse --show-toplevel`, `git status --short`, `git branch --show-current`, and `git remote -v` from the same authoritative pipeline directory each returned exactly `fatal: not a git repository (or any of the parent directories): .git`; a current paired check reproduced that output and `git-root-preflight` printed `not a Git worktree` for the exact path
**where:** six command sessions across two non-Git job workspaces

Git history cannot recover or promote workspace changes from either directory because neither path is inside a Git repository.

**Why:** still held back at n=6 command sessions from two workspace subjects; there are not five observations from five different subjects.
**Fix:** run `git-root-preflight <candidate>` before applying commit or promotion rules, then run repository commands through `git -C` against the returned root. For tracker recovery, inspect the current workbook, source log, generated artifacts, and explicit backups instead of relying on Git history; do not initialize a repository as a recovery shortcut.

### Git canonicalized one macOS temporary repository from `/var/...` to `/private/var/...`

**verified:** 2026-10-07, the first `git-root-preflight --self-test` rejected its initialized-repository fixture with `expected initialized-worktree acceptance`; inspection showed Git returned the canonical `/private/var/...` root while Python's unnormalized fixture string used `/var/...`, and comparing `Path(...).resolve()` values made both fixtures pass
**where:** one temporary Git repository created by the `git-root-preflight` self-test on macOS

The mismatch was a path-alias comparison inside the check, not a Git repository failure.

**Why:** REJECT at n=1 from one temporary-path subject; there are not five observations from five different subjects.
**Fix:** canonicalize both the Git-reported root and expected path before equality checks; the corrected self-test prints `git-root-preflight: 2 fixtures passed`.

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
