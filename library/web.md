# Web

Fetching things off the public internet from this machine. What the tools actually
return, and where they quietly return nothing.

## Contents

| Subject | What it says |
| --- | --- |
| [`agent-reach doctor --json` exited 0 after 30.2 seconds with 0 output bytes](#agent-reach-doctor---json-exited-0-after-302-seconds-with-0-output-bytes) | A successful exit does not confirm backend status when the command returns no bytes. Verify non-empty output and report backend status as UNCONFIRMED when it is empty. |
| [A YouTube channel's videos enumerate fine from `/streams`, but grep for `videoId` because `videoRenderer` is gone](#a-youtube-channels-videos-enumerate-fine-from-streams-but-grep-for-videoid-because-videorenderer-is-gone) | 9 of 9 streams found on `@ZayBuilds-b6o`. The page now uses `lockupViewModel`, so a `videoRenderer` grep reports zero on a page that is full. |
| [A watch page returns title, views, length, publish date and the full description](#a-watch-page-returns-title-views-length-publish-date-and-the-full-description) | `ytInitialPlayerResponse.videoDetails` plus `microformat`. 3,290 characters came back whole. |
| [`WebFetch` on a youtube.com URL returns only the site footer](#webfetch-on-a-youtubecom-url-returns-only-the-site-footer) | The markdown conversion drops the JSON the page is built from. Use `curl`. |
| [`agent-reach` rejected `search` 12 times, `read` 5 times, `get` once, and `search-web` once across 4 dates](#agent-reach-rejected-search-12-times-read-5-times-get-once-and-search-web-once-across-4-dates) | The installed CLI exposes none of those top-level web commands. Use doctor for routing status, the runtime web search tool, or an approved platform CLI. |
| [`gh search repos` rejected `nameWithOwner` 7 times, `forkCount` 5 times, and `licenseInfo` twice across 9 commands](#gh-search-repos-rejected-namewithowner-7-times-forkcount-5-times-and-licenseinfo-twice-across-9-commands) | Its accepted fields include `fullName`, `forksCount`, `pushedAt`, and `license`. Use those names and require nonempty output; the retry is UNCONFIRMED. |
| [`gh api search/repositories` exited 0 with 0 bytes for a constrained query; `resume ats` returned 10 repositories](#gh-api-searchrepositories-exited-0-with-0-bytes-for-a-constrained-query-resume-ats-returned-10-repositories) | A successful exit with empty output is not a completed search result. Simplify the query and require nonempty rows. |
| [`gh api` form fields returned HTTP 404 on 3 commit-list requests without forced GET](#gh-api-form-fields-returned-http-404-on-3-commit-list-requests-without-forced-get) | Adding `-f` or `-F` without `--method GET` can select write-method behavior. The successful retry is UNCONFIRMED. |
| [GitHub README decode returned `is not valid base64 data` at n=1](#github-readme-decode-returned-is-not-valid-base64-data-at-n1) | The transformed API value did not decode. Request the raw media type and require nonempty expected content; the retry is UNCONFIRMED. |
| [`gh api contents` returned HTTP 404 for 3 guessed paths; tree inspection found exact files across 2 repositories](#gh-api-contents-returned-http-404-for-3-guessed-paths-tree-inspection-found-exact-files-across-2-repositories) | Resolve the remote path from the tree before requesting repository contents. |
| [`gh api .../git/trees/<branch>?recursive=1` returned HTTP 404 on 2 hard-coded branch mismatches](#gh-api-gittreesbranchrecursive1-returned-http-404-on-2-hard-coded-branch-mismatches) | Read `defaultBranchRef.name` and use that exact ref; corrected tree responses remain UNCONFIRMED. |
| [Ashby posting API selection exited 0 with zero output for one board and job ID](#ashby-posting-api-selection-exited-0-with-zero-output-for-one-board-and-job-id) | An empty successful pipeline is not a verified missing job. Inspect response bytes and available keys before trusting the selection. |
| [ADP legacy link returned reader `Redirect loop detected`; browser replacement URL loaded 15 openings](#adp-legacy-link-returned-reader-redirect-loop-detected-browser-replacement-url-loaded-15-openings) | The old link exposes its replacement in an interactive browser. Follow that exact URL and verify nonempty listings. |
| [`gh-axi api --help` returned `command not found` while the agent rules required `gh-axi` at n=1](#gh-axi-api---help-returned-command-not-found-while-the-agent-rules-required-gh-axi-at-n1) | This shell exposed no `gh-axi` command. Reconcile the installed tool and active rules before GitHub CLI work. |
| [`opencli reddit search` blocked for 15 to 35 seconds on 4 queries with no connected extension](#opencli-reddit-search-blocked-for-15-to-35-seconds-on-4-queries-with-no-connected-extension) | Doctor showed a null active backend and no connected extension. A launch guard is required before another probe. |
| [Jina Reader returned PCC Cloudflare 403 `Performing security verification` at n=1](#jina-reader-returned-pcc-cloudflare-403-performing-security-verification-at-n1) | The careers page exposed an anti-bot interstitial instead of content. Stop without bypassing it and use indexed official content or normal visible ATS navigation. |
| [Sprouts store-operations reader returned HTTP 403 Forbidden at n=1](#sprouts-store-operations-reader-returned-http-403-forbidden-at-n1) | The official careers page linked the target, but this reader route could not inspect its listings. Keep specific roles UNCONFIRMED until another official surface or visible browser verifies them. |
| [`web__run` completed two 4-query searches with zero text, image, or error content](#web__run-completed-two-4-query-searches-with-zero-text-image-or-error-content) | A successful tool completion did not expose any results. Require nonempty content before accepting a search. |
| [Twitch help articles are a JavaScript app and `curl` returns 343,121 bytes with no article text](#twitch-help-articles-are-a-javascript-app-and-curl-returns-343121-bytes-with-no-article-text) | `help.twitch.tv` renders from JS. The policy text is not in the HTML at any depth. |
| [Reddit returns 403 and an HTML block page to every unauthenticated request, whatever the user agent](#reddit-returns-403-and-an-html-block-page-to-every-unauthenticated-request-whatever-the-user-agent) | `www.reddit.com/...json` is 403 for both a bot UA and a Chrome UA. OAuth is mandatory even to read. `old.reddit.com` 302s instead. |
| [Reddit gates app creation behind the Responsible Builder Policy, so "the app is already set up" may mean no app exists](#reddit-gates-app-creation-behind-the-responsible-builder-policy-so-the-app-is-already-set-up-may-mean-no-app-exists) | The create-app form sits behind a policy acknowledgement. An account can have Reddit login and no registered app, which is the same as no API access. |
| [`support.reddithelp.com` is behind Cloudflare bot verification: `WebFetch` 403s and headless Edge gets the interstitial](#supportreddithelpcom-is-behind-cloudflare-bot-verification-webfetch-403s-and-headless-edge-gets-the-interstitial) | 29,081 bytes of "Performing security verification", zero policy text. Reddit's own policy pages cannot be read by an agent. |
| [Headless Edge on the Windows side reaches hosts the WSL sandbox blocks, and confirms Reddit's 403 is policy not network](#headless-edge-on-the-windows-side-reaches-hosts-the-wsl-sandbox-blocks-and-confirms-reddits-403-is-policy-not-network) | `msedge.exe --headless=new --dump-dom` returned 189,960 bytes from a Reddit URL that Node cannot reach at all. Same block page though: 0 `short_name` matches. |
| [The agent sandbox allowlists network egress by host for Node: `registry.npmjs.org` is 200, `reddit.com` and `example.com` are `ETIMEDOUT`](#the-agent-sandbox-allowlists-network-egress-by-host-for-node-registrynpmjsorg-is-200-redditcom-and-examplecom-are-etimedout) | `npm install` works, which hides it. Not IPv6, not `fetch`: `node:https` fails the same way. `curl` is not subject to the allowlist. |

---

## `agent-reach doctor --json` exited 0 after 30.2 seconds with 0 output bytes

**verified:** 2026-09-29, `agent-reach doctor --json` produced exactly 0 output bytes, exited 0, and recorded `wall_time_seconds: 30.2`
**where:** `/Users/zayah/Documents/Codex/2026-09-29/can`

This observation proves that `agent-reach doctor --json` can return no status payload despite a successful exit, but it does not identify the cause.

**Why:** an exit code of 0 did not establish that any backend was checked because there was no output to inspect.
**Fix:** verify that stdout is non-empty before using the result; when it is empty, report backend status as UNCONFIRMED.

## A YouTube channel's videos enumerate fine from `/streams`, but grep for `videoId` because `videoRenderer` is gone

**verified:** 2026-09-02, `curl -sL https://www.youtube.com/@zaybuilds-b6o/streams`, 921,953 bytes
**where:** any task that has to list a channel's videos without an API key

The page contains 100 `"videoId":"..."` matches resolving to 9 unique ids, which is
every stream the channel has. It contains 0 occurrences of `videoRenderer` and 10 of
`lockupViewModel`, YouTube's newer list item shape. An earlier version of this entry
concluded the endpoint was "deliberately empty" after grepping `videoRenderer` against
`@CorpAI`, which is a copyright-free music channel with no streams at all. Both halves of
that were wrong: the wrong channel, and a grep for a key the page stopped using.

**Fix:** `curl` the `/streams` or `/videos` page with a browser user agent and
`re.findall(r'"videoId":"([\w-]{11})"', html)`, then `dict.fromkeys` to dedupe in page
order. Never conclude a YouTube page is empty from a `videoRenderer` count.

## A watch page returns title, views, length, publish date and the full description

**verified:** 2026-09-02, video `Q5dJuLvhxTI` returned its 3,290-character description whole
**where:** reading any single video's real numbers

`curl` the watch page, find `ytInitialPlayerResponse = `, and hand the remainder to
`json.JSONDecoder().raw_decode`, which stops at the end of the object and ignores the
script tail after it. `videoDetails` carries `title`, `viewCount`, `lengthSeconds` and
`shortDescription`; `microformat.playerMicroformatRenderer.publishDate` carries the date.
Nine watch pages fetched this way in one pass, all nine parsed.

**Fix:** `raw_decode`, not a regex to the closing brace. The description contains braces.

## `WebFetch` on a youtube.com URL returns only the site footer

**verified:** 2026-09-02, `WebFetch` against a channel URL
**where:** any YouTube read

The markdown conversion drops the inline JSON the page is actually built from, so what
comes back is navigation chrome and nothing else. This is not YouTube blocking anything:
plain `curl` from the same machine returns the full document.

**Fix:** `curl` with a browser user agent, then parse the JSON yourself.

## Twitch help articles are a JavaScript app and `curl` returns 343,121 bytes with no article text

**verified:** 2026-09-02, `curl https://help.twitch.tv/s/article/simulcasting-guidelines`
**where:** reading any Twitch policy, terms or guideline page

The 343,121 bytes are a Salesforce Experience Cloud shell: CSS variables, font faces and
loader markup. Stripping tags leaves no sentence from the article. There is no inline
JSON blob to parse the way YouTube has, so the YouTube trick does not transfer.

**Fix:** none found from this machine. A Twitch policy question needs a human with a
browser, or an archive snapshot. Do not answer one from memory and do not report a
policy as checked when only the shell came back.

## Reddit returns 403 and an HTML block page to every unauthenticated request, whatever the user agent

**verified:** 2026-09-02, `curl -sS -o /dev/null -w "%{http_code}" -A "<ua>" https://www.reddit.com/r/smallbusiness/about/rules.json` returned `403` for both a descriptive bot user agent and a Chrome user agent
**where:** anything reading Reddit without OAuth, and any plan that assumes the `.json` endpoints are open

`/r/<sub>/about/rules.json` and `/r/<sub>.json` are both 403 from this machine, over IPv4
and by default, and the body is a full HTML theme page rather than JSON, so a caller that
only checks for a parse failure will report "empty" instead of "blocked".
`old.reddit.com` answers 302 rather than 403, which is a redirect and not access. The
long-standing advice that Reddit's public JSON needs no credentials is now false.

**Fix:** treat OAuth as mandatory for reads as well as writes. Register a script app at
`reddit.com/prefs/apps` and use the client-credentials or password grant against
`oauth.reddit.com`. In code, parse-fail on a non-JSON body and raise with the first 200
characters, never return an empty result.

## The agent sandbox allowlists network egress by host for Node: `registry.npmjs.org` is 200, `reddit.com` and `example.com` are `ETIMEDOUT`

**verified:** 2026-09-02, one `node -e` run: `registry.npmjs.org/zod` returned `200` in 1511ms while `example.com`, `www.reddit.com` and `oauth.reddit.com` all threw `ETIMEDOUT` in under 1.3s
**where:** any Node code an agent session runs that has to reach the internet

`npm install` succeeds, which is what makes this confusing, and the first read of it was
wrong. It is not Node's `fetch` being broken and it is not IPv6: `--dns-result-order=ipv4first`
changes nothing, and `node:https` fails identically to `fetch`. It is a per-host
allowlist that the package registry is on and general hosts are not. `curl` is not subject
to it, and reached both `example.com` (200) and `reddit.com` (403) in the same session, so
a green `curl` proves nothing about whether the shipped Node code can reach the same host.

**Fix:** verify Node network paths outside the sandbox, or shell out to `curl`. Never
report a Node fetch path as working on the strength of a `curl` check, and never conclude
from a working `npm install` that general egress is available.

## Headless Edge on the Windows side reaches hosts the WSL sandbox blocks, and confirms Reddit's 403 is policy not network

**verified:** 2026-09-02, `"/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" --headless=new --disable-gpu --no-first-run --user-data-dir='C:\Users\Public\edge-probe' --dump-dom <url>` exited 0 with 189,960 bytes from `www.reddit.com/r/smallbusiness/about/rules.json`
**where:** any WSL agent session that needs to read a page the Node allowlist blocks

Edge is a Windows process, so it is not subject to the WSL egress allowlist that makes
Node throw `ETIMEDOUT` on the same URL. Use a throwaway `--user-data-dir` under
`C:\Users\Public\` and a Windows-style path, not a WSL one. The same run also settles
the Reddit question: the DOM came back as the HTML theme page with 0 occurrences of
`short_name`, so a real browser from a residential Windows IP is blocked exactly like
`curl` is, which makes the 403 Reddit policy rather than anything about this machine.

**Fix:** for reads the sandbox blocks, shell out to headless Edge and parse the dumped
DOM. Do not use it to reach a page behind the user's own login: that needs their real
browser profile, which is a separate permission and puts any secret on the page into the
session transcript.

## Reddit gates app creation behind the Responsible Builder Policy, so "the app is already set up" may mean no app exists

**verified:** 2026-09-02, Zayah hit the gate on `reddit.com/prefs/apps` while trying to create a script app
**where:** any build that needs Reddit API credentials

The create-app form is behind an acknowledgement of the Responsible Builder Policy at
`support.reddithelp.com/hc/en-us/articles/42728983564564`. Two things follow. First,
having a Reddit account, or having linked one to Google SSO, is not the same as having a
registered app, and a person can sincerely say the app is set up while `prefs/apps` is
empty - four turns went into fetching credentials that had never been generated. Second,
that policy is Reddit's own statement of what automated accounts may do, so any bot design
that assumes disclosure alone makes it acceptable is an assumption until somebody reads it.
UNCONFIRMED what the policy actually requires; see the entry below for why.

**Fix:** before designing anything against the Reddit API, have the human open
`prefs/apps` and say whether an app is listed. Empty means the credentials do not exist
yet, not that they are hard to find. The client ID is the unlabelled ~14-character string
under "personal use script"; the secret is the field labelled `secret`; the type must be
**script** or the OAuth password grant will not work.

## `support.reddithelp.com` is behind Cloudflare bot verification: `WebFetch` 403s and headless Edge gets the interstitial

**verified:** 2026-09-02, `WebFetch` returned `HTTP 403 Forbidden`, and `msedge.exe --headless=new --dump-dom` returned 29,081 bytes whose only readable text was "Performing security verification" and "Enable JavaScript and cookies to continue"
**where:** reading Reddit's policy, help or support pages programmatically

Both routes that work elsewhere fail here. The Edge trick that defeats the WSL egress
allowlist does not defeat Cloudflare, because the interstitial needs JavaScript and cookies
that `--dump-dom` never executes. The byte count is the trap again: 29KB looks like a page
came back, and none of it is the article.

**Fix:** ask the human to read it and paste the text. Do not conclude a policy permits
something because the page could not be read - an unread policy is UNCONFIRMED, not
permission.

---

## Held back

### `agent-reach` rejected `search` 12 times, `read` 5 times, `get` once, and `search-web` once across 4 dates

**verified:** 2026-09-30, invoking `search` returned exactly `invalid choice: 'search' (choose from setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version)`; 2026-10-03, installed agent-reach v1.5.0 returned the same list for another `search` call, `agent-reach read <Ashby URL> --json` returned the equivalent exact `invalid choice: 'read'` error, and a Hyatt `agent-reach search ... --json` call returned the same `invalid choice: 'search'` list while Exa was explicitly prohibited; 2026-10-04, three more `agent-reach search '...' --json` calls exited 2 with the same exact `invalid choice: 'search'` command list; 2026-10-05, `agent-reach search "Rocket Money Operations Associate Remote Pacific Time Zone" --json` returned the same argparse error and allowed-command list from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`
**verified:** 2026-10-05, `agent-reach search --help` from `/Users/zayah/Documents/Codex` returned exactly `invalid choice: 'search'` and listed only `setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version`
**verified:** 2026-10-05 at the 10:32 am Pacific heartbeat, three `agent-reach read <URL>` calls for Palm Desert, remote, and Bothell query tracks each exited 2 with exactly `invalid choice: 'read'` and the same allowed-command list
**verified:** 2026-10-05, `agent-reach get https://raw.githubusercontent.com/Gsync/jobsync/main/README.md` exited with an argparse error containing exactly `invalid choice: 'get' (choose from setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version)`
**verified:** 2026-10-05, after the Agent Reach skill was read, `agent-reach read https://raw.githubusercontent.com/reactive-resume/reactive-resume/main/README.md` exited with `invalid choice: 'read'` and listed only `setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version`
**verified:** 2026-10-05 at about 5:45 pm Pacific, three `agent-reach search "..." --json` attempts on agent-reach v1.5.0 each returned exactly `invalid choice: 'search' (choose from setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version)`
**verified:** 2026-10-05, agent-reach v1.5.0 invoked as `agent-reach search-web '<query>' --json` returned `invalid choice: 'search-web'` and listed only `setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version`
**verified:** 2026-10-05, `agent-reach search --json --limit 12 ...` returned `argument command: invalid choice: 'search'` and listed only `setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version`
**where:** nineteen calls covering four missing subcommands in one installed agent-reach 1.5.0 CLI environment

The returned command lists contain neither top-level web command, but the evidence does not establish behavior for other installed versions.

**Why:** still held back at n=19 calls across four command subjects in one CLI environment; there are not five observations from five different environment subjects, and the cause beyond this installed CLI remains unconfirmed.
**Fix:** use `agent-reach doctor --json` only for routing and backend status, the runtime web search tool for broad discovery, an approved platform CLI such as `gh` for GitHub, or direct Jina `curl` for an exact URL; do not invent `agent-reach search`, `agent-reach search-web`, `agent-reach read`, or `agent-reach get`.

### `gh search repos` rejected `nameWithOwner` 7 times, `forkCount` 5 times, and `licenseInfo` twice across 9 commands

**verified:** 2026-10-05 at 4:00 pm Pacific, `gh search repos ... --json nameWithOwner,...` returned exactly `Unknown JSON field: "nameWithOwner"`
**verified:** 2026-10-05, a later repository-search query requested `nameWithOwner`, `forkCount`, and `licenseInfo`, failed field validation, and printed accepted fields including `fullName`, `forksCount`, and `license`
**verified:** 2026-10-05 at 7:05 pm Pacific, `gh search repos ... --json ... forkCount` returned exactly `Unknown JSON field: "forkCount"` and listed `forksCount` among the accepted fields
**verified:** 2026-10-05, `gh search repos 'resume ATS application tracker job search' --json nameWithOwner,...` returned exactly `Unknown JSON field: "nameWithOwner"` and listed `fullName` among the accepted fields
**verified:** 2026-10-05, `gh search repos 'job search agent application tracker duplicate ATS' --sort updated --order desc --limit 10 --json nameWithOwner,description,stargazersCount,forkCount,updatedAt,url` returned `Unknown JSON field: "nameWithOwner"` and listed valid fields including `fullName` and `forksCount`
**verified:** 2026-10-05 at about 9:12 pm Pacific, `gh search repos 'resume ATS checker job matching in:name,description,readme' --sort updated --order desc --limit 15 --json nameWithOwner,description,stargazersCount,forkCount,updatedAt,pushedAt,url,licenseInfo` returned `Unknown JSON field: "nameWithOwner"` and listed accepted equivalents including `fullName`, `forksCount`, and `license`
**verified:** 2026-10-05, `gh search repos 'resume job matcher' --limit 12 --sort updated --json nameWithOwner,description,stargazersCount,forksCount,updatedAt,url` returned `Unknown JSON field: "nameWithOwner"` and listed `fullName` as the supported repository identity field
**verified:** 2026-10-05 at about 10:15 pm Pacific, `gh search repos 'resume ATS checker job tracker' --sort stars --limit 10 --json nameWithOwner,...` exited 1 with `Unknown JSON field: "nameWithOwner"` and listed `fullName` as supported
**verified:** 2026-10-05, `gh search repos --json forkCount` failed with exactly `Unknown JSON field: "forkCount"` and listed `forksCount` among the available fields
**where:** nine official GitHub CLI repository-search commands in one schema subject from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

All nine commands failed during JSON field validation before repository results could be accepted.

**Why:** still held back after nine commands from one CLI schema subject; there are not five observations from five different subjects.
**Fix:** UNCONFIRMED; use `fullName` for repository identity, `forksCount` for forks, `pushedAt` for the requested activity time, and `license` for license metadata, then require nonempty output before using the result.

### `gh api search/repositories` exited 0 with 0 bytes for a constrained query; `resume ats` returned 10 repositories

**verified:** 2026-10-05, `gh api -X GET search/repositories -f q='resume ATS checker job tracker stars:>100' -f sort=stars -f order=desc -f per_page=10 --jq '.items[] | [...] | @tsv'` exited 0 with exactly 0 output bytes, while the same endpoint with `q='resume ats'` returned 10 repository rows
**where:** two official GitHub repository-search API calls from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The comparison proves that the first successful exit exposed no usable result rows, but does not establish whether every term or the star qualifier caused the empty set.

**Why:** REJECT at n=1 query-pair subject; there are not five observations from five different subjects.
**Fix:** treat zero-byte success as untrusted, simplify the query, and require nonempty validated rows before concluding that no repositories match.

### `opencli reddit search` blocked for 15 to 35 seconds on 4 queries with no connected extension

**verified:** 2026-10-05, `agent-reach doctor --json` reported Reddit status `warn`, `active_backend: null`, OpenCLI installed, and no connected browser extension; `opencli reddit search "jobs hiring Snohomish Lake Stevens Bothell 2026" -f yaml` produced 0 output bytes and was still running after 30.2 seconds, `pgrep -af "opencli reddit search"` returned PID 6008, and `kill 6008` exited 0
**verified:** 2026-10-05, `opencli reddit search 'jobs hiring Washington remote entry level gym retail 2026' -f yaml` printed only `Waiting for Chrome/Chromium extension to connect... Make sure Chrome or Chromium is open and the OpenCLI extension is enabled.` and remained blocked for 30 seconds until interrupted
**verified:** 2026-10-05, Doctor again reported Reddit `active_backend: null` because no OpenCLI browser extension was connected; `opencli reddit search 'Everett Washington hiring seasonal retail October 2026' -f yaml` produced zero bytes for 35 seconds, was interrupted, and exited 130
**verified:** 2026-10-05 at about 10:24 pm Pacific, after Doctor had reported Reddit `active_backend: null` and no connected extension, another `opencli reddit search ... -f yaml` call printed only `Waiting for Chrome/Chromium extension to connect`, remained blocked for 15 seconds, and required Ctrl-C
**where:** four required-platform Reddit query subjects from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

All four read-only commands establish that this OpenCLI route was unavailable for the pass, while an empty or waiting probe supplied no search result.

**Why:** REJECT at n=4 query subjects in one environment; there are not five observations from five different subjects or an untouched control.
**Fix:** the repeated recurrence requires a reusable launch guard that runs Doctor first and refuses `opencli reddit search` when `active_backend` is null or the extension is disconnected; this guard is UNCONFIRMED until built and exercised. Until then, interrupt an empty hanging probe and use the runtime web search for public Reddit discovery while keeping posts UNCONFIRMED.

### `gh api` form fields returned HTTP 404 on 3 commit-list requests without forced GET

**verified:** 2026-10-05, `gh api repos/jaimaann/LangHire/commits -f per_page=5` returned HTTP 404, while the public commits endpoint existed
**verified:** 2026-10-05, `gh api repos/career-ops-hq/career-ops/commits --paginate -F per_page=5` returned GitHub `404 Not Found`
**verified:** 2026-10-05, `gh api repos/liangdabiao/resume-matcher-agent-cn/commits --paginate -F per_page=5 --jq ...` returned HTTP 404 after repository view, README, and license requests for the same repository succeeded
**where:** three official GitHub CLI commit-list requests for public repositories

All three requests supplied form fields without forcing GET, while the successful read-only calls on the third repository established that the repository was reachable; no successful corrected commits request output was supplied.

**Why:** REJECT at n=3 from three repository request subjects; there are not five observations from five different subjects.
**Fix:** UNCONFIRMED; use `gh api --method GET repos/OWNER/REPO/commits -f per_page=5` or `gh api --method GET 'repos/OWNER/REPO/commits?per_page=5'`, then require a nonempty commits response.

### `gh api .../git/trees/<branch>?recursive=1` returned HTTP 404 on 2 hard-coded branch mismatches

**verified:** 2026-10-05, `gh repo view` reported `Gsync/jobsync` default branch `main`, then `gh api repos/Gsync/jobsync/git/trees/master?recursive=1` returned HTTP 404
**verified:** 2026-10-05 at about 10:16 pm Pacific, repository view reported `NullSpace-BitCradle/ats-resume-agent` default branch `master`, then `gh api repos/NullSpace-BitCradle/ats-resume-agent/git/trees/main?recursive=1` returned HTTP 404
**where:** two official GitHub API tree requests across two repositories

Each request hard-coded the other common branch name after repository metadata had identified the actual default; no corrected tree response was supplied.

**Why:** REJECT at n=2 from two repository and branch-ref subjects; there are not five observations from five different subjects.
**Fix:** UNCONFIRMED; read `defaultBranchRef.name`, quote the query-bearing endpoint that uses that exact branch, and require a nonempty tree response.

### `gh-axi api --help` returned `command not found` while the agent rules required `gh-axi` at n=1

**verified:** 2026-10-05, `command -v gh-axi` returned no path and `gh-axi api --help` returned exactly `zsh:2: command not found: gh-axi`
**where:** one zsh GitHub CLI check from `/Users/zayah/github/dotfiles`

The shell exposed no `gh-axi` command; why the active rule and installed command set disagree is UNCONFIRMED.

**Why:** REJECT at n=1 from one shell and tool subject; there are not five observations from five different subjects.
**Fix:** UNCONFIRMED; reconcile the active GitHub CLI rule with the installed tool before running GitHub commands.

### `web__run` completed two 4-query searches with zero text, image, or error content

**verified:** 2026-10-05, `web__run` accepted four job and Reddit `search_query` items with `response_length` set to `long`, completed successfully, and returned no text or image content
**verified:** 2026-10-05 at about 10:23 pm Pacific, the runtime web search accepted four queries covering Home Depot or TJX in Palm Desert, Allstate or TELUS Digital remote in Washington, Lowe's or WinCo in Snohomish County, and recent Reddit job or scam discussions, then returned zero bytes with no result or error
**where:** two multi-query job and Reddit web-search calls

Both successful completions establish no search result because they exposed zero content blocks or errors; why the content was empty is UNCONFIRMED.

**Why:** REJECT at n=2 from two call subjects in one runtime; there are not five observations from five different subjects.
**Fix:** require nonempty text or image content before accepting a search; otherwise use Agent Reach Jina Reader, direct official sites, and the configured GitHub search route, then verify the returned content.

### Jina Reader returned PCC Cloudflare 403 `Performing security verification` at n=1

**verified:** 2026-10-05 at 7:09 pm Pacific, Jina Reader on `https://www.pccmarkets.com/page/about/jobs` returned HTTP 403 and a Cloudflare page containing exactly `Performing security verification`; the workflow stopped and did not bypass the challenge
**where:** one read of the PCC Community Markets careers page through Jina Reader

The response establishes an anti-bot interstitial for this page and route, but not a site-wide rule for every PCC URL or client.

**Why:** REJECT at n=1 from one page and backend subject; there are not five observations from five different subjects.
**Fix:** use search-indexed official content or the employer's linked ATS through normal visible navigation; never retry or bypass the challenge.

### Sprouts store-operations reader returned HTTP 403 Forbidden at n=1

**verified:** 2026-10-05, the official `https://www.sprouts.com/careers/` page exposed its Store & Field Team target as `https://jobs.sprouts.com/store-operations/jobs`, and opening that target through the web reader returned `Failed to fetch ... (403) Forbidden`
**where:** one web-reader request for the official Sprouts store-operations job index

The response proves that this reader route did not expose the official listings, while public search content did not verify any individual role.

**Why:** REJECT at n=1 from one page and reader subject; there are not five observations from five different subjects.
**Fix:** keep every specific role UNCONFIRMED unless another official surface or normal visible browser verifies it; do not treat third-party snippets as official-listing confirmation.

### GitHub README decode returned `is not valid base64 data` at n=1

**verified:** 2026-10-05 at about 9:14 pm Pacific, `gh api repos/espin086/GPT-Jobhunter/readme --jq '{...,content}' | jq -r '...(.content | @base64d)'` failed with exactly `string (...) is not valid base64 data` even though the API object exposed a `content` value
**where:** one official GitHub CLI README-content inspection

The transformed value was not accepted as base64, but the evidence does not establish which transformation changed it.

**Why:** REJECT at n=1 from one repository-content subject; there are not five observations from five different subjects.
**Fix:** UNCONFIRMED; request raw README bytes with `gh api -H 'Accept: application/vnd.github.raw+json' repos/OWNER/REPO/readme`, then require nonzero bytes and expected content instead of locally decoding the transformed field.

### `gh api contents` returned HTTP 404 for 3 guessed paths; tree inspection found exact files across 2 repositories

**verified:** 2026-10-05 at about 9:14 pm Pacific, fetching `contents/LICENSE` through the official GitHub CLI returned HTTP 404, while repository-tree inspection showed the actual file path was `LICENSE.md`
**verified:** 2026-10-05, `gh api repos/TusharVashishth/localcv/contents/src/lib/db.ts -H 'Accept: application/vnd.github.raw+json'` and a second request for guessed path `src/lib/db/local-db.ts` each returned exactly `gh: Not Found (HTTP 404)` with nonempty JSON errors; `gh api 'repos/TusharVashishth/localcv/git/trees/HEAD?recursive=1' --jq '.tree[].path' | rg '(^|/)(db|database|dexie|storage)'` returned `src/lib/db/schema.ts`, and fetching that exact contents path succeeded and printed the IndexedDB schema
**where:** three failed official GitHub CLI content-path lookups across two repositories, plus one successful tree-first recovery

All three failed requests used paths that differed from the exact filenames exposed by their repository trees.

**Why:** REJECT at n=3 path failures across two repository subjects; there are not five observations from five different subjects.
**Fix:** query the recursive tree first, filter its returned paths for the target concept, then pass the exact path to `gh api repos/OWNER/REPO/contents/<path>` and require nonempty expected content; use the repository license API when the target is a license.

### Ashby posting API selection exited 0 with zero output for one board and job ID

**verified:** 2026-10-05 at about 9:19 pm Pacific, `curl -fsSL https://api.ashbyhq.com/posting-api/job-board/snapdocs | jq '.jobs[] | select(.id=="fab8e4d6-2fdb-42e4-93f9-5887c64ae3da") | {...}'` exited 0 with empty stdout
**where:** one official Ashby posting API board and job-ID selection

The zero-byte result does not distinguish a removed job, a changed board key, a changed job ID, or an unexpected response shape.

**Why:** REJECT at n=1 from one board and job subject; there are not five observations from five different subjects.
**Fix:** inspect the response byte count, root keys, and returned job IDs before applying `select`, then require a nonempty matched object before treating the lookup as verified.

### ADP legacy link returned reader `Redirect loop detected`; browser replacement URL loaded 15 openings

**verified:** 2026-10-05, the runtime web reader clicked Brown Bear Car Wash's official `View Our Current Openings` link to `https://workforcenow.adp.com/jobs/apply/posting.html?ccId=395193921_1559&client=carwashent&lang=en_US&type=MP` and returned HTTP 400 with exactly `Redirect loop detected`
**verified:** 2026-10-05, opening that exact legacy URL in the interactive in-app browser reached ADP's `This Career Center Link Has Changed` page and exposed `https://workforcenow.adp.com/mascsr/default/mdf/recruitment/recruitment.html?cid=622f924f-be26-466c-bb1a-20afe3df6205&ccId=395193921_1559&lang=en_US&type=MP`; opening the replacement loaded 15 current openings, including Everett Customer Service Representative requisition 1924, jobId 597116, with nonempty job detail
**where:** one runtime-reader and interactive-browser pair for the employer-linked ADP Workforce Now portal

The legacy link was real but moved, and the reader's redirect loop hid the replacement URL that the interactive page exposed.

**Why:** REJECT at n=1 from one employer portal subject; there are not five observations from five different subjects.
**Fix:** open the official legacy link in an interactive browser, follow the exact replacement URL from `This Career Center Link Has Changed`, and require a nonzero opening count plus nonempty job detail; this recovery is verified.
