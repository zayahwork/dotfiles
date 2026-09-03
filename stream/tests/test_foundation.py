"""The storage layer every issue builds on: secrets, config, dataset."""
from __future__ import annotations

import io

import pytest

from stream import config, dataset, secrets


def test_missing_secret_names_the_key_and_never_a_value(write_secrets):
    write_secrets(OBS_WEBSOCKET_URL="ws://127.0.0.1:4455", OBS_WEBSOCKET_PASSWORD="")
    s = secrets.load()
    with pytest.raises(secrets.MissingSecret) as err:
        s.require_adapter("obs")
    assert err.value.names == ["OBS_WEBSOCKET_PASSWORD"]
    assert str(err.value) == "missing: OBS_WEBSOCKET_PASSWORD"
    assert "4455" not in repr(s)


def test_refuse_prints_missing_line_and_returns_one():
    out = io.StringIO()
    code = secrets.refuse(secrets.MissingSecret(["YOUTUBE_STREAM_KEY"]), stream=out)
    assert code == 1
    assert out.getvalue() == "missing: YOUTUBE_STREAM_KEY\n"


def test_environment_wins_over_file(write_secrets, monkeypatch):
    write_secrets(OBS_WEBSOCKET_PASSWORD="from-file")
    monkeypatch.setenv("OBS_WEBSOCKET_PASSWORD", "from-env")
    assert secrets.load().get("OBS_WEBSOCKET_PASSWORD") == "from-env"


def test_absent_file_is_not_an_error_but_every_key_is_missing():
    s = secrets.load()
    assert not s.has_adapter("obs")
    assert s.missing(*secrets.NEEDED["youtube"]) == secrets.NEEDED["youtube"]


def test_example_file_declares_every_needed_name():
    declared = set(secrets.known_names())
    for adapter, names in secrets.NEEDED.items():
        assert set(names) <= declared, f"{adapter} needs a name the example file lacks"


def test_dataset_rows_are_append_only_with_stable_ids(ds):
    a = ds.append("stream", video_id="abc", platform="youtube")
    b = ds.append("result", video_id="abc", field="views", value=256)
    assert (a.id, b.id) == ("row-000001", "row-000002")
    assert [r.id for r in ds.rows()] == [a.id, b.id]
    assert ds.get(b.id)["value"] == 256
    assert ds.latest(kind="stream", video_id="abc").id == a.id
    assert ds.latest(kind="stream", video_id="nope") is None


def test_dataset_refuses_to_let_a_caller_set_the_id(ds):
    with pytest.raises(ValueError):
        ds.append("stream", id="row-000099")


def test_config_round_trips_and_missing_is_a_named_error(tmp_path):
    with pytest.raises(config.NoConfig):
        config.load()
    cfg = config.Config(scenes=["Starting Soon", "Main"], text_sources=["Current Goals"],
                        countdown_scene="Starting Soon", main_scene="Main",
                        endpoints=[config.Endpoint("youtube", "YOUTUBE_INGEST_URL",
                                                   "YOUTUBE_STREAM_KEY")])
    path = cfg.save()
    assert path == tmp_path / "config.json"
    back = config.load()
    assert back.scenes == ["Starting Soon", "Main"]
    assert back.endpoints[0].platform == "youtube"
    assert back.countdown_seconds == 600
