"""orchestrate.py - Validation orchestrator for se-theory-neutral-substrate.

Owns run_validate(). Called by cli.py. Always syncs before validating.
This is the only file in this package that knows the full validation order.

Validation order:
  1. sync_all()                  - align CITATION.cff and pyproject.toml
  2. validate_tag()              - repo.version matches git tag (--require-tag only)
  3. validate_schema_internal()  - manifest-schema.toml is self-consistent
  4. validate_manifest()         - SE_MANIFEST.toml conforms to the schema
  5. validate_reference()        - reference/index.toml and reference artifacts are coherent

Consumers in other repos should not call run_validate().
They should call the specific validation function they need.
"""

from typing import cast

from se_manifest_schema.load import load_manifest
from se_manifest_schema.sync import sync_all
from se_manifest_schema.types.manifest_schema import ManifestSchemaData
from se_manifest_schema.validate_contract import validate_tag
from se_manifest_schema.validate_manifest import validate_manifest
from se_manifest_schema.validate_schema import validate_schema_internal

from se_theory_neutral_substrate.load import load_manifest_schema
from se_theory_neutral_substrate.reference import run_ref_validate


def run_validate(*, require_tag: bool = False, strict: bool = False) -> int:
    """Sync and validate this theory repository.

    Args:
        require_tag: If True, verify repo.version matches current git tag.
        strict: If True, treat warnings as errors.

    Returns:
        0 on success, 1 on failure.
    """
    sync_all()

    errors: list[str] = []
    warnings: list[str] = []

    try:
        manifest = load_manifest()
        schema = load_manifest_schema()
    except FileNotFoundError as e:
        print(f"ERROR: {e}")
        return 1

    print("[validate] manifest-schema.toml")
    print("[validate] SE_MANIFEST.toml")

    if require_tag:
        errors.extend(validate_tag(manifest))

    errors.extend(validate_schema_internal(cast(ManifestSchemaData, schema)))
    errors.extend(validate_manifest(manifest, cast(ManifestSchemaData, schema)))

    ref_result = run_ref_validate(strict=strict)

    for e in errors:
        print(f"ERROR: {e}")
    for w in warnings:
        print(f"WARNING: {w}")

    if errors:
        return 1
    if strict and warnings:
        return 1
    if ref_result != 0:
        return ref_result

    print("Repository validation passed.")
    return 0
