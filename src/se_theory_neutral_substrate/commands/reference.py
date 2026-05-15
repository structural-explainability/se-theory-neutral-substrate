"""Reference command entry points."""

import argparse
import sys

from se_theory_neutral_substrate.reference import run_ref_validate, run_scaffold


def ref_scaffold_main() -> int:
    """Scaffold reference/ artifacts from Lean 4 source."""
    parser = argparse.ArgumentParser(
        prog="se-ref-scaffold",
        description="Scaffold reference/ artifacts from Lean 4 source.",
    )
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--overwrite", action="store_true")
    args = parser.parse_args(sys.argv[1:])

    return run_scaffold(
        dry_run=args.dry_run,
        overwrite=args.overwrite,
    )


def ref_validate_main() -> int:
    """Validate reference/ artifacts against Lean 4 source."""
    parser = argparse.ArgumentParser(
        prog="se-ref-validate",
        description="Validate reference/ artifacts against Lean 4 source.",
    )
    parser.add_argument("--strict", action="store_true")
    args = parser.parse_args(sys.argv[1:])

    return run_ref_validate(strict=args.strict)


def ref_export_main() -> int:
    """Export generated data artifacts from reference/ artifacts."""
    parser = argparse.ArgumentParser(
        prog="se-ref-export",
        description="Export generated data artifacts from reference/ artifacts.",
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="Check whether generated artifacts are current without writing files.",
    )
    args = parser.parse_args(sys.argv[1:])

    from se_theory_neutral_substrate.export import run_ref_export

    return run_ref_export(check=args.check)
