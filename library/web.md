# Web

Fetching things off the public internet from this machine. What the tools actually
return, and where they quietly return nothing.

## Contents

| Subject | What it says |
| --- | --- |
| [A YouTube channel's videos enumerate fine from `/streams`, but grep for `videoId` because `videoRenderer` is gone](#a-youtube-channels-videos-enumerate-fine-from-streams-but-grep-for-videoid-because-videorenderer-is-gone) | 9 of 9 streams found on `@ZayBuilds-b6o`. The page now uses `lockupViewModel`, so a `videoRenderer` grep reports zero on a page that is full. |
| [A watch page returns title, views, length, publish date and the full description](#a-watch-page-returns-title-views-length-publish-date-and-the-full-description) | `ytInitialPlayerResponse.videoDetails` plus `microformat`. 3,290 characters came back whole. |
| [`WebFetch` on a youtube.com URL returns only the site footer](#webfetch-on-a-youtubecom-url-returns-only-the-site-footer) | The markdown conversion drops the JSON the page is built from. Use `curl`. |
| [Twitch help articles are a JavaScript app and `curl` returns 343,121 bytes with no article text](#twitch-help-articles-are-a-javascript-app-and-curl-returns-343121-bytes-with-no-article-text) | `help.twitch.tv` renders from JS. The policy text is not in the HTML at any depth. |
| [Reddit returns 403 and an HTML block page to every unauthenticated request, whatever the user agent](#reddit-returns-403-and-an-html-block-page-to-every-unauthenticated-request-whatever-the-user-agent) | `www.reddit.com/...json` is 403 for both a bot UA and a Chrome UA. OAuth is mandatory even to read. `old.reddit.com` 302s instead. |
| [The agent sandbox allowlists network egress by host for Node: `registry.npmjs.org` is 200, `reddit.com` and `example.com` are `ETIMEDOUT`](#the-agent-sandbox-allowlists-network-egress-by-host-for-node-registrynpmjsorg-is-200-redditcom-and-examplecom-are-etimedout) | `npm install` works, which hides it. Not IPv6, not `fetch`: `node:https` fails the same way. `curl` is not subject to the allowlist. |

---

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
