"""reference_tool/stubs.py - Stub generation and merge behavior for reference registries."""

from typing import Any

from se_theory_neutral_substrate.reference_tool.lean import LeanDecl

PLACEHOLDER = ""
HUMAN_FIELDS = {"description", "name", "cite_id"}
REQUIRED_BASE_FIELDS = {"id", "cite_id", "lean_symbol", "source_module", "description"}
REQUIRED_STATUS_SECTIONS = {"theorem"}


def make_stub(decl: LeanDecl, source_module: str) -> dict[str, Any]:
    """Create a registry stub for a Lean declaration."""
    entry: dict[str, Any] = {
        "id": decl.name,
        "cite_id": PLACEHOLDER,
        "name": PLACEHOLDER,
        "lean_symbol": decl.name,
        "source_module": source_module,
        "description": PLACEHOLDER,
    }

    if decl.section in REQUIRED_STATUS_SECTIONS:
        entry["status"] = "pending"

    return entry


def merge_entry(
    existing: dict[str, Any],
    stub: dict[str, Any],
    overwrite: bool,
) -> dict[str, Any]:
    """Merge generated stub fields into an existing registry entry.

    Human-authored fields are preserved unless overwrite is true or the
    existing value is still the placeholder.
    """
    result: dict[str, Any] = dict(existing)

    for key, value in stub.items():
        if (
            key not in existing
            or overwrite
            or key in HUMAN_FIELDS
            and existing[key] == PLACEHOLDER
        ):
            result[key] = value

    return result
