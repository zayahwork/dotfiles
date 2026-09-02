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

