"""validate_reference.py - Validate reference artifacts for se-theory-neutral-substrate.

Owns:
  - validate_reference()        - run all reference artifact checks
  - validate_reference_index()  - check reference/index.toml structure
  - validate_artifact_paths()   - check declared artifact files exist
  - validate_artifact_formats() - check declared formats match file suffixes
  - validate_surface_coverage() - check reference files cover the Lean public surface

Does not own:
  - file loading
  - manifest validation
  - version/tag synchronization
  - CLI argument parsing

Reference validation checks that the repo's machine-readable reference surface is
coherent before se-formal-contract imports it.

Expected local boundary:
  NeutralSubstrate/Surface.lean declares the public Lean surface.
  reference/index.toml declares the public reference artifact surface.
  reference/*.toml and reference/*.json describe that surface for automation.

Current validation strategy:
  The expected Lean surface is mirrored in lean_surface.py.
  This can later be replaced or supplemented by parsing Surface.lean directly.

Call chain:
  __main__.py -> cli.main()
              -> orchestrate.run_validate()
              -> validate_reference.validate_reference()
"""

from __future__ import annotations

from pathlib import Path
from typing import cast

from se_theory_neutral_substrate.lean_surface import SURFACE_BY_KIND
from se_theory_neutral_substrate.load import load_json, load_reference_index, load_toml
from se_theory_neutral_substrate.paths import reference_artifact_path, repo_root

type TomlJsonValue = (
    str | int | float | bool | None | list["TomlJsonValue"] | dict[str, "TomlJsonValue"]
)

type ArtifactEntry = dict[str, TomlJsonValue]
type ReferenceIndex = dict[str, TomlJsonValue]
type ReferenceData = dict[str, TomlJsonValue]


_REQUIRED_ARTIFACT_FIELDS: frozenset[str] = frozenset(
    {
        "id",
        "path",
        "kind",
        "format",
        "generated",
        "required",
    }
)

_FORMAT_SUFFIXES: dict[str, str] = {
    "json": ".json",
    "toml": ".toml",
}

_SURFACE_KIND_TO_ARTIFACT_ID: dict[str, str] = {
    "axiom": "substrate-axioms",
    "predicate": "substrate-predicates",
    "theorem": "substrate-theorems",
    "type": "substrate-types",
}


def load_reference_artifact(path: Path, artifact_format: str) -> ReferenceData:
    """Load a reference artifact according to its declared format."""
    if artifact_format == "toml":
        return cast(ReferenceData, load_toml(path))
    if artifact_format == "json":
        return cast(ReferenceData, load_json(path))

    raise ValueError(f"Unsupported reference artifact format: {artifact_format}")


def validate_reference(repo_dir: Path | None = None) -> list[str]:
    """Run all reference artifact checks.

    Args:
        repo_dir: Optional repository root. Defaults to the discovered root.

    Returns:
        A list of validation error messages.
    """
    root = repo_dir or repo_root()
    errors: list[str] = []

    try:
        index = cast(ReferenceIndex, load_reference_index(root))
    except FileNotFoundError as e:
        return [f"reference/index.toml not found: {e}"]

    print("[validate] reference/index.toml")
    errors.extend(validate_reference_index(index))

    artifacts = _artifact_entries(index)

    print("[validate] reference/artifact paths")
    errors.extend(validate_artifact_paths(artifacts, repo_dir=root))

    print("[validate] reference/artifact formats")
    errors.extend(validate_artifact_formats(artifacts))

    print("[validate] reference/Lean surface coverage")
    errors.extend(validate_surface_coverage(artifacts, repo_dir=root))

    return errors


def validate_reference_index(index: ReferenceIndex) -> list[str]:
    """Check reference/index.toml structure."""
    errors: list[str] = []

    schema = index.get("schema")
    if not isinstance(schema, str) or not schema:
        errors.append("reference/index.toml must define non-empty string field: schema")

    repo = index.get("repo")
    if repo != "se-theory-neutral-substrate":
        errors.append(
            "reference/index.toml must define repo = \"se-theory-neutral-substrate\""
        )

    artifacts_value = index.get("artifact")
    if not isinstance(artifacts_value, list):
        errors.append(
            "reference/index.toml must define one or more [[artifact]] entries."
        )
        return errors

    artifacts = _artifact_entries(index)
    seen_ids: set[str] = set()
    seen_paths: set[str] = set()

    for number, artifact in enumerate(artifacts, start=1):
        missing = sorted(_REQUIRED_ARTIFACT_FIELDS - artifact.keys())
        for field in missing:
            errors.append(f"Artifact entry {number} is missing required field: {field}")

        artifact_id = artifact.get("id")
        if isinstance(artifact_id, str):
            if artifact_id in seen_ids:
                errors.append(f"Duplicate artifact id: {artifact_id}")
            seen_ids.add(artifact_id)
        else:
            errors.append(f"Artifact entry {number} field id must be a string.")

        artifact_path = artifact.get("path")
        if isinstance(artifact_path, str):
            if artifact_path in seen_paths:
                errors.append(f"Duplicate artifact path: {artifact_path}")
            seen_paths.add(artifact_path)
        else:
            errors.append(f"Artifact entry {number} field path must be a string.")

        artifact_kind = artifact.get("kind")
        if not isinstance(artifact_kind, str):
            errors.append(f"Artifact entry {number} field kind must be a string.")

        artifact_format = artifact.get("format")
        if not isinstance(artifact_format, str):
            errors.append(f"Artifact entry {number} field format must be a string.")

        generated = artifact.get("generated")
        if not isinstance(generated, bool):
            errors.append(f"Artifact entry {number} field generated must be a boolean.")

        required = artifact.get("required")
        if not isinstance(required, bool):
            errors.append(f"Artifact entry {number} field required must be a boolean.")

    return errors


def validate_artifact_paths(
    artifacts: list[ArtifactEntry],
    *,
    repo_dir: Path,
) -> list[str]:
    """Check declared artifact files exist."""
    errors: list[str] = []

    for artifact in artifacts:
        artifact_id = _artifact_id_for_message(artifact)
        path_value = artifact.get("path")

        if not isinstance(path_value, str):
            continue

        try:
            path = reference_artifact_path(path_value, root=repo_dir)
        except ValueError as e:
            errors.append(f"{artifact_id}: {e}")
            continue

        if not path.exists():
            errors.append(
                f"{artifact_id}: declared artifact does not exist: {path_value}"
            )
        elif not path.is_file():
            errors.append(
                f"{artifact_id}: declared artifact is not a file: {path_value}"
            )

    return errors


def validate_artifact_formats(artifacts: list[ArtifactEntry]) -> list[str]:
    """Check declared artifact formats match file suffixes."""
    errors: list[str] = []

    for artifact in artifacts:
        artifact_id = _artifact_id_for_message(artifact)
        path_value = artifact.get("path")
        format_value = artifact.get("format")

        if not isinstance(path_value, str) or not isinstance(format_value, str):
            continue

        expected_suffix = _FORMAT_SUFFIXES.get(format_value)
        if expected_suffix is None:
            allowed = ", ".join(sorted(_FORMAT_SUFFIXES))
            errors.append(
                f"{artifact_id}: unsupported format {format_value!r}; "
                f"expected one of: {allowed}"
            )
            continue

        if not path_value.endswith(expected_suffix):
            errors.append(
                f"{artifact_id}: format {format_value!r} requires suffix "
                f"{expected_suffix!r}, got path {path_value!r}"
            )

    return errors


def validate_surface_coverage(
    artifacts: list[ArtifactEntry],
    *,
    repo_dir: Path,
) -> list[str]:
    """Check reference files cover the Lean public surface."""
    errors: list[str] = []
    artifacts_by_id: dict[str, ArtifactEntry] = {}

    for artifact in artifacts:
        artifact_id = artifact.get("id")
        if isinstance(artifact_id, str):
            artifacts_by_id[artifact_id] = artifact

    for surface_kind, expected_symbols in SURFACE_BY_KIND.items():
        artifact_id = _SURFACE_KIND_TO_ARTIFACT_ID[surface_kind]
        artifact = artifacts_by_id.get(artifact_id)

        if artifact is None:
            errors.append(
                f"Missing artifact for Lean surface kind {surface_kind!r}: {artifact_id}"
            )
            continue

        path_value = artifact.get("path")
        format_value = artifact.get("format")

        if not isinstance(path_value, str) or not isinstance(format_value, str):
            continue

        try:
            artifact_path = reference_artifact_path(path_value, root=repo_dir)
            data = load_reference_artifact(artifact_path, format_value)
        except (FileNotFoundError, TypeError, ValueError) as e:
            errors.append(
                f"{artifact_id}: could not load artifact for surface check: {e}"
            )
            continue

        present_symbols = _collect_lean_symbols(data)
        missing_symbols = sorted(expected_symbols - present_symbols)

        for symbol in missing_symbols:
            errors.append(
                f"{artifact_id}: missing Lean surface symbol {symbol!r} "
                f"for kind {surface_kind!r}"
            )

    return errors


def _artifact_entries(index: ReferenceIndex) -> list[ArtifactEntry]:
    """Return artifact entries from a reference index."""
    artifacts_value = index.get("artifact")
    if not isinstance(artifacts_value, list):
        return []

    artifacts: list[ArtifactEntry] = []

    for item in artifacts_value:
        if isinstance(item, dict):
            artifact = cast(ArtifactEntry, item)
            artifacts.append(artifact)

    return artifacts


def _artifact_id_for_message(artifact: ArtifactEntry) -> str:
    """Return an artifact identifier suitable for validation messages."""
    artifact_id = artifact.get("id")
    if isinstance(artifact_id, str) and artifact_id:
        return artifact_id
    return "<unknown-artifact>"


def _collect_lean_symbols(value: TomlJsonValue) -> set[str]:
    """Collect lean_symbol values recursively from TOML or JSON data."""
    symbols: set[str] = set()

    if isinstance(value, dict):
        lean_symbol = value.get("lean_symbol")
        if isinstance(lean_symbol, str):
            symbols.add(lean_symbol)

        for child in value.values():
            symbols.update(_collect_lean_symbols(child))

    elif isinstance(value, list):
        for child in value:
            symbols.update(_collect_lean_symbols(child))

    return symbols
