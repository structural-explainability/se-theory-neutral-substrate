"""tests/test_orchestrate.py - Tests for orchestrate.py."""

from collections.abc import Generator
from unittest.mock import MagicMock, patch

import pytest

from se_theory_neutral_substrate.orchestrate import run_validate


@pytest.fixture(autouse=True)
def mock_sync_all() -> Generator[MagicMock]:
    with patch("se_theory_neutral_substrate.orchestrate.sync_all") as m:
        yield m


@pytest.fixture()
def mock_loads() -> Generator[None]:
    manifest: dict[str, object] = {"repo": {"version": "0.1.0"}}
    schema: dict[str, object] = {}
    with (
        patch(
            "se_theory_neutral_substrate.orchestrate.load_manifest",
            return_value=manifest,
        ),
        patch(
            "se_theory_neutral_substrate.orchestrate.load_schema", return_value=schema
        ),
        patch(
            "se_theory_neutral_substrate.orchestrate.validate_schema_internal",
            return_value=[],
        ),
        patch(
            "se_theory_neutral_substrate.orchestrate.validate_manifest", return_value=[]
        ),
    ):
        yield


def test_run_validate_success(mock_loads: None) -> None:
    """run_validate returns 0 when all checks pass."""
    assert run_validate() == 0


def test_run_validate_strict_no_warnings(mock_loads: None) -> None:
    """run_validate returns 0 in strict mode when there are no warnings."""
    assert run_validate(strict=True) == 0


def test_run_validate_errors_returns_1() -> None:
    """run_validate returns 1 when validation errors are found."""
    with (
        patch("se_theory_neutral_substrate.orchestrate.load_manifest", return_value={}),
        patch("se_theory_neutral_substrate.orchestrate.load_schema", return_value={}),
        patch(
            "se_theory_neutral_substrate.orchestrate.validate_schema_internal",
            return_value=["bad schema"],
        ),
        patch(
            "se_theory_neutral_substrate.orchestrate.validate_manifest", return_value=[]
        ),
    ):
        assert run_validate() == 1


def test_run_validate_file_not_found_returns_1() -> None:
    """run_validate returns 1 when SE_MANIFEST.toml is missing."""
    with patch(
        "se_theory_neutral_substrate.orchestrate.load_manifest",
        side_effect=FileNotFoundError("SE_MANIFEST.toml not found"),
    ):
        assert run_validate() == 1


def test_run_validate_require_tag_calls_validate_tag() -> None:
    """run_validate calls validate_tag when require_tag=True."""
    with (
        patch("se_theory_neutral_substrate.orchestrate.load_manifest", return_value={}),
        patch("se_theory_neutral_substrate.orchestrate.load_schema", return_value={}),
        patch(
            "se_theory_neutral_substrate.orchestrate.validate_schema_internal",
            return_value=[],
        ),
        patch(
            "se_theory_neutral_substrate.orchestrate.validate_manifest", return_value=[]
        ),
        patch(
            "se_theory_neutral_substrate.orchestrate.validate_tag", return_value=[]
        ) as mock_tag,
    ):
        run_validate(require_tag=True)
        mock_tag.assert_called_once()


def test_run_validate_require_tag_not_called_by_default() -> None:
    """run_validate does not call validate_tag when require_tag=False."""
    with (
        patch("se_theory_neutral_substrate.orchestrate.load_manifest", return_value={}),
        patch("se_theory_neutral_substrate.orchestrate.load_schema", return_value={}),
        patch(
            "se_theory_neutral_substrate.orchestrate.validate_schema_internal",
            return_value=[],
        ),
        patch(
            "se_theory_neutral_substrate.orchestrate.validate_manifest", return_value=[]
        ),
        patch(
            "se_theory_neutral_substrate.orchestrate.validate_tag", return_value=[]
        ) as mock_tag,
    ):
        run_validate()
        mock_tag.assert_not_called()
