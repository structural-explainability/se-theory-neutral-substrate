"""reference_tool/runner.py - Public runners for reference registry tooling."""

from pathlib import Path
from typing import Any

from se_theory_neutral_substrate.load import load_toml
from se_theory_neutral_substrate.paths import repo_root
from se_theory_neutral_substrate.reference_tool.artifacts import (
    process_artifact,
    process_artifacts,
)
from se_theory_neutral_substrate.reference_tool.index import (
    load_reference_index,
    reference_artifacts,
    surface_module,
)
from se_theory_neutral_substrate.reference_tool.models import ArtifactResult
from se_theory_neutral_substrate.reference_tool.validation import is_strict_warning


def run_scaffold(dry_run: bool = False, overwrite: bool = False) -> int:
    """Scaffold and validate all reference artifacts for this repository."""
    root = repo_root()

    try:
        index = load_reference_index(root)
    except Exception as exc:
        print(f"error: cannot load reference/index.toml: {exc}")
        return 1

    index_surface_module = surface_module(index)

    if dry_run:
        print("[dry-run - nothing will be written]")

    all_registered = collect_registered_symbols(root, index)

    all_ok = process_artifacts(
        dry_run=dry_run,
        overwrite=overwrite,
        repo_root=root,
        index=index,
        index_surface_module=index_surface_module,
        all_registered=all_registered,
    )

    return 0 if all_ok else 1


def run_ref_validate(strict: bool = False) -> int:
    """Validate reference artifacts without adding stubs."""
    root = repo_root()

    try:
        index = load_reference_index(root)
    except Exception as exc:
        print(f"error: cannot load reference/index.toml: {exc}")
        return 1

    index_surface_module = surface_module(index)
    all_registered = collect_registered_symbols(root, index)

    results = [
        validate_artifact(
            artifact=artifact,
            root=root,
            index_surface_module=index_surface_module,
            all_registered=all_registered,
        )
        for artifact in reference_artifacts(index)
    ]

    return 0 if all(result_is_ok(result, strict=strict) for result in results) else 1


def validate_artifact(
    artifact: dict[str, Any],
    root: Path,
    index_surface_module: str,
    all_registered: set[str],
) -> ArtifactResult:
    """Validate one reference artifact and print its result."""
    result = process_artifact(
        artifact=artifact,
        repo_root=root,
        index_surface_module=index_surface_module,
        dry_run=True,
        overwrite=False,
        all_registered=all_registered,
    )

    tag = "ok  " if result.ok else "FAIL"
    print(f"  [{tag}]  {result.artifact_id}")

    for message in result.messages:
        if "skipped" not in message:
            print(message)

    return result


def result_is_ok(result: ArtifactResult, strict: bool) -> bool:
    """Return whether an artifact result passes validation."""
    has_strict_warnings = any(is_strict_warning(msg) for msg in result.messages)
    return result.ok and not (strict and has_strict_warnings)


def collect_registered_symbols(root: Path, index: dict[str, Any]) -> set[str]:
    """Collect all Lean symbols already registered in TOML artifacts."""
    registered: set[str] = set()

    for artifact in reference_artifacts(index):
        registered.update(collect_artifact_symbols(root, artifact))

    return registered


def collect_artifact_symbols(root: Path, artifact: dict[str, Any]) -> set[str]:
    """Collect Lean symbols from one TOML reference artifact."""
    path = artifact_toml_path(root, artifact)

    if path is None or not path.exists():
        return set()

    try:
        data = load_toml(path)
    except Exception as exc:  # noqa: S112
        print(f"warning: cannot load artifact TOML {path}: {exc}")
        return set()

    return lean_symbols_in_data(data)


def artifact_toml_path(root: Path, artifact: dict[str, Any]) -> Path | None:
    """Return the path for a TOML artifact, or None if it should be skipped."""
    path_value = artifact.get("path", "")
    artifact_format = artifact.get("format", "toml")

    if not isinstance(path_value, str) or artifact_format != "toml":
        return None

    return root / path_value


def lean_symbols_in_data(data: dict[str, Any]) -> set[str]:
    """Collect lean_symbol values from loaded registry data."""
    symbols: set[str] = set()

    for section_value in data.values():
        if isinstance(section_value, dict):
            symbols.update(lean_symbols_in_section(section_value))

    return symbols


def lean_symbols_in_section(section: dict[Any, Any]) -> set[str]:
    """Collect lean_symbol values from one registry section."""
    symbols: set[str] = set()

    for entry in section.values():
        if isinstance(entry, dict) and "lean_symbol" in entry:
            symbols.add(str(entry["lean_symbol"]))

    return symbols
