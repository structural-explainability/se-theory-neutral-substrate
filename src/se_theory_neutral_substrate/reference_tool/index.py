"""reference_tool/index.py - Reference index loading and inspection."""

from pathlib import Path
from typing import Any

from se_theory_neutral_substrate.load import load_toml
from se_theory_neutral_substrate.paths import reference_index_path

Artifact = dict[str, Any]
ReferenceIndex = dict[str, Any]


def load_reference_index(root: Path | None = None) -> ReferenceIndex:
    """Load reference/index.toml."""
    path = reference_index_path(root)

    if not path.exists():
        raise FileNotFoundError(f"reference/index.toml not found: {path}")

    return load_toml(path)


def reference_artifacts(index: ReferenceIndex) -> list[Artifact]:
    """Return artifact declarations from reference/index.toml."""
    artifacts = index.get("artifact", [])

    if not isinstance(artifacts, list):
        raise TypeError("reference/index.toml field 'artifact' must be a list.")

    return [item for item in artifacts if isinstance(item, dict)]


def surface_module(index: ReferenceIndex) -> str:
    """Return the declared public Lean surface module."""
    value = index.get("surface_module", "")

    if not isinstance(value, str) or not value:
        raise ValueError("reference/index.toml must declare surface_module.")

    return value
