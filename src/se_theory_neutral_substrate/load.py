"""load.py - Loading and parsing for se-theory-neutral-substrate.

Owns:
  - load_toml()             - read any TOML file
  - load_json()             - read any JSON file
  - load_manifest_schema()  - read manifest-schema.toml
  - load_reference_index()  - read reference/index.toml

Does not own validation logic.
Validation belongs in orchestrate.py and validate_reference.py.
"""

from importlib.resources import files
import json
from pathlib import Path
import tomllib
from typing import Any


def load_toml(path: Path) -> dict[str, Any]:
    """Load and return TOML data from the specified path."""
    return tomllib.loads(path.read_text(encoding="utf-8"))


def load_json(path: Path) -> dict[str, Any]:
    """Load and return JSON data from the specified path."""
    return json.loads(path.read_text(encoding="utf-8"))


def load_manifest_schema() -> dict[str, Any]:
    """Load manifest-schema.toml from the installed se-manifest-schema package."""
    schema_path = files("se_manifest_schema") / "manifest-schema.toml"
    with schema_path.open("rb") as f:
        return tomllib.load(f)


def load_reference_index(repo_dir: Path) -> dict[str, Any]:
    """Load reference/index.toml from the repository root."""
    return load_toml(repo_dir / "reference" / "index.toml")
