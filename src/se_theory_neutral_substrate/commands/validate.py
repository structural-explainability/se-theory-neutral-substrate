"""Repository validation command entry point."""

from se_manifest_schema.sync import sync_all

from se_theory_neutral_substrate.reference import run_ref_validate


def validate_main() -> int:
    """Run full repository validation."""
    sync_all()

    ref_result = run_ref_validate(strict=True)
    if ref_result != 0:
        return ref_result

    print("Repository validation passed.")
    return 0
