"""load.py - Loading and parsing for se-theory-neutral-substrate.

Owns:
  - load_toml()        - read any TOML file
  - load_schema()      - read manifest-schema.toml
"""

from importlib.resources import files
from pathlib import Path
import tomllib
from typing import Any


def load_toml(path: Path) -> dict[str, Any]:
    """Load and return TOML data from the specified path."""
    return tomllib.loads(path.read_text(encoding="utf-8"))


def load_schema() -> dict[str, Any]:
    """Load manifest-schema.toml from the installed se-manifest-schema package."""
    schema_path = files("se_manifest_schema") / "manifest-schema.toml"
    with schema_path.open("rb") as f:
        return tomllib.load(f)
