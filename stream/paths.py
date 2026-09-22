"""Where the agent's files live, on any OS.

Every path is resolved at call time from an environment variable with a default
under the package directory, so tests point them at a temp dir and nothing else
changes. Never hardcode a path anywhere else in the package; ask this module.

    STREAM_SECRETS   the real credentials file      default stream/secrets.env
    STREAM_CONFIG    what discovery found            default stream/config.json
    STREAM_DATA      append-only rows and outputs    default stream/data/
"""
from __future__ import annotations

import os
from pathlib import Path

PACKAGE = Path(__file__).resolve().parent
REPO = PACKAGE.parent
FIXTURES = PACKAGE / "fixtures"


def _env_path(name: str, default: Path) -> Path:
    value = os.environ.get(name, "").strip()
    return Path(value).expanduser() if value else default


def secrets_path() -> Path:
    return _env_path("STREAM_SECRETS", PACKAGE / "secrets.env")


def secrets_example_path() -> Path:
    return PACKAGE / "secrets.example.env"


def config_path() -> Path:
    return _env_path("STREAM_CONFIG", PACKAGE / "config.json")


def data_dir() -> Path:
    path = _env_path("STREAM_DATA", PACKAGE / "data")
    path.mkdir(parents=True, exist_ok=True)
    return path


def dataset_path() -> Path:
    return data_dir() / "rows.jsonl"


def library_dir() -> Path:
    return _env_path("STREAM_LIBRARY", REPO / "library")
