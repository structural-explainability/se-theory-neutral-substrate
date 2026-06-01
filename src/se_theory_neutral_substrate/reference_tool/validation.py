"""reference_tool/validation.py - Validation helpers for reference registries."""

from typing import Any

from se_theory_neutral_substrate.reference_tool.config import STRICT_WARNING_EXEMPTIONS
from se_theory_neutral_substrate.reference_tool.models import ArtifactResult
from se_theory_neutral_substrate.reference_tool.registry import section_entries
from se_theory_neutral_substrate.reference_tool.stubs import (
    REQUIRED_BASE_FIELDS,
    REQUIRED_STATUS_SECTIONS,
)

RegistryData = dict[str, Any]


def validate_required_fields(
    data: RegistryData,
    section: str,
    result: ArtifactResult,
) -> None:
    """Warn when registry entries are missing required fields."""
    required = REQUIRED_BASE_FIELDS | (
        {"status"} if section in REQUIRED_STATUS_SECTIONS else set()
    )

    for entry_id, entry in section_entries(data, section).items():
        for field_name in sorted(required):
            if field_name not in entry:
                result.warn(f"missing field {field_name!r} on {section}.{entry_id}")


def validate_cite_ids_against_spec(
    data: RegistryData,
    section: str,
    spec_ids: set[str],
    result: ArtifactResult,
) -> None:
    """Warn when reference cite_id values are absent from Spec.lean."""
    if not spec_ids:
        result.warn("no Spec.lean citation IDs found")
        return

    for entry_id, entry in section_entries(data, section).items():
        cite_id = entry.get("cite_id")

        if not cite_id:
            continue

        if cite_id not in spec_ids:
            result.warn(
                f"cite_id not declared in Spec.lean on {section}.{entry_id}: "
                f"{cite_id!r}"
            )


def is_strict_warning(message: str) -> bool:
    """Return whether a warning should fail strict validation."""
    return "warn" in message and not any(
        exemption in message for exemption in STRICT_WARNING_EXEMPTIONS
    )
