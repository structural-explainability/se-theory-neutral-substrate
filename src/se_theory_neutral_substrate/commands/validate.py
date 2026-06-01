"""commands/validate.py - Repository validation command entry point."""

from se_theory_neutral_substrate.reference import run_ref_validate
from se_theory_neutral_substrate.reference_tool.export import run_ref_export


def validate_main() -> int:
    """Run full repository validation."""
    ref_result = run_ref_validate(strict=True)
    if ref_result != 0:
        return ref_result

    export_result = run_ref_export(check=True)
    if export_result != 0:
        return export_result

    print("Repository validation passed.")
    return 0
