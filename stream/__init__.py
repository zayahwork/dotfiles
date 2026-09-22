"""The stream agent.

The deterministic core behind "let's go live". One package, stdlib only, Python 3.9+,
runs the same on macOS, Windows and WSL. Nothing in here assumes a shell, a path
layout or an OS.

Layers, as confirmed in method/issues/prd-stream-agent.md:

    Storage   secrets, config, dataset
    Adapter   obs, relay, youtube, x, twitch, kick
    Service   metadata, golive, health, experiment, report, chat
    Wiring    command, backfill
    Surface   brief, board, page

Every adapter that talks to a real service ships two implementations behind one
interface: the real client, and a fake that needs no key. Code picks the real one
only when its secrets are present, so every path is testable cold and becomes live
the moment a key is filled in.
"""

__all__ = ["paths", "secrets", "config", "dataset"]
