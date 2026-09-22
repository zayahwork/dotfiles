# testing

Test and build command failures whose real cause was the invocation or execution
environment rather than the source under test.

## Contents

- [From Cove's `source/cove-crm`, `../../../tests/sample-desk.test.ts` is one level too high; `../../tests/sample-desk.test.ts` passes 1 test.](#from-coves-sourcecove-crm-testsample-desktestts-is-one-level-too-high-testssample-desktestts-passes-1-test)
- [`getaddrinfo ENOTFOUND` and `curl: (6) Could not resolve host` are sandbox DNS boundaries when unchanged commands pass with approved network access.](#getaddrinfo-enotfound-and-curl-6-could-not-resolve-host-are-sandbox-dns-boundaries-when-unchanged-commands-pass-with-approved-network-access)

---

## From Cove's source/cove-crm, ../../../tests/sample-desk.test.ts is one level too high; ../../tests/sample-desk.test.ts passes 1 test

**verified:** 2026-09-20, `node --test ../../../tests/sample-desk.test.ts` exited 1 with `Could not find`, while `node --test ../../tests/sample-desk.test.ts` exited 0 with `tests 1`, `pass 1`, and `fail 0`
**where:** `Home/09 🏗️ Builds/Nate Pool Studio/source/cove-crm`

The CRM directory is two levels below the build folder, so three `..` segments climb above the folder that owns `tests/`.

**Why:** the failing path was calculated from the repository layout instead of the command's actual working directory.
**Fix:** run `node --test ../../tests/sample-desk.test.ts` from `source/cove-crm`.

---

## getaddrinfo ENOTFOUND and curl: (6) Could not resolve host are sandbox DNS boundaries when unchanged commands pass with approved network access

**verified:** 2026-09-20, sandboxed `npm run build` failed on `getaddrinfo ENOTFOUND fonts.googleapis.com` and the unchanged command completed the Next.js 15.5.25 build with approved network access; 2026-09-22, sandboxed `curl --max-time 20 --show-error --include https://r.jina.ai/https://pump.fun/` failed immediately with `curl: (6) Could not resolve host: r.jina.ai`, while the identical escalated command returned HTTP/2 200 and 26,172 decompressed bytes; 2026-09-22, three parallel `curl --max-time 20 --show-error` reads of `https://docs.typesafe.ai/llms.txt`, `/patterns/composite-scoring.md`, and `/confidence.md` each failed immediately with `curl: (6) Could not resolve host: docs.typesafe.ai`, then identical escalated reads succeeded with 16,019, 13,545, and 11,396 bytes respectively
**where:** `Home/09 🏗️ Builds/Nate Pool Studio/source/cove-crm`; `/Users/zayah/Downloads/home-main`

Build-time font fetching and read-only Jina fetching both require DNS, so a sandbox network boundary can fail before source or target-page behavior is evaluated.

**Why:** in both observations, the identical command passed when only network authority changed, isolating the failure to the sandbox boundary.
**Fix:** rerun the identical read-only command with approved network access; investigate the source or endpoint only if that rerun still fails.

---

## Held back

### `apply_patch verification failed: Failed to find expected lines in apps/extension/src/content.ts` at n=1

**verified:** 2026-09-22, one `apply_patch` attempt put the test-file hunk under the `apps/extension/src/content.ts` Update File header, failed atomically with the title's exact error, and changed no file
**where:** `/Users/zayah/Downloads/home-main`, a patch spanning `apps/extension/src/content.ts` and its test

The failure named `content.ts` because `apply_patch` tried to match test-file context inside that source file.

**Why:** REJECT at n=1; there are not five observations from five different subjects.
**Fix:** split the source and test hunks under their correct Update File headers.

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
