"""Append-only rows: streams, per-platform results, VOD changes, admin verdicts.

One JSON object per line in `stream/data/rows.jsonl`. Nothing is ever edited or
deleted; a correction is a new row that points at the old one. Every row has an `id`,
a `kind`, and an `at` timestamp, then whatever fields the kind carries. A number that
appears anywhere in a report must be traceable to one of these ids (decision 13).

    from stream import dataset
    ds = dataset.open()
    row = ds.append("stream", video_id="Q5dJuLvhxTI", title="...", platform="youtube")
    row.id                          # "row-000001"
    ds.rows(kind="stream")          # in append order
    ds.latest(kind="stream", video_id="Q5dJuLvhxTI")
    ds.get("row-000001")

Kinds in use (add here as you add one, so the list stays findable):
    stream            one broadcast: video_id, platform, title, started_at, stopped_at
    result            one measurement of one stream: video_id, platform, field, value
    vod_change        the agent changed a VOD field: video_id, field, old, new
    commitment        the one variable to try next stream (experiment)
    verdict           library-admin's WRITE / UPDATE / REJECT and its reason
    backfill          one backfill run: date, filled, overwritten
    health            one health sample during a stream
    board_push        one push to the overlay board on an issue state change
"""
from __future__ import annotations

import json
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, Iterator, List, Optional

from . import paths


def now_iso() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat()


@dataclass
class Row:
    id: str
    kind: str
    at: str
    fields: Dict[str, Any] = field(default_factory=dict)

    def __getitem__(self, key: str) -> Any:
        return self.fields[key]

    def get(self, key: str, default: Any = None) -> Any:
        return self.fields.get(key, default)

    def to_dict(self) -> Dict[str, Any]:
        out = {"id": self.id, "kind": self.kind, "at": self.at}
        out.update(self.fields)
        return out

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "Row":
        data = dict(data)
        return cls(id=data.pop("id"), kind=data.pop("kind"), at=data.pop("at"), fields=data)


class Dataset:
    def __init__(self, path: Path):
        self.path = path

    def _read_all(self) -> List[Row]:
        if not self.path.exists():
            return []
        rows = []
        with self.path.open(encoding="utf-8") as fh:
            for line in fh:
                line = line.strip()
                if line:
                    rows.append(Row.from_dict(json.loads(line)))
        return rows

    def __len__(self) -> int:
        return len(self._read_all())

    def __iter__(self) -> Iterator[Row]:
        return iter(self._read_all())

    def append(self, kind: str, at: Optional[str] = None, **fields: Any) -> Row:
        for reserved in ("id", "kind"):
            if reserved in fields:
                raise ValueError(f"{reserved!r} is set by the dataset, not the caller")
        self.path.parent.mkdir(parents=True, exist_ok=True)
        row = Row(id=f"row-{len(self) + 1:06d}", kind=kind, at=at or now_iso(), fields=fields)
        with self.path.open("a", encoding="utf-8") as fh:
            fh.write(json.dumps(row.to_dict(), ensure_ascii=False, sort_keys=True) + "\n")
        return row

    def rows(self, kind: Optional[str] = None, **match: Any) -> List[Row]:
        out = []
        for row in self._read_all():
            if kind is not None and row.kind != kind:
                continue
            if all(row.get(k) == v for k, v in match.items()):
                out.append(row)
        return out

    def latest(self, kind: Optional[str] = None, **match: Any) -> Optional[Row]:
        found = self.rows(kind, **match)
        return found[-1] if found else None

    def get(self, row_id: str) -> Optional[Row]:
        for row in self._read_all():
            if row.id == row_id:
                return row
        return None


def open(path: Optional[Path] = None) -> Dataset:  # noqa: A001 - mirrors the stdlib idiom
    return Dataset(path or paths.dataset_path())
