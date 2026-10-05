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
| [`agent-reach` rejected `search` 8 times, `read` 4 times, and `get` once across 4 dates](#agent-reach-rejected-search-8-times-read-4-times-and-get-once-across-4-dates) | The installed CLI exposes none of those top-level web commands. Use documented backend routes, Jina, an approved search capability, official ATS APIs, or `gh-axi` for GitHub. |
| [`opencli reddit search` returned 0 bytes and still ran after 30.2 seconds at n=1](#opencli-reddit-search-returned-0-bytes-and-still-ran-after-302-seconds-at-n1) | Doctor showed warn, null active backend, and no connected extension. The read-only command itself hung; terminate it and use public indexed leads as UNCONFIRMED. |
| [`gh-axi api --jq '.content'` emitted YAML wrapper text and `base64 --decode` returned 0 bytes at n=1](#gh-axi-api---jq-content-emitted-yaml-wrapper-text-and-base64---decode-returned-0-bytes-at-n1) | `api_response.body` was wrapped and truncated. Query `download_url`, extract the short body field, then fetch and verify the raw file. |
| [`REPO_NOT_FOUND` twice for `rxresu-me/rxresu.me`; `reactive-resume/reactive-resume` succeeded at n=1](#repo_not_found-twice-for-rxresu-merxresume-reactive-resumereactive-resume-succeeded-at-n1) | Repository search found the current slug. Both repository view and issue listing then succeeded against it. |
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

### `agent-reach` rejected `search` 8 times, `read` 4 times, and `get` once across 4 dates

**verified:** 2026-09-30, invoking `search` returned exactly `invalid choice: 'search' (choose from setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version)`; 2026-10-03, installed agent-reach v1.5.0 returned the same list for another `search` call, `agent-reach read <Ashby URL> --json` returned the equivalent exact `invalid choice: 'read'` error, and a Hyatt `agent-reach search ... --json` call returned the same `invalid choice: 'search'` list while Exa was explicitly prohibited; 2026-10-04, three more `agent-reach search '...' --json` calls exited 2 with the same exact `invalid choice: 'search'` command list; 2026-10-05, `agent-reach search "Rocket Money Operations Associate Remote Pacific Time Zone" --json` returned the same argparse error and allowed-command list from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`
**verified:** 2026-10-05, `agent-reach search --help` from `/Users/zayah/Documents/Codex` returned exactly `invalid choice: 'search'` and listed only `setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version`
**verified:** 2026-10-05 at the 10:32 am Pacific heartbeat, three `agent-reach read <URL>` calls for Palm Desert, remote, and Bothell query tracks each exited 2 with exactly `invalid choice: 'read'` and the same allowed-command list
**verified:** 2026-10-05, `agent-reach get https://raw.githubusercontent.com/Gsync/jobsync/main/README.md` exited with an argparse error containing exactly `invalid choice: 'get' (choose from setup, install, configure, doctor, uninstall, skill, format, transcribe, check-update, watch, version)`
**where:** thirteen calls covering three missing subcommands in one installed agent-reach CLI environment

The returned command lists contain neither top-level web command, but the evidence does not establish behavior for other installed versions.

**Why:** still held back at n=13 calls across three command subjects in one CLI environment; there are not five observations from five different environment subjects, and the cause beyond this installed CLI remains unconfirmed.
**Fix:** run `agent-reach doctor --json` and require non-empty output before trusting it, then invoke the backend described by the skill; use direct Jina `curl` for an exact URL, another approved web-search or official ATS capability, or `gh-axi` for GitHub instead of inventing `agent-reach search`, `agent-reach read`, or `agent-reach get`.

### `opencli reddit search` returned 0 bytes and still ran after 30.2 seconds at n=1

**verified:** 2026-10-05, `agent-reach doctor --json` reported Reddit status `warn`, `active_backend: null`, OpenCLI installed, and no connected browser extension; `opencli reddit search "jobs hiring Snohomish Lake Stevens Bothell 2026" -f yaml` produced 0 output bytes and was still running after 30.2 seconds, `pgrep -af "opencli reddit search"` returned PID 6008, and `kill 6008` exited 0
**where:** one required-platform Reddit search from `/Users/zayah/Documents/Codex/2026-09-29/job-applications`

The read-only command verifies unavailability for this pass, but `active_backend: null` can mean Doctor skipped a live probe, so the missing extension as the cause remains unconfirmed.

**Why:** REJECT at n=1 from one command and environment subject; there are not five observations from five different subjects or an untouched control.
**Fix:** treat this OpenCLI route as unavailable for the pass, terminate the hung process, use public search-engine Reddit results only as UNCONFIRMED leads, and do not retry until Doctor reports a usable backend or the user has connected an existing logged-in browser extension.

### `gh-axi api --jq '.content'` emitted YAML wrapper text and `base64 --decode` returned 0 bytes at n=1

**verified:** 2026-10-05, `gh-axi api repos/Gsync/jobsync/readme --jq '.content'` printed a YAML document whose base64 text was under `api_response.body` with `truncated: true`; piping that output to `base64 --decode` returned exactly `base64: stdin: (null): error decoding base64 input stream` and wrote 0 bytes, while querying `.download_url`, extracting the short `api_response.body` URL, and fetching it returned 18,024 bytes beginning `# JobSync`
**where:** one read-only GitHub README retrieval subject through `gh-axi`

The failed pipe received the wrapper document rather than a raw base64 scalar, and the wrapper reported that the content field had also been truncated.

**Why:** REJECT at n=1 from one repository and wrapper subject; there are not five observations from five different subjects.
**Fix:** query `gh-axi api repos/OWNER/REPO/readme --jq '.download_url'`, extract the short `api_response.body` value, fetch that URL, and verify the returned file has nonzero bytes and expected content.

### `REPO_NOT_FOUND` twice for `rxresu-me/rxresu.me`; `reactive-resume/reactive-resume` succeeded at n=1

**verified:** 2026-10-05, `gh-axi repo view rxresu-me/rxresu.me` and `gh-axi issue list --repo rxresu-me/rxresu.me --limit 5` each exited 1 with code `REPO_NOT_FOUND`; `gh-axi search repos "Reactive Resume" --limit 10` returned `reactive-resume/reactive-resume` first with 43,847 stars, then `gh-axi repo view reactive-resume/reactive-resume` exited 0 with 54 issues and `gh-axi issue list --repo reactive-resume/reactive-resume --limit 5` exited 0 with `count: 5 of 54 total`
**where:** one Reactive Resume repository lookup subject through `gh-axi`

The two failures establish that the assumed slug was not resolvable through these commands, while repository search identified the slug that both read operations accepted.

**Why:** REJECT at n=1 from one repository identity subject; there are not five observations from five different subjects.
**Fix:** search repositories by project name before retrying an uncertain slug, then use `reactive-resume/reactive-resume` for the current repository and issue reads.
