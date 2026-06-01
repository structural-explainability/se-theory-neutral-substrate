"""Shared reference/ validation utilities for SE theory repositories."""

from pathlib import Path
from typing import Any


def section_entries(data: dict[str, Any], section: str) -> dict[str, dict[str, Any]]:
    """Return table entries for a reference section."""
    return {
        key: value
        for key, value in data.get(section, {}).items()
        if isinstance(value, dict)
    }


def source_modules_in_registry(data: dict[str, Any]) -> list[str]:
    """Return unique source modules declared by registry entries."""
    seen: set[str] = set()
    result: list[str] = []

    for section_value in data.values():
        if not isinstance(section_value, dict):
            continue
        for entry in section_value.values():
            if not isinstance(entry, dict):
                continue
            module = entry.get("source_module", "")
            if module and module not in seen:
                seen.add(module)
                result.append(module)

    return result


def module_to_path(module: str, lean_root: Path) -> Path:
    """Convert a Lean module name to a file path."""
    parts = module.split(".")
    return lean_root.joinpath(*parts[:-1]) / f"{parts[-1]}.lean"


def kind_to_section(artifact_kind: str) -> str:
    """Map artifact kind to registry section name."""
    without_suffix = artifact_kind.removesuffix("-registry")
    without_suffix = without_suffix.removesuffix("-definitions")
    return (
        without_suffix.rsplit("-", 1)[-1] if "-" in without_suffix else without_suffix
    )


def toml_value(value: Any) -> str:
    """Format a minimal TOML value."""
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, str):
        return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'
    if isinstance(value, list):
        return "[" + ", ".join(toml_value(item) for item in value) + "]"
    return str(value)


def write_registry_toml(path: Path, data: dict[str, Any]) -> None:
    """Write a simple registry TOML file."""
    header_keys = ["schema", "repo", "surface_module", "namespace"]
    lines: list[str] = []

    for key in header_keys:
        if key in data and not isinstance(data[key], dict):
            lines.append(f"{key} = {toml_value(data[key])}")

    lines.append("")

    for section_key, section_value in data.items():
        if section_key in header_keys or not isinstance(section_value, dict):
            continue
        for entry_id, entry in section_value.items():
            if not isinstance(entry, dict):
                continue
            lines.append(f"[{section_key}.{entry_id}]")
            for field_key, field_value in entry.items():
                lines.append(f"{field_key} = {toml_value(field_value)}")
            lines.append("")

    path.write_text("\n".join(lines), encoding="utf-8")
