"""reference_tool/export.py - Export generated JSON artifacts from reference TOML files.

The reference/*.toml files are hand-authored registry mirrors.
The data/neutral-substrate/*.json files are generated artifacts derived
from those references.

This module does not define theory semantics.
"""

from dataclasses import dataclass
import json
from pathlib import Path
from typing import Any

from se_theory_neutral_substrate.load import load_toml
from se_theory_neutral_substrate.paths import repo_root
from se_theory_neutral_substrate.reference_tool.config import (
    ARTIFACT_SLUG,
    CATALOG_ARTIFACT_NAME,
    CATALOG_SCHEMA,
    GENERATED_DATA_DIR,
    REFERENCE_DIR_NAME,
    REFERENCE_NAMESPACE,
    REPO_SLUG,
)

ROOT_DIR = repo_root()
REFERENCE_DIR = ROOT_DIR / REFERENCE_DIR_NAME
DATA_DIR = ROOT_DIR / GENERATED_DATA_DIR

JsonObject = dict[str, Any]


@dataclass(frozen=True)
class ExportSpec:
    """A generated JSON artifact export specification."""

    source_name: str
    source_table: str
    output_name: str
    schema: str
    payload_key: str


def registry_schema(registry_name: str) -> str:
    """Return the generated JSON schema id for one registry."""
    return f"se-{ARTIFACT_SLUG}-{registry_name}-registry-1"


EXPORT_SPECS: tuple[ExportSpec, ...] = (
    ExportSpec(
        source_name="substrate-types.toml",
        source_table="type",
        output_name="substrate-type-registry.json",
        schema=registry_schema("type"),
        payload_key="types",
    ),
    ExportSpec(
        source_name="substrate-predicates.toml",
        source_table="predicate",
        output_name="substrate-predicate-registry.json",
        schema=registry_schema("predicate"),
        payload_key="predicates",
    ),
    ExportSpec(
        source_name="substrate-axioms.toml",
        source_table="axiom",
        output_name="substrate-axiom-registry.json",
        schema=registry_schema("axiom"),
        payload_key="axioms",
    ),
    ExportSpec(
        source_name="substrate-theorems.toml",
        source_table="theorem",
        output_name="substrate-theorem-registry.json",
        schema=registry_schema("theorem"),
        payload_key="theorems",
    ),
    ExportSpec(
        source_name="substrate-requirements.toml",
        source_table="requirement",
        output_name="substrate-requirement-registry.json",
        schema=registry_schema("requirement"),
        payload_key="requirements",
    ),
    ExportSpec(
        source_name="traceability-registry.toml",
        source_table="trace",
        output_name="traceability-registry.json",
        schema=f"se-{ARTIFACT_SLUG}-traceability-registry-1",
        payload_key="traces",
    ),
)


def read_reference_toml(path: Path) -> JsonObject:
    """Read a reference TOML file as a dictionary."""
    data = load_toml(path)

    if not isinstance(data, dict):
        msg = f"Expected TOML object in {path}"
        raise ValueError(msg)

    return data


def ordered_table_values(document: JsonObject, table_name: str) -> list[JsonObject]:
    """Return nested table values sorted by order, then id/key."""
    table = document.get(table_name, {})
    if not isinstance(table, dict):
        msg = f"Expected [{table_name}.<id>] tables"
        raise ValueError(msg)

    entries: list[JsonObject] = []
    for key, value in table.items():
        if not isinstance(value, dict):
            msg = f"Expected table entry for {table_name}.{key}"
            raise ValueError(msg)

        entry = dict(value)
        entry.setdefault("id", key)
        entries.append(entry)

    return sorted(
        entries,
        key=lambda item: (
            item.get("order", 999_999),
            str(item.get("id", "")),
        ),
    )


def artifact_meta(document: JsonObject) -> JsonObject:
    """Return normalized metadata from a reference artifact."""
    meta = document.get("meta", {})
    if not isinstance(meta, dict):
        msg = "Expected [meta] table"
        raise ValueError(msg)

    return dict(meta)


def build_registry_payload(spec: ExportSpec) -> JsonObject:
    """Build one generated registry payload from one reference TOML file."""
    source_path = REFERENCE_DIR / spec.source_name
    document = read_reference_toml(source_path)
    meta = artifact_meta(document)
    entries = ordered_table_values(document, spec.source_table)

    return {
        "schema": spec.schema,
        "source": meta.get("source", REPO_SLUG),
        "namespace": meta.get("namespace", REFERENCE_NAMESPACE),
        "artifact": spec.output_name.removesuffix(".json"),
        "reference_artifact": meta.get(
            "artifact",
            spec.source_name.removesuffix(".toml"),
        ),
        "reference_path": source_path.as_posix(),
        spec.payload_key: entries,
    }


def reference_file_path(file_name: str) -> Path:
    """Return the path to a reference TOML file."""
    return REFERENCE_DIR / file_name


def reference_file_posix(file_name: str) -> str:
    """Return the POSIX path to a reference TOML file."""
    return reference_file_path(file_name).as_posix()


def table_values(file_name: str, table_name: str) -> list[JsonObject]:
    """Load ordered table values from one reference TOML file."""
    return ordered_table_values(
        read_reference_toml(reference_file_path(file_name)),
        table_name,
    )


def build_neutral_substrate_catalog() -> JsonObject:
    """Build the generated neutral substrate catalog from reference artifacts."""
    reference_files = [
        "substrate-types.toml",
        "substrate-predicates.toml",
        "substrate-axioms.toml",
        "substrate-theorems.toml",
        "substrate-requirements.toml",
        "traceability-registry.toml",
    ]

    reference_paths = [reference_file_posix(file_name) for file_name in reference_files]

    dependency_file = "dependency-registry.toml"
    dependency_path = reference_file_path(dependency_file)
    dependencies: list[JsonObject] = []

    if dependency_path.exists():
        dependencies = table_values(dependency_file, "dependency")
        reference_paths.append(dependency_path.as_posix())

    return {
        "schema": CATALOG_SCHEMA,
        "source": REPO_SLUG,
        "namespace": REFERENCE_NAMESPACE,
        "artifact": CATALOG_ARTIFACT_NAME,
        "reference_paths": reference_paths,
        "types": table_values("substrate-types.toml", "type"),
        "predicates": table_values("substrate-predicates.toml", "predicate"),
        "axioms": table_values("substrate-axioms.toml", "axiom"),
        "theorems": table_values("substrate-theorems.toml", "theorem"),
        "requirements": table_values("substrate-requirements.toml", "requirement"),
        "traces": table_values("traceability-registry.toml", "trace"),
        "dependencies": dependencies,
    }


def encode_json(payload: JsonObject) -> str:
    """Encode a JSON payload deterministically."""
    return (
        json.dumps(
            payload,
            indent=2,
            sort_keys=False,
            ensure_ascii=True,
        )
        + "\n"
    )


def write_or_check(path: Path, content: str, *, check: bool) -> bool:
    """Write a file or check whether it is current.

    Returns True when the file is current or was written.
    Returns False when check mode finds stale content.
    """
    if check:
        if not path.exists():
            print(f"[stale] {path.as_posix()} is missing")
            return False

        current = path.read_text(encoding="utf-8")
        if current != content:
            print(f"[stale] {path.as_posix()} is out of date")
            return False

        print(f"[ok   ] {path.as_posix()}")
        return True

    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    print(f"[write] {path.as_posix()}")
    return True


def export_registry(spec: ExportSpec, *, check: bool) -> bool:
    """Export one registry JSON artifact."""
    payload = build_registry_payload(spec)
    output_path = DATA_DIR / spec.output_name
    return write_or_check(output_path, encode_json(payload), check=check)


def export_catalog(*, check: bool) -> bool:
    """Export the combined neutral substrate catalog JSON artifact."""
    payload = build_neutral_substrate_catalog()
    output_path = DATA_DIR / f"{CATALOG_ARTIFACT_NAME}.json"
    return write_or_check(output_path, encode_json(payload), check=check)


def run_ref_export(*, check: bool = False) -> int:
    """Export generated JSON artifacts from reference TOML files."""
    results = [export_registry(spec, check=check) for spec in EXPORT_SPECS]
    results.append(export_catalog(check=check))

    if all(results):
        if check:
            print("Reference exports are current.")
        else:
            print("Reference export completed.")
        return 0

    print("Reference exports are stale.")
    return 1
