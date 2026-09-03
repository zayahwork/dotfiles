"""Reads stream keys and tokens by name; refuses to start and names what is missing.

The names are fixed in stream/secrets.example.env and nowhere else. Values come from
the environment first, then from the secrets file, so CI and a shell export both work
and a blank line in the file is the same as no line at all.

    from stream import secrets
    s = secrets.load()
    s.require("OBS_WEBSOCKET_URL", "OBS_WEBSOCKET_PASSWORD")   # raises MissingSecret
    s.has("YOUTUBE_STREAM_KEY")                                 # -> bool, pick real or fake

Values are never printed. `MissingSecret` names keys only, and `refuse()` prints
`missing: KEY` to stderr and exits 1, which is the contract every CLI in the package
relies on.
"""
from __future__ import annotations

import os
import sys
from pathlib import Path
from typing import Dict, Iterable, List, Mapping, Optional

from . import paths

# Which keys each adapter needs before it may go real. Anything not listed here is
# a bug in the caller, not a missing credential.
NEEDED: Dict[str, List[str]] = {
    "obs": ["OBS_WEBSOCKET_URL", "OBS_WEBSOCKET_PASSWORD"],
    "youtube": ["YOUTUBE_INGEST_URL", "YOUTUBE_STREAM_KEY"],
    "youtube_analytics": [
        "YOUTUBE_OAUTH_CLIENT_ID",
        "YOUTUBE_OAUTH_CLIENT_SECRET",
        "YOUTUBE_OAUTH_REFRESH_TOKEN",
    ],
    "x_main": ["X_INGEST_URL_MAIN", "X_STREAM_KEY_MAIN"],
    "x_alt": ["X_INGEST_URL_ALT", "X_STREAM_KEY_ALT"],
    "twitch": ["TWITCH_INGEST_URL", "TWITCH_STREAM_KEY"],
    "kick": ["KICK_INGEST_URL", "KICK_STREAM_KEY"],
}


class MissingSecret(Exception):
    """Raised with the exact key names that are blank or absent. Never a value."""

    def __init__(self, names: Iterable[str]):
        self.names = list(names)
        super().__init__("missing: " + ", ".join(self.names))


def parse_env_file(text: str) -> Dict[str, str]:
    """KEY=value lines. Comments and blanks skipped, a blank value is dropped."""
    out: Dict[str, str] = {}
    for raw in text.splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key, value = key.strip(), value.strip()
        if len(value) >= 2 and value[0] == value[-1] and value[0] in "\"'":
            value = value[1:-1]
        if key and value:
            out[key] = value
    return out


def known_names() -> List[str]:
    """Every key the example file declares, in file order. The example is the schema."""
    names: List[str] = []
    for raw in paths.secrets_example_path().read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if line and not line.startswith("#") and "=" in line:
            names.append(line.split("=", 1)[0].strip())
    return names


class Secrets:
    def __init__(self, values: Mapping[str, str], source: Optional[Path] = None):
        self._values = {k: v for k, v in values.items() if v}
        self.source = source

    def get(self, name: str) -> Optional[str]:
        return self._values.get(name)

    def has(self, *names: str) -> bool:
        return all(name in self._values for name in names)

    def missing(self, *names: str) -> List[str]:
        return [n for n in names if n not in self._values]

    def require(self, *names: str) -> Dict[str, str]:
        gone = self.missing(*names)
        if gone:
            raise MissingSecret(gone)
        return {n: self._values[n] for n in names}

    def has_adapter(self, adapter: str) -> bool:
        return self.has(*NEEDED[adapter])

    def require_adapter(self, adapter: str) -> Dict[str, str]:
        return self.require(*NEEDED[adapter])

    def filled(self) -> List[str]:
        """Names with a value, for a status line. Never the values."""
        return sorted(self._values)

    def __repr__(self) -> str:  # never leak a value into a log
        return f"Secrets({len(self._values)} set, source={self.source})"


def load(path: Optional[Path] = None, environ: Optional[Mapping[str, str]] = None) -> Secrets:
    """Environment wins over the file. A missing file is not an error; a missing key is."""
    env = os.environ if environ is None else environ
    file_path = path or paths.secrets_path()
    values: Dict[str, str] = {}
    if file_path.exists():
        values.update(parse_env_file(file_path.read_text(encoding="utf-8")))
    for name in known_names():
        if env.get(name, "").strip():
            values[name] = env[name].strip()
    return Secrets(values, file_path)


def refuse(exc: MissingSecret, stream=None) -> "int":
    """Print `missing: KEY` and return the exit code 1. Callers `sys.exit(refuse(e))`."""
    out = stream or sys.stderr
    for name in exc.names:
        print(f"missing: {name}", file=out)
    return 1


def main(argv: Optional[List[str]] = None) -> int:
    """`python -m stream.secrets [ADAPTER...]` reports which names are set, values never."""
    args = list(sys.argv[1:] if argv is None else argv)
    if args and args[0] in ("-h", "--help"):
        print("usage: python -m stream.secrets [adapter ...]\n"
              "  no args   list every known key as set/missing\n"
              "  adapter   exit 1 naming what that adapter still needs "
              f"({', '.join(sorted(NEEDED))})")
        return 0
    s = load()
    if not args:
        for name in known_names():
            print(("set      " if s.has(name) else "missing  ") + name)
        print(f"{len(s.filled())}/{len(known_names())} set, source {s.source}")
        return 0
    try:
        for adapter in args:
            if adapter not in NEEDED:
                print(f"unknown adapter: {adapter} (want one of {', '.join(sorted(NEEDED))})",
                      file=sys.stderr)
                return 2
            s.require_adapter(adapter)
    except MissingSecret as exc:
        return refuse(exc)
    print(f"ok: {', '.join(args)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
