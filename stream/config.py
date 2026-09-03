"""What first-run discovery found. Written by discovery, read by everything else.

Never a guessed name: every scene and source in here was listed by obs-websocket on
this machine. `stream/config.json` is gitignored because it describes one OBS install.

    from stream import config
    cfg = config.load()            # raises NoConfig if discovery has not run
    cfg.scenes                     # ["Starting Soon", "Main", ...] as OBS reports them
    cfg.text_sources               # names of text inputs the agent may set
    cfg.countdown_scene, cfg.main_scene   # chosen from cfg.scenes, never invented
"""
from __future__ import annotations

import json
from dataclasses import asdict, dataclass, field
from pathlib import Path
from typing import Any, Dict, List, Optional

from . import paths


class NoConfig(Exception):
    """Discovery has not written a config yet. Run `python -m stream.discovery`."""


@dataclass
class Endpoint:
    """One RTMP destination. Keys are never stored here, only which secret names them."""

    platform: str            # youtube, x_main, x_alt, twitch, kick
    ingest_secret: str       # e.g. YOUTUBE_INGEST_URL
    key_secret: str          # e.g. YOUTUBE_STREAM_KEY
    enabled: bool = True


@dataclass
class Config:
    obs_version: str = ""
    websocket_version: str = ""
    scenes: List[str] = field(default_factory=list)
    inputs: List[Dict[str, str]] = field(default_factory=list)   # {"name":..., "kind":...}
    text_sources: List[str] = field(default_factory=list)
    countdown_scene: Optional[str] = None
    main_scene: Optional[str] = None
    countdown_seconds: int = 600
    bitrate_kbps: Optional[int] = None       # the lowest ceiling among enabled platforms
    endpoints: List[Endpoint] = field(default_factory=list)
    discovered_at: str = ""

    def to_json(self) -> str:
        return json.dumps(asdict(self), indent=2, ensure_ascii=False) + "\n"

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "Config":
        endpoints = [Endpoint(**e) for e in data.get("endpoints", [])]
        known = {k: v for k, v in data.items() if k in cls.__dataclass_fields__ and k != "endpoints"}
        return cls(endpoints=endpoints, **known)

    def save(self, path: Optional[Path] = None) -> Path:
        target = path or paths.config_path()
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(self.to_json(), encoding="utf-8")
        return target


def load(path: Optional[Path] = None) -> Config:
    target = path or paths.config_path()
    if not target.exists():
        raise NoConfig(f"no config at {target}; run python -m stream.discovery")
    return Config.from_dict(json.loads(target.read_text(encoding="utf-8")))


def load_or_empty(path: Optional[Path] = None) -> Config:
    try:
        return load(path)
    except NoConfig:
        return Config()
