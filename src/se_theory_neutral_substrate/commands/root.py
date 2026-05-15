"""Combined command dispatcher for se-theory-persistence."""

import argparse

from se_theory_neutral_substrate.commands.manifest import (
    sync_main,
)
from se_theory_neutral_substrate.commands.validate import validate_main


def build_parser() -> argparse.ArgumentParser:
    """Build the argument parser."""
    parser = argparse.ArgumentParser(
        prog="se-theory-persistence",
        description="Manifest and reference tooling for se-theory-persistence.",
    )
    subparsers = parser.add_subparsers(dest="command")

    subparsers.add_parser(
        "validate",
        help="Run repository validation.",
    )

    subparsers.add_parser(
        "sync",
        help="Sync pyproject.toml fallback-version from CITATION.cff version.",
    )

    ref_scaffold_parser = subparsers.add_parser(
        "ref-scaffold",
        help="Scaffold reference/ artifacts from Lean 4 source.",
    )
    ref_scaffold_parser.add_argument("--dry-run", action="store_true")
    ref_scaffold_parser.add_argument("--overwrite", action="store_true")

    ref_validate_parser = subparsers.add_parser(
        "ref-validate",
        help="Validate reference/ artifacts against Lean 4 source.",
    )
    ref_validate_parser.add_argument("--strict", action="store_true")

    ref_export_parser = subparsers.add_parser(
        "ref-export",
        help="Export generated data artifacts from reference/ artifacts.",
    )
    ref_export_parser.add_argument("--check", action="store_true")

    return parser


def main(argv: list[str] | None = None) -> int:
    """Run the combined command-line interface."""
    parser = build_parser()
    args = parser.parse_args(argv)

    try:
        if args.command == "validate":
            return validate_main()

        if args.command == "sync":
            return sync_main()

        if args.command == "ref-scaffold":
            from se_theory_neutral_substrate.reference import run_scaffold

            return run_scaffold(
                dry_run=args.dry_run,
                overwrite=args.overwrite,
            )

        if args.command == "ref-validate":
            from se_theory_neutral_substrate.reference import run_ref_validate

            return run_ref_validate(strict=args.strict)

        if args.command == "ref-export":
            from se_theory_neutral_substrate.export import run_ref_export

            return run_ref_export(check=args.check)

    except (ValueError, FileNotFoundError, RuntimeError) as e:
        print(f"Error: {e}")
        return 1

    parser.print_help()
    return 2
