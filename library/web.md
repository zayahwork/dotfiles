# Web

Fetching things off the public internet from this machine. What the tools actually
return, and where they quietly return nothing.

## Contents

| Subject | What it says |
| --- | --- |
| [`agent-reach doctor --json` exited 0 after 30.2 seconds with 0 output bytes](#agent-reach-doctor---json-exited-0-after-302-seconds-with-0-output-bytes) | A successful exit does not confirm backend status when the command returns no bytes. Verify non-empty output and report backend status as UNCONFIRMED when it is empty. |
| [`agent-reach check-update` exited 0 after DNS failure; approved rerun verified v1.5.0 is current](#agent-reach-check-update-exited-0-after-dns-failure-approved-rerun-verified-v150-is-current) | Exit 0 and a current-version line do not prove the update check completed. Require an explicit latest-version or update-available result. |
| [A YouTube channel's videos enumerate fine from `/streams`, but grep for `videoId` because `videoRenderer` is gone](#a-youtube-channels-videos-enumerate-fine-from-streams-but-grep-for-videoid-because-videorenderer-is-gone) | 9 of 9 streams found on `@ZayBuilds-b6o`. The page now uses `lockupViewModel`, so a `videoRenderer` grep reports zero on a page that is full. |
| [A watch page returns title, views, length, publish date and the full description](#a-watch-page-returns-title-views-length-publish-date-and-the-full-description) | `ytInitialPlayerResponse.videoDetails` plus `microformat`. 3,290 characters came back whole. |
| [`WebFetch` on a youtube.com URL returns only the site footer](#webfetch-on-a-youtubecom-url-returns-only-the-site-footer) | The markdown conversion drops the JSON the page is built from. Use `curl`. |
| [`agent-reach` rejected `search` 29 times, `read` 5 times, `get` once, and `search-web` twice across 8 dates](#agent-reach-rejected-search-29-times-read-5-times-get-once-and-search-web-twice-across-8-dates) | The installed CLI exposes none of those top-level web commands. Use doctor for routing status, the runtime web search tool, or an approved platform CLI. |
| [`agent-reach skill` required `--install` or `--uninstall` at n=1](#agent-reach-skill-required---install-or---uninstall-at-n1) | This command manages the skill installation and is not usage documentation. Read `SKILL.md` for backend-specific search routes. |
| [`gh search repos` rejected `nameWithOwner` 17 times, `forkCount` 13 times, and `licenseInfo` 5 times across 24 commands](#gh-search-repos-rejected-namewithowner-17-times-forkcount-13-times-and-licenseinfo-5-times-across-24-commands) | Its accepted fields include `fullName`, `forksCount`, `pushedAt`, and `license`. The installed `shell-preflight` rejects the three unsupported aliases. |
| [2 constrained GitHub repository searches exited 0 with zero rows; `resume ats` returned 10 repositories](#2-constrained-github-repository-searches-exited-0-with-zero-rows-resume-ats-returned-10-repositories) | A successful exit with empty output is not a completed search result. Split the query and require nonempty rows. |
| [`gh search repos 'job application tracker stars:>100'` returned irrelevant, truncated description output at n=1](#gh-search-repos-job-application-tracker-stars100-returned-irrelevant-truncated-description-output-at-n1) | One narrow query produced no usable shortlist. Select one candidate and inspect its repository and exact files directly; that recovery is UNCONFIRMED. |
| [`gh api` form fields returned HTTP 404 on 4 commit-list requests without forced GET](#gh-api-form-fields-returned-http-404-on-4-commit-list-requests-without-forced-get) | Adding `-f` or `-F` without `--method GET` can select write-method behavior. The successful retry is UNCONFIRMED. |
| [GitHub README decode returned `is not valid base64 data` at n=1](#github-readme-decode-returned-is-not-valid-base64-data-at-n1) | The transformed API value did not decode. Request the raw media type and require nonempty expected content; the retry is UNCONFIRMED. |
| [`gh api` returned HTTP 404 for 10 assumed repository file locations or availability states; inspection exposed 9 layouts](#gh-api-returned-http-404-for-10-assumed-repository-file-locations-or-availability-states-inspection-exposed-9-layouts) | Resolve remote files from the tree and metadata before requesting contents, and do not decode an API error as file data. |
| [`gh api .../git/trees/<branch>?recursive=1` returned HTTP 404 on 10 hard-coded branch mismatches](#gh-api-gittreesbranchrecursive1-returned-http-404-on-10-hard-coded-branch-mismatches) | Read `defaultBranchRef.name` and use that exact ref; three corrected retries succeeded. |
| [Ashby posting API selection exited 0 with zero output for one board and job ID](#ashby-posting-api-selection-exited-0-with-zero-output-for-one-board-and-job-id) | An empty successful pipeline is not a verified missing job. Inspect response bytes and available keys before trusting the selection. |
| [ADP legacy link returned reader `Redirect loop detected`; browser replacement URL loaded 15 openings](#adp-legacy-link-returned-reader-redirect-loop-detected-browser-replacement-url-loaded-15-openings) | The old link exposes its replacement in an interactive browser. Follow that exact URL and verify nonempty listings. |
| [`gh-axi api --help` returned `command not found` while the agent rules required `gh-axi` at n=1](#gh-axi-api---help-returned-command-not-found-while-the-agent-rules-required-gh-axi-at-n1) | This shell exposed no `gh-axi` command. Reconcile the installed tool and active rules before GitHub CLI work. |
| [`opencli reddit search` blocked for 15 to 35 seconds on 7 queries with no connected extension](#opencli-reddit-search-blocked-for-15-to-35-seconds-on-7-queries-with-no-connected-extension) | Doctor showed a null active backend and no connected extension. A launch guard is required before another probe. |
| [Jina Reader returned PCC security-verification pages at n=2](#jina-reader-returned-pcc-security-verification-pages-at-n2) | Both reads exposed anti-bot interstitials instead of listings. Stop without bypassing them and use indexed official content or normal visible ATS navigation. |
| [Jina Reader returned Alaska status 42206 and a 3,707-byte Target 404 across 2 job-search routes](#jina-reader-returned-alaska-status-42206-and-a-3707-byte-target-404-across-2-job-search-routes) | These exact search routes did not expose listings. Treat them as failed source discovery, not evidence that jobs are absent. |
| [Jina Reader returned GovernmentJobs HTTP 403 `AbuseAlleviationError`; direct HTML yielded 207 listings](#jina-reader-returned-governmentjobs-http-403-abusealleviationerror-direct-html-yielded-207-listings) | One reader route was blocked, while direct public HTML remained readable. Verify bytes and distinct listing IDs before using the fallback. |
| [Sprouts store-operations reader returned HTTP 403 Forbidden at n=1](#sprouts-store-operations-reader-returned-http-403-forbidden-at-n1) | The official careers page linked the target, but this reader route could not inspect its listings. Keep specific roles UNCONFIRMED until another official surface or visible browser verifies them. |
| [Web open returned `Internal Error` on 2 Kroger job pages; Jina returned 11,801 and 5,476 bytes](#web-open-returned-internal-error-on-2-kroger-job-pages-jina-returned-11801-and-5476-bytes) | Jina exposed active job 225488 and the closed status for 203050. Verify nonempty output and the current status text. |
| [Pilot careers IAB navigation failed with `net::ERR_CERT_COMMON_NAME_INVALID` at n=1](#pilot-careers-iab-navigation-failed-with-neterr_cert_common_name_invalid-at-n1) | No page content loaded. Do not bypass the safety interstitial; find a certificate-valid official route. |
| [`web__run` completed 4 searches covering 13 queries with zero text, image, or error content](#web__run-completed-4-searches-covering-13-queries-with-zero-text-image-or-error-content) | A successful tool completion did not expose any results. Require nonempty content; Firecrawl returned results in the latest pass. |
| [4 Jina-wrapped Google searches returned 696 to 754 CAPTCHA bytes and 0 results](#4-jina-wrapped-google-searches-returned-696-to-754-captcha-bytes-and-0-results) | Exit 0 and nonempty output still hid every search result. Detect CAPTCHA or homepage content and switch search routes. |
| [Jina routes returned 8 unusable responses across 10 Brave, Yahoo, and Bing queries](#jina-routes-returned-8-unusable-responses-across-10-brave-yahoo-and-bing-queries) | Search-engine text is only a lead. Validate expected results, then verify candidates on official pages or platform APIs. |
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

## `agent-reach check-update` exited 0 after DNS failure; approved rerun verified v1.5.0 is current

**verified:** 2026-10-14, sandboxed `agent-reach check-update` printed `当前版本: v1.5.0` followed by `[!] 无法检查更新（DNS 解析失败，已重试 3 次）` and exited 0; the identical command with approved external network access printed `当前版本: v1.5.0` followed by `✅ 已是最新版本`
**where:** Agent Reach v1.5.0 end-of-task update checks

The first process completed successfully but did not verify update availability; the paired rerun changed only network authority and isolated this occurrence to the sandbox network boundary.

**Why:** exit 0 and a current-version line were present in the failed check, so neither is sufficient proof that the remote update check completed.
**Fix:** when the sandboxed command reports a DNS failure, rerun the identical read-only check with approved external network access and require an explicit latest-version or update-available result.

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

### `agent-reach` rejected `search` 29 times, `read` 5 times, `get` once, and `search-web` twice across 8 dates

**verified:** 2026-09-30, invoking `search` returned exactly `invalid choice: 'search' (choose from setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version)`; 2026-10-03, installed agent-reach v1.5.0 returned the same list for another `search` call, `agent-reach read <Ashby URL> --json` returned the equivalent exact `invalid choice: 'read'` error, and a Hyatt `agent-reach search ... --json` call returned the same `invalid choice: 'search'` list while Exa was explicitly prohibited; 2026-10-04, three more `agent-reach search '...' --json` calls exited 2 with the same exact `invalid choice: 'search'` command list; 2026-10-05, `agent-reach search "Rocket Money Operations Associate Remote Pacific Time Zone" --json` returned the same argparse error and allowed-command list from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`
**verified:** 2026-10-05, `agent-reach search --help` from `/Users/zayah/Documents/Codex` returned exactly `invalid choice: 'search'` and listed only `setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version`
**verified:** 2026-10-05 at the 10:32 am Pacific heartbeat, three `agent-reach read <URL>` calls for Palm Desert, remote, and Bothell query tracks each exited 2 with exactly `invalid choice: 'read'` and the same allowed-command list
**verified:** 2026-10-05, `agent-reach get https://raw.githubusercontent.com/Gsync/jobsync/main/README.md` exited with an argparse error containing exactly `invalid choice: 'get' (choose from setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version)`
**verified:** 2026-10-05, after the Agent Reach skill was read, `agent-reach read https://raw.githubusercontent.com/reactive-resume/reactive-resume/main/README.md` exited with `invalid choice: 'read'` and listed only `setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version`
**verified:** 2026-10-05 at about 5:45 pm Pacific, three `agent-reach search "..." --json` attempts on agent-reach v1.5.0 each returned exactly `invalid choice: 'search' (choose from setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version)`
**verified:** 2026-10-05, agent-reach v1.5.0 invoked as `agent-reach search-web '<query>' --json` returned `invalid choice: 'search-web'` and listed only `setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version`
**verified:** 2026-10-05, `agent-reach search --json --limit 12 ...` returned `argument command: invalid choice: 'search'` and listed only `setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version`
**verified:** 2026-10-06 at 12:35 am Pacific, four Reddit and career `agent-reach search '<query>' --json` calls each returned `invalid choice: 'search'` and listed only `setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version`
**verified:** 2026-10-06, four more job-applications heartbeat `agent-reach search '<query>' --json` calls each failed because the same 1.5.0 command list did not include `search`
**verified:** 2026-10-06, `agent-reach search 'site:careers.t-mobile.com REQ372961' --json` returned exactly `invalid choice: 'search'` and listed only `setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version`; an isolated rerun from `/tmp` reproduced the same usage output
**verified:** 2026-10-06, from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`, `agent-reach search 'site:remote.co/remote-jobs customer service operations entry level United States October 2026' --json --limit 10` exited 2 and printed usage with exactly `invalid choice: 'search'`, listing only `setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version`
**verified:** 2026-10-06, four more `agent-reach search "..." --json` calls each returned `invalid choice: 'search'` and the same allowed-command list from the job-applications workspace
**verified:** 2026-10-07, `agent-reach version` printed `Agent Reach v1.5.0`, and `agent-reach search 'library verification query' --json` exited 2 with exactly `invalid choice: 'search'` plus the same allowed-command list; `shell-preflight` rejected the nonexistent wrapper command, accepted `agent-reach doctor --json`, and its later expanded suite printed `shell-preflight: 33 fixtures passed`
**verified:** 2026-10-12, `agent-reach version` printed `Agent Reach v1.5.0`, and `agent-reach search 'library verification query' --json` exited 2 with exactly `invalid choice: 'search'` plus the same allowed-command list; `references/search.md` routed generic web discovery to the runtime web search tool and known URLs to Jina Reader, while `shell-preflight` rejected the nonexistent wrapper command and its self-test printed `shell-preflight: 33 fixtures passed`
**verified:** 2026-10-22, from `/tmp`, `agent-reach search-web --help` exited 2 with exactly `invalid choice: 'search-web'` and listed only `setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version`
**where:** thirty-seven calls covering four missing subcommands in one installed agent-reach 1.5.0 CLI environment

The returned command lists contain neither top-level web command, but the evidence does not establish behavior for other installed versions.

**Why:** still held back at n=37 calls across four command subjects in one CLI environment; there are not five observations from five different environment subjects, and the cause beyond this installed CLI remains unconfirmed.
**Fix:** follow `references/search.md`: use the runtime web search tool for broad discovery, Jina Reader for a known URL, an approved platform CLI such as `gh` for GitHub, and `agent-reach doctor --json` only for routing or backend status. Do not invent `agent-reach search`, `agent-reach search-web`, `agent-reach read`, or `agent-reach get`; run `shell-preflight '<planned command>'` first because it rejects all four nonexistent wrapper subcommands.

### `agent-reach skill` required `--install` or `--uninstall` at n=1

**verified:** 2026-10-06 at 12:35 am Pacific, `agent-reach skill` failed and reported that it requires `--install` or `--uninstall`
**where:** one agent-reach 1.5.0 skill-command invocation

The result shows that this command performs skill installation management rather than printing platform-search usage.

**Why:** REJECT at n=1 from one command and installed CLI subject; there are not five observations from five different subjects.
**Fix:** read the installed Agent Reach `SKILL.md` and invoke its documented backend-specific commands; do not use `agent-reach skill` as search documentation.

### `gh search repos` rejected `nameWithOwner` 17 times, `forkCount` 13 times, and `licenseInfo` 5 times across 24 commands

**verified:** 2026-10-05 at 4:00 pm Pacific, `gh search repos ... --json nameWithOwner,...` returned exactly `Unknown JSON field: "nameWithOwner"`
**verified:** 2026-10-05, a later repository-search query requested `nameWithOwner`, `forkCount`, and `licenseInfo`, failed field validation, and printed accepted fields including `fullName`, `forksCount`, and `license`
**verified:** 2026-10-05 at 7:05 pm Pacific, `gh search repos ... --json ... forkCount` returned exactly `Unknown JSON field: "forkCount"` and listed `forksCount` among the accepted fields
**verified:** 2026-10-05, `gh search repos 'resume ATS application tracker job search' --json nameWithOwner,...` returned exactly `Unknown JSON field: "nameWithOwner"` and listed `fullName` among the accepted fields
**verified:** 2026-10-05, `gh search repos 'job search agent application tracker duplicate ATS' --sort updated --order desc --limit 10 --json nameWithOwner,description,stargazersCount,forkCount,updatedAt,url` returned `Unknown JSON field: "nameWithOwner"` and listed valid fields including `fullName` and `forksCount`
**verified:** 2026-10-05 at about 9:12 pm Pacific, `gh search repos 'resume ATS checker job matching in:name,description,readme' --sort updated --order desc --limit 15 --json nameWithOwner,description,stargazersCount,forkCount,updatedAt,pushedAt,url,licenseInfo` returned `Unknown JSON field: "nameWithOwner"` and listed accepted equivalents including `fullName`, `forksCount`, and `license`
**verified:** 2026-10-05, `gh search repos 'resume job matcher' --limit 12 --sort updated --json nameWithOwner,description,stargazersCount,forksCount,updatedAt,url` returned `Unknown JSON field: "nameWithOwner"` and listed `fullName` as the supported repository identity field
**verified:** 2026-10-05 at about 10:15 pm Pacific, `gh search repos 'resume ATS checker job tracker' --sort stars --limit 10 --json nameWithOwner,...` exited 1 with `Unknown JSON field: "nameWithOwner"` and listed `fullName` as supported
**verified:** 2026-10-05, `gh search repos --json forkCount` failed with exactly `Unknown JSON field: "forkCount"` and listed `forksCount` among the available fields
**verified:** 2026-10-05, `gh search repos 'resume job tracker ats' --sort updated --limit 8 --json nameWithOwner,description,stargazersCount,pushedAt,url,license` exited 1 with exactly `Unknown JSON field: "nameWithOwner"` and listed `fullName` among the available fields
**verified:** 2026-10-06, another `gh search repos --json nameWithOwner,forkCount` command failed, while the accepted field names remained `fullName` and `forksCount`
**verified:** 2026-10-06, a job-applications heartbeat `gh search repos ... --json nameWithOwner,...,licenseInfo` command failed field validation because the accepted repository identity and license fields were `fullName` and `license`
**verified:** 2026-10-06, `gh search repos 'job application tracker duplicate detection resume ATS' --sort updated --limit 10 --json ...` returned nonempty stderr containing exactly `Unknown JSON field: "forkCount"` and listed `forksCount` among the valid fields
**verified:** 2026-10-06, `gh search repos 'job application tracker duplicate detection resume' --sort updated --order desc --limit 10 --json nameWithOwner,description,stargazersCount,forksCount,updatedAt,url` returned output beginning exactly `Unknown JSON field: "nameWithOwner"` and listed `fullName` among the available fields
**verified:** 2026-10-06, `gh search repos ... --json owner,name,description,stargazersCount,forkCount,pushedAt,updatedAt,url` returned exactly `Unknown JSON field: "forkCount"` and listed `forksCount` and `fullName`; a corrected `gh search repos 'resume' --sort updated --limit 10 --json owner,name,description,stargazersCount,forksCount,pushedAt,updatedAt,url` retry returned 3,686 bytes containing 10 repository rows
**verified:** 2026-10-06 at 2:55 am Pacific, another `gh search repos ... --json ... forkCount` command returned exactly `Unknown JSON field: "forkCount"`; the CLI again listed `forksCount` as valid
**verified:** 2026-10-06 at about 3:23 am Pacific, `gh search repos 'job application tracker ats resume' --sort updated --order desc --limit 20 --json nameWithOwner,description,stargazersCount,forkCount,updatedAt,url` returned nonempty field-validation error output and listed `fullName` and `forksCount` as the accepted exact names
**verified:** 2026-10-06, `gh search repos 'job application tracker' --sort stars --order desc --limit 20 --json nameWithOwner,description,stargazersCount,updatedAt,url` returned exactly `Unknown JSON field: "nameWithOwner"` and listed `fullName` as the available equivalent
**verified:** 2026-10-06, another `gh search repos ... --json forkCount,licenseInfo` command failed field validation and listed `forksCount` and `license` as the available exact names
**verified:** 2026-10-06, `gh search repos 'job application tracker ATS resume automation' --sort updated --order desc --limit 10 --json fullName,description,stargazersCount,forkCount,updatedAt,pushedAt,isArchived,license,url` exited 1 with exactly `Unknown JSON field: "forkCount"` and listed `forksCount` among the available fields
**verified:** 2026-10-06, `gh search repos 'job application tracker ats resume duplicate detection' --sort updated --order desc --limit 10 --json nameWithOwner,description,stargazersCount,updatedAt,url` exited 1 with exactly `Unknown JSON field: "nameWithOwner"` and listed `fullName` among the available fields
**verified:** 2026-10-06, `gh search repos 'resume ATS checker local in:name,description,readme' --limit 10 --json nameWithOwner,description,stargazersCount,forkCount,updatedAt,pushedAt,licenseInfo,url` failed JSON-field validation and listed the accepted replacements `fullName`, `forksCount`, and `license`
**verified:** 2026-10-06, `gh search repos 'resume ATS checker job application tracker' --sort stars --limit 8 --json nameWithOwner,description,stargazersCount,updatedAt,url` failed because `nameWithOwner` was unsupported and the CLI listed `fullName` as the supported equivalent
**verified:** 2026-10-06 during the 9:00 am Pacific hour, another `gh search repos --json nameWithOwner` call returned exactly `Unknown JSON field: "nameWithOwner"` and exposed `fullName`; the installed `shell-preflight` then rejected `nameWithOwner`, accepted `fullName`, and printed `shell-preflight: 16 fixtures passed`
**where:** twenty-four official GitHub CLI repository-search commands in one schema subject from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`, plus the installed field-name preflight in the dotfiles repository

All twenty-four commands failed during JSON field validation before repository results could be accepted.

**Why:** still held back after twenty-four commands from one CLI schema subject; the output proves this surface rejects the named fields, but not why other GitHub surfaces use different field names.
**Fix:** use `fullName` for repository identity in `gh search repos`, `forksCount` for forks, `pushedAt` for the requested activity time, and `license` for license metadata, then require nonempty output. Use `nameWithOwner` with `gh repo view` only after that subcommand lists it as accepted; this observation did not include that verification. Run `shell-preflight '<planned command>'` before execution; its verified field check rejects `nameWithOwner`, `forkCount`, and `licenseInfo` for `gh search repos` and names each accepted replacement.

### 2 constrained GitHub repository searches exited 0 with zero rows; `resume ats` returned 10 repositories

**verified:** 2026-10-05, `gh api -X GET search/repositories -f q='resume ATS checker job tracker stars:>100' -f sort=stars -f order=desc -f per_page=10 --jq '.items[] | [...] | @tsv'` exited 0 with exactly 0 output bytes, while the same endpoint with `q='resume ats'` returned 10 repository rows
**verified:** 2026-10-05, `gh search repos 'job application tracker ats resume ranking' --sort updated --order desc --limit 20 --json fullName,url,description,stargazersCount,forksCount,updatedAt,pushedAt,license,openIssuesCount` exited 0 and printed exactly `[]`
**where:** two constrained GitHub repository-search queries and one shorter control query from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

Both constrained searches exposed no usable result rows, but the comparison does not establish which terms or qualifiers caused the empty sets.

**Why:** REJECT at n=2 constrained-query subjects with one shorter control; there are not five observations from five different subjects.
**Fix:** split a constrained search into shorter independent queries and require nonempty validated rows before concluding that no repositories match; whether this recovers results for the second query is UNCONFIRMED.

### `gh search repos 'job application tracker stars:>100'` returned irrelevant, truncated description output at n=1

**verified:** 2026-10-06, `gh search repos 'job application tracker stars:>100'` returned a large repository-description response that included irrelevant material and was truncated before it yielded a usable narrow result set
**where:** one GitHub CLI repository search from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The output did not support selecting a repository from the narrow query; the component that performed the truncation and why irrelevant repositories were returned are UNCONFIRMED.

**Why:** REJECT at n=1 from one query and search-output subject; there are not five observations from five different subjects.
**Fix:** UNCONFIRMED; select one candidate repository, inspect it through the required GitHub wrapper's direct repository view, and read only targeted files instead of accepting broad repository-description output.

### `opencli reddit search` blocked for 15 to 35 seconds on 7 queries with no connected extension

**verified:** 2026-10-05, `agent-reach doctor --json` reported Reddit status `warn`, `active_backend: null`, OpenCLI installed, and no connected browser extension; `opencli reddit search "jobs hiring Snohomish Lake Stevens Bothell 2026" -f yaml` produced 0 output bytes and was still running after 30.2 seconds, `pgrep -af "opencli reddit search"` returned PID 6008, and `kill 6008` exited 0
**verified:** 2026-10-05, `opencli reddit search 'jobs hiring Washington remote entry level gym retail 2026' -f yaml` printed only `Waiting for Chrome/Chromium extension to connect... Make sure Chrome or Chromium is open and the OpenCLI extension is enabled.` and remained blocked for 30 seconds until interrupted
**verified:** 2026-10-05, Doctor again reported Reddit `active_backend: null` because no OpenCLI browser extension was connected; `opencli reddit search 'Everett Washington hiring seasonal retail October 2026' -f yaml` produced zero bytes for 35 seconds, was interrupted, and exited 130
**verified:** 2026-10-05 at about 10:24 pm Pacific, after Doctor had reported Reddit `active_backend: null` and no connected extension, another `opencli reddit search ... -f yaml` call printed only `Waiting for Chrome/Chromium extension to connect`, remained blocked for 15 seconds, and required Ctrl-C
**verified:** 2026-10-06 at 12:36 am Pacific, after Doctor reported Reddit OpenCLI installed with no connected browser extension, `opencli reddit search 'Coachella Valley seasonal jobs October 2026' -f yaml` ran for 30.2 seconds and returned zero bytes
**verified:** 2026-10-06 at 2:55 am Pacific, after Doctor reported Reddit `active_backend: null` because no OpenCLI Reddit extension was connected, two `opencli reddit search 'Palm Springs jobs hiring seasonal October 2026' -f yaml` attempts hung with zero output; the second was manually interrupted and exited 130
**where:** seven required-platform Reddit query calls from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

All seven read-only commands establish that this OpenCLI route was unavailable for the pass, while an empty or waiting probe supplied no search result.

**Why:** still held back at n=7 query calls in one environment because no untouched control was measured; the call count alone does not pass the causal bar.
**Fix:** the repeated recurrence requires a reusable launch guard that runs Doctor first and refuses `opencli reddit search` when `active_backend` is null or the extension is disconnected; this guard is UNCONFIRMED until built and exercised. Until then, interrupt an empty hanging probe and use the runtime web search for public Reddit discovery while keeping posts UNCONFIRMED.

### `gh api` form fields returned HTTP 404 on 4 commit-list requests without forced GET

**verified:** 2026-10-05, `gh api repos/jaimaann/LangHire/commits -f per_page=5` returned HTTP 404, while the public commits endpoint existed
**verified:** 2026-10-05, `gh api repos/career-ops-hq/career-ops/commits --paginate -F per_page=5` returned GitHub `404 Not Found`
**verified:** 2026-10-05, `gh api repos/liangdabiao/resume-matcher-agent-cn/commits --paginate -F per_page=5 --jq ...` returned HTTP 404 after repository view, README, and license requests for the same repository succeeded
**verified:** 2026-10-06, `gh api repos/OWNER/REPO/commits --paginate -F per_page=5` returned HTTP 404 when the intended request was a read-only GET
**where:** four official GitHub CLI commit-list requests for public repositories

All four requests supplied form fields without forcing GET, while the successful read-only calls on one repository established that the repository was reachable; no successful corrected commits request output was supplied.

**Why:** REJECT at n=4 from four repository request subjects; there are not five observations from five different subjects.
**Fix:** UNCONFIRMED; use `gh api -X GET repos/OWNER/REPO/commits -f per_page=5`, omit pagination for a small check, or encode the query in a quoted GET endpoint, then require a nonempty commits response.

### `gh api .../git/trees/<branch>?recursive=1` returned HTTP 404 on 10 hard-coded branch mismatches

**verified:** 2026-10-05, `gh repo view` reported `Gsync/jobsync` default branch `main`, then `gh api repos/Gsync/jobsync/git/trees/master?recursive=1` returned HTTP 404
**verified:** 2026-10-05 at about 10:16 pm Pacific, repository view reported `NullSpace-BitCradle/ats-resume-agent` default branch `master`, then `gh api repos/NullSpace-BitCradle/ats-resume-agent/git/trees/main?recursive=1` returned HTTP 404
**verified:** 2026-10-06, repository metadata reported `sp6370/Job-Application-Tracker` default branch `main`, a tree request for `master` returned HTTP 404, and retrying with the metadata-provided branch succeeded
**verified:** 2026-10-06, `gh repo view rpunia29/applic --json defaultBranchRef` returned `{"name":"master"}` immediately before the quoted `main?recursive=1` tree request returned HTTP 404 Not Found
**verified:** 2026-10-06, repository metadata reported `benidevo/vega-ai` default branch `master`, then its `main?recursive=1` tree request returned HTTP 404
**verified:** 2026-10-06, `gh repo view sliday/resume-job-matcher --json defaultBranchRef` returned `master` after a tree request hard-coded `main`; the quoted corrected `master?recursive=1` GET returned 49 tree paths in 997 bytes
**verified:** 2026-10-06, `gh api 'repos/davidisdeploying/prospect/git/trees/main?recursive=1'` returned HTTP 404 after `gh repo view ... --json defaultBranchRef` showed `master`; the corrected `master?recursive=1` GET returned 109,747 bytes containing 438 paths
**verified:** 2026-10-06 at about 4:19 am Pacific, `gh repo view Bunsly/JobSpy` resolved to `speedyapply/JobSpy` and reported default branch `main`, then a hard-coded `git/trees/master?recursive=1` request returned HTTP 404; no corrected tree output was supplied for this repository
**verified:** 2026-10-06, `gh repo view jananthan30/Resume-Builder --json defaultBranchRef` reported `master`, then `gh api 'repos/jananthan30/Resume-Builder/git/trees/main?recursive=1'` returned HTTP 404; no corrected tree output was supplied for this repository
**verified:** 2026-10-06, `gh repo view p95max/JobApply --json defaultBranchRef,licenseInfo` reported `defaultBranchRef.name` as `master`, then `gh api 'repos/p95max/JobApply/git/trees/main?recursive=1'` returned HTTP 404; no corrected `master` tree output was supplied
**where:** ten official GitHub API tree requests across ten repositories

Each failed request hard-coded a branch that differed from repository metadata, while three corrected retries used the metadata value and succeeded.

**Why:** still held back at n=10 from ten repository and branch-ref subjects because no untouched control was measured; the subject count alone does not pass the causal bar.
**Fix:** read `defaultBranchRef.name`, quote the query-bearing endpoint that uses that exact branch, and require a nonempty tree response; corrected retries for `sp6370/Job-Application-Tracker`, `sliday/resume-job-matcher`, and `davidisdeploying/prospect` verify this recovery.

### `gh-axi api --help` returned `command not found` while the agent rules required `gh-axi` at n=1

**verified:** 2026-10-05, `command -v gh-axi` returned no path and `gh-axi api --help` returned exactly `zsh:2: command not found: gh-axi`
**where:** one zsh GitHub CLI check from `/Users/zayah/github/dotfiles`

The shell exposed no `gh-axi` command; why the active rule and installed command set disagree is UNCONFIRMED.

**Why:** REJECT at n=1 from one shell and tool subject; there are not five observations from five different subjects.
**Fix:** UNCONFIRMED; reconcile the active GitHub CLI rule with the installed tool before running GitHub commands.

### `web__run` completed 4 searches covering 13 queries with zero text, image, or error content

**verified:** 2026-10-05, `web__run` accepted four job and Reddit `search_query` items with `response_length` set to `long`, completed successfully, and returned no text or image content
**verified:** 2026-10-05 at about 10:23 pm Pacific, the runtime web search accepted four queries covering Home Depot or TJX in Palm Desert, Allstate or TELUS Digital remote in Washington, Lowe's or WinCo in Snohomish County, and recent Reddit job or scam discussions, then returned zero bytes with no result or error
**verified:** 2026-10-06 at about 9:00 am Pacific, a valid built-in `web__run` call containing four job and Reddit queries completed with zero output bytes; a second valid call containing one Palm Desert query also completed with zero output bytes, while Firecrawl search returned nonempty results in the same research pass
**where:** four job and Reddit web-search calls covering thirteen queries

All four successful completions establish no search result because they exposed zero content blocks or errors; why the content was empty is UNCONFIRMED.

**Why:** REJECT at n=4 from four call subjects in one runtime; there are not five observations from five different subjects.
**Fix:** require nonempty text or image content before accepting a search; otherwise use the verified Firecrawl fallback, Agent Reach Jina Reader, direct official sites, or the configured GitHub search route, then verify the returned content.

### 4 Jina-wrapped Google searches returned 696 to 754 CAPTCHA bytes and 0 results

**verified:** 2026-10-06, Jina Reader requests to Google Search for Marriott Palm Desert jobs, Conduent remote Washington, REI Seattle jobs, and Reddit Coachella Valley jobs exited 0 but returned unusual-traffic CAPTCHA or homepage content without search results; an exact rerun returned 742, 739, 696, and 754 bytes respectively, and every response contained `Our systems have detected unusual traffic`
**where:** four `https://r.jina.ai/http://www.google.com/search?...` job and Reddit queries from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

All four responses were nonempty but contained no usable result links, so exit status and byte count alone did not verify a search.

**Why:** REJECT at n=4 queries from one Google-through-Jina route; there are not five observations from five different subjects or an untouched control.
**Fix:** use runtime web search only when it returns nonempty result content, or use official career-board endpoints and direct employer pages. Require expected result text or links, stop without bypassing a CAPTCHA, and never accept exit 0 alone.

### Jina routes returned 8 unusable responses across 10 Brave, Yahoo, and Bing queries

**verified:** 2026-10-06, three of four parallel Jina-wrapped Brave queries returned HTTP 429 or CAPTCHA pages, two of three Jina-wrapped Yahoo queries returned temporary-problem pages, and three Bing queries for Palm, REI, and Reddit returned unrelated results
**where:** ten Brave, Yahoo, and Bing search-engine queries through Jina Reader in one job-search run

Eight named responses did not provide usable query results; the evidence does not establish the quality of the remaining two responses or a general rule for later runs.

**Why:** REJECT at n=10 query calls across three engine-route subjects in one run; there are not five subjects plus an untouched control.
**Fix:** treat search-engine text as an unverified lead, require expected query terms and relevant result links, then verify on official employer pages or platform-native APIs. Fall back to the runtime web search only when it returns nonempty relevant content.

### Jina Reader returned PCC security-verification pages at n=2

**verified:** 2026-10-05 at 7:09 pm Pacific, Jina Reader on `https://www.pccmarkets.com/page/about/jobs` returned HTTP 403 and a Cloudflare page containing exactly `Performing security verification`; the workflow stopped and did not bypass the challenge
**verified:** 2026-10-10, one run returned 258 bytes with no listings; an exact fresh read returned HTTP 200 and 483 bytes headed `Just a moment...`, warning that the page may require CAPTCHA, and containing `Performing security verification`
**where:** two reads of the PCC Community Markets careers page through Jina Reader

Both responses establish an anti-bot interstitial for this page and route, but not a site-wide rule for every PCC URL or client.

**Why:** REJECT at n=2 from one page and backend subject; there are not five observations from five different subjects.
**Fix:** use search-indexed official content or the employer's linked ATS through normal visible navigation; never retry or bypass the challenge.

### Jina Reader returned Alaska status 42206 and a 3,707-byte Target 404 across 2 job-search routes

**verified:** 2026-10-10, Jina Reader for `https://jobs.alaskaair.com/search-jobs/Seattle%2C%20WA/12347/4/6252001-5815135-5809844-5809844/47x60621/-122x33207/50/2` returned HTTP 422, 1,121 bytes, JSON status `42206`, and exactly `page.goto: net::ERR_CONNECTION_REFUSED`; in the same research pass, City of Bothell and Snohomish County GovernmentJobs pages returned 105,956 and 128,667 bytes
**verified:** 2026-10-10, one Target Bothell Radancy-style search URL returned a readable 3,707-byte 404 page headed exactly `Clean up on aisle 404!`
**where:** one Alaska Airlines Seattle search route and one Target Bothell search route read through Agent Reach Jina Reader

The two exact search routes were unusable for source discovery; neither response proves that the employers had no current jobs, and the source-specific cause is UNCONFIRMED.

**Why:** REJECT at n=2 across two employer-route subjects; there are not five observations from five different subjects, although the two GovernmentJobs controls prove Jina returned substantial content in the same pass.
**Fix:** treat these as failed source-discovery routes, not application blockers or empty job boards. Use another official employer search route, the linked ATS, or normal visible browser navigation, and require nonempty listing content before reporting availability.

### Jina Reader returned GovernmentJobs HTTP 403 `AbuseAlleviationError`; direct HTML yielded 207 listings

**verified:** 2026-10-16, Jina Reader for a Seattle GovernmentJobs search returned HTTP 403 with `AbuseAlleviationError` and said the domain was blocked until `Fri Oct 16 2026 23:25:02 GMT`; a direct request with a Mozilla-compatible user agent returned 445,370 bytes for page 1, and pages 1 through 21 produced 207 distinct new listing IDs
**where:** one `governmentjobs.com` Seattle search route through Jina Reader and direct public HTML

The paired results establish a blocked Jina route and a readable direct route for this search; the reason GovernmentJobs blocked the Jina egress beyond the reported abuse-alleviation condition is UNCONFIRMED.

**Why:** REJECT at n=1 from one site and reader subject; there are not five observations from five different subjects.
**Fix:** fetch the public search HTML directly with a normal user agent, require substantial nonempty bytes, and deduplicate stable listing IDs across pages. The verified fallback checked 21 pages and found 207 distinct new IDs.

### Sprouts store-operations reader returned HTTP 403 Forbidden at n=1

**verified:** 2026-10-05, the official `https://www.sprouts.com/careers/` page exposed its Store & Field Team target as `https://jobs.sprouts.com/store-operations/jobs`, and opening that target through the web reader returned `Failed to fetch ... (403) Forbidden`
**where:** one web-reader request for the official Sprouts store-operations job index

The response proves that this reader route did not expose the official listings, while public search content did not verify any individual role.

**Why:** REJECT at n=1 from one page and reader subject; there are not five observations from five different subjects.
**Fix:** keep every specific role UNCONFIRMED unless another official surface or normal visible browser verifies it; do not treat third-party snippets as official-listing confirmation.

### Web open returned `Internal Error` on 2 Kroger job pages; Jina returned 11,801 and 5,476 bytes

**verified:** 2026-10-06, opening official Kroger Family Careers job URLs for IDs 225488 and 203050 through the general web opener returned `Internal Error` and exactly `is not accessible via this tool` for both; Jina Reader returned 11,801 bytes naming 225488 as `JEWELRY/SALES SPECIALIST- Seasonal` with `Apply Now`, and 5,476 bytes stating exactly `This job is no longer available.` for 203050
**where:** two official `https://www.krogerfamilycareers.com/en/sites/CX_2001/job/<id>` detail pages read through the web opener and Agent Reach Jina Reader

The paired reads prove that Jina exposed current status content for these two URLs when the general opener did not; broader behavior across Kroger or Oracle-hosted pages is UNCONFIRMED.

**Why:** REJECT at n=2 from one employer, ATS, and route subject; there are not five observations from five different subjects.
**Fix:** use `curl -sL 'https://r.jina.ai/https://www.krogerfamilycareers.com/en/sites/CX_2001/job/<id>'`, require nonempty output, and verify explicit active or closed status text before reporting the role.

### Pilot careers IAB navigation failed with `net::ERR_CERT_COMMON_NAME_INVALID` at n=1

**verified:** 2026-10-06 at about 3:20 am Pacific, focused direct navigation of browser tab 311 to `https://jobs.pilotcompany.com/search-results?keywords=&location=Arlington%2C%20WA` stopped before page content with exactly `net::ERR_CERT_COMMON_NAME_INVALID`
**where:** one Codex in-app browser navigation to the official Pilot Company careers search URL

The browser reported a certificate common-name mismatch for this route; the certificate chain and behavior on other Pilot Company domains were not independently inspected.

**Why:** REJECT at n=1 from one URL and browser subject; there are not five observations from five different subjects.
**Fix:** do not bypass the browser safety interstitial. Use another official Pilot Company domain or an official search result that resolves with a valid certificate, and keep Reddit references UNCONFIRMED until an official page verifies them.

### GitHub README decode returned `is not valid base64 data` at n=1

**verified:** 2026-10-05 at about 9:14 pm Pacific, `gh api repos/espin086/GPT-Jobhunter/readme --jq '{...,content}' | jq -r '...(.content | @base64d)'` failed with exactly `string (...) is not valid base64 data` even though the API object exposed a `content` value
**where:** one official GitHub CLI README-content inspection

The transformed value was not accepted as base64, but the evidence does not establish which transformation changed it.

**Why:** REJECT at n=1 from one repository-content subject; there are not five observations from five different subjects.
**Fix:** UNCONFIRMED; request raw README bytes with `gh api -H 'Accept: application/vnd.github.raw+json' repos/OWNER/REPO/readme`, then require nonzero bytes and expected content instead of locally decoding the transformed field.

### `gh api` returned HTTP 404 for 10 assumed repository file locations or availability states; inspection exposed 9 layouts

**verified:** 2026-10-05 at about 9:14 pm Pacific, fetching `contents/LICENSE` through the official GitHub CLI returned HTTP 404, while repository-tree inspection showed the actual file path was `LICENSE.md`
**verified:** 2026-10-05, `gh api repos/TusharVashishth/localcv/contents/src/lib/db.ts -H 'Accept: application/vnd.github.raw+json'` and a second request for guessed path `src/lib/db/local-db.ts` each returned exactly `gh: Not Found (HTTP 404)` with nonempty JSON errors; `gh api 'repos/TusharVashishth/localcv/git/trees/HEAD?recursive=1' --jq '.tree[].path' | rg '(^|/)(db|database|dexie|storage)'` returned `src/lib/db/schema.ts`, and fetching that exact contents path succeeded and printed the IndexedDB schema
**verified:** 2026-10-05, a GitHub contents request for guessed path `src/main/java/com/resume/ats/check/utils/ResumeMatcher.java` returned HTTP 404, while the recursive repository tree exposed `KeywordMatcher.java` and `SkillMatcherUtil.java` instead
**verified:** 2026-10-06, `gh api repos/seehiong/ats-buddy/contents/src/services/parser.ts` returned exactly `gh: Not Found (HTTP 404)` and its piped decoder returned `base64: stdin: (null): error decoding base64 input stream`; the recursive tree listed `src/services/parse.ts`, whose raw contents request returned 6,731 bytes with `stripReasoning`, `extractJsonObject`, and `parseAnalysis` exports
**verified:** 2026-10-06, `gh api repos/zoepan0109-coder/job-application-tracker-extension/contents/package.json -H 'Accept: application/vnd.github.raw+json'` returned exactly `gh: Not Found (HTTP 404)`; the repository root listing showed a plain browser extension with existing `manifest.json` and `records.js` paths instead
**verified:** 2026-10-06, `gh api repos/adamrangwala/Job-Application-Tracker/contents/ChromeExtension/manifest.json -H 'Accept: application/vnd.github.raw+json'` returned exactly `gh: Not Found (HTTP 404)`; the repository root listing showed Apps Script `.gs` files and no `ChromeExtension` directory
**verified:** 2026-10-06, `gh api repos/reactive-resume/reactive-resume/contents/libs/schema/src/resume/index.ts` returned exactly `gh: Not Found (HTTP 404)`; the recursive tree showed the schema under `packages/schema/src/resume/` and the application CSV logic at `apps/web/src/features/applications/csv.ts`, and requests for those tree-derived paths succeeded
**verified:** 2026-10-06, `gh api repos/kngevrything/job-helper/license --jq '.license.name'` returned exactly `gh: Not Found (HTTP 404)` while the repository README said MIT and its recursive tree listed `job-tracker/LICENSE` and `chrome-extension/LICENSE` instead of a root license file
**verified:** 2026-10-06, `gh repo view p95max/JobApply --json defaultBranchRef,licenseInfo` returned `licenseInfo:null`, then `gh api repos/p95max/JobApply/license` returned HTTP 404; the metadata established that no repository license was available through that endpoint before the request ran
**where:** ten failed official GitHub CLI repository-file lookups across nine repository subjects, plus three successful tree-first content recoveries

All ten failed requests assumed a file location or availability state that differed from the repository tree, root listing, or metadata.

**Why:** still held back at n=10 location or availability failures across nine repository subjects because no untouched control was measured; the subject count alone does not pass the causal bar.
**Fix:** query repository metadata and the recursive tree first, then filter returned paths for the target concept and pass the exact path to `gh api repos/OWNER/REPO/contents/<path>` with a nonempty-content requirement. Stop when `gh api` returns nonzero, request raw media for file contents, and never pipe an API error payload into `base64`; skip the repository license endpoint when `licenseInfo` is null, and request an exact nested license path only when the tree exposes one.

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
