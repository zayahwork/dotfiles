"""Every test runs against a temp secrets file, a temp config and a temp dataset.

No test can read the real stream/secrets.env or write the real dataset, and no
credential from the shell reaches a test, so nothing under stream/tests can go live.
"""
from __future__ import annotations

import os
from pathlib import Path

import pytest

from stream import dataset, paths, secrets

FIXTURES = paths.FIXTURES
PREFIXES = ("YOUTUBE_", "X_INGEST", "X_STREAM", "TWITCH_", "KICK_", "OBS_", "STREAM_")


@pytest.fixture(autouse=True)
def isolated_paths(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> Path:
    for name in list(os.environ):
        if name.startswith(PREFIXES):
            monkeypatch.delenv(name, raising=False)
    monkeypatch.setenv("STREAM_SECRETS", str(tmp_path / "secrets.env"))
    monkeypatch.setenv("STREAM_CONFIG", str(tmp_path / "config.json"))
    monkeypatch.setenv("STREAM_DATA", str(tmp_path / "data"))
    monkeypatch.setenv("STREAM_LIBRARY", str(tmp_path / "library"))
    (tmp_path / "library").mkdir()
    return tmp_path


@pytest.fixture
def write_secrets(tmp_path: Path):
    """write_secrets(OBS_WEBSOCKET_PASSWORD="x", ...) -> Path. Blank values stay blank."""

    def _write(**values: str) -> Path:
        lines = [f"{k}={v}" for k, v in values.items()]
        path = tmp_path / "secrets.env"
        path.write_text("\n".join(lines) + "\n", encoding="utf-8")
        return path

    return _write


@pytest.fixture
def full_fake_secrets(write_secrets) -> Path:
    """Every known key filled with an obviously fake value. Adapters still must not
    reach the network in tests; this only proves the `has_adapter` branches."""
    return write_secrets(**{name: f"fake-{name.lower()}" for name in secrets.known_names()})


@pytest.fixture
def ds() -> dataset.Dataset:
    return dataset.open()


@pytest.fixture
def reference_description() -> str:
    return (FIXTURES / "Q5dJuLvhxTI.txt").read_text(encoding="utf-8")


@pytest.fixture
def broken_description() -> str:
    return (FIXTURES / "mdZd7NL2fq8.txt").read_text(encoding="utf-8")
