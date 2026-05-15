"""Tests for generated reference data exports."""

import json
from pathlib import Path

from se_theory_neutral_substrate import export


def test_encode_json_is_deterministic() -> None:
    """JSON encoding should be stable and newline-terminated."""
    payload = {"schema": "x", "items": [{"id": "A"}]}

    encoded = export.encode_json(payload)

    assert encoded.endswith("\n")
    assert json.loads(encoded) == payload


def test_ordered_table_values_sorts_by_order_then_id() -> None:
    """Nested TOML-style tables should export in deterministic order."""
    document = {
        "operator": {
            "B": {"id": "B", "order": 2},
            "A": {"id": "A", "order": 1},
            "C": {"id": "C"},
        }
    }

    values = export.ordered_table_values(document, "operator")

    assert [item["id"] for item in values] == ["A", "B", "C"]


def test_ordered_table_values_adds_id_from_key() -> None:
    """Entries missing id should receive the table key as id."""
    document = {
        "family": {
            "Aggregation": {"order": 1},
        }
    }

    values = export.ordered_table_values(document, "family")

    assert values == [{"order": 1, "id": "Aggregation"}]


def test_artifact_meta_returns_meta_copy() -> None:
    """Artifact metadata should be returned as a plain dictionary copy."""
    document = {"meta": {"source": "se-theory-persistence"}}

    meta = export.artifact_meta(document)

    assert meta == {"source": "se-theory-persistence"}
    assert meta is not document["meta"]


def test_write_or_check_writes_file(tmp_path: Path) -> None:
    """Non-check mode should write the requested file."""
    target = tmp_path / "nested" / "artifact.json"

    result = export.write_or_check(target, '{"ok": true}\n', check=False)

    assert result is True
    assert target.read_text(encoding="utf-8") == '{"ok": true}\n'


def test_write_or_check_check_mode_accepts_current_file(tmp_path: Path) -> None:
    """Check mode should pass when file content is current."""
    target = tmp_path / "artifact.json"
    target.write_text('{"ok": true}\n', encoding="utf-8")

    result = export.write_or_check(target, '{"ok": true}\n', check=True)

    assert result is True


def test_write_or_check_check_mode_rejects_stale_file(tmp_path: Path) -> None:
    """Check mode should fail when file content differs."""
    target = tmp_path / "artifact.json"
    target.write_text('{"ok": false}\n', encoding="utf-8")

    result = export.write_or_check(target, '{"ok": true}\n', check=True)

    assert result is False


def test_write_or_check_check_mode_rejects_missing_file(tmp_path: Path) -> None:
    """Check mode should fail when file is missing."""
    target = tmp_path / "missing.json"

    result = export.write_or_check(target, '{"ok": true}\n', check=True)

    assert result is False
