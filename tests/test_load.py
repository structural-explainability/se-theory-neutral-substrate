"""tests/test_load.py - Tests for load.py."""

from pathlib import Path

import pytest
from se_manifest_schema.load import load_manifest

from se_theory_neutral_substrate.load import (
    load_schema,
    load_toml,
)


def test_load_toml(tmp_path: Path) -> None:
    """load_toml reads a valid TOML file."""
    f = tmp_path / "test.toml"
    f.write_text('[section]\nkey = "value"\n', encoding="utf-8")
    result = load_toml(f)
    assert result["section"]["key"] == "value"


def test_load_schema_returns_dict() -> None:
    """load_schema returns a non-empty dict from the installed package."""
    schema = load_schema()
    assert isinstance(schema, dict)
    assert len(schema) > 0


def test_load_manifest_missing(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    """load_manifest raises FileNotFoundError when SE_MANIFEST.toml is absent."""
    monkeypatch.chdir(tmp_path)
    with pytest.raises(FileNotFoundError):
        load_manifest()


def test_load_manifest_present(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    """load_manifest loads SE_MANIFEST.toml from cwd."""
    monkeypatch.chdir(tmp_path)
    (tmp_path / "SE_MANIFEST.toml").write_text(
        '[repo]\nversion = "0.1.0"\n', encoding="utf-8"
    )
    result = load_manifest()
    assert result["repo"]["version"] == "0.1.0"
