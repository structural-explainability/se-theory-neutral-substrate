"""cli.py - Command-line interface for se-manifest-schema.

Parses arguments and dispatches to orchestrate.py or sync.py.
Owns nothing except argument parsing and error handling.
All logic lives in orchestrate.py and sync.py.

Entry points:
  uv run python -m se_theory_neutral_substrate validate
  uv run python -m se_theory_neutral_substrate validate --strict
  uv run python -m se_theory_neutral_substrate validate --require-tag
  uv run python -m se_theory_neutral_substrate sync
  uv run python -m se_theory_neutral_substrate scaffold
  uv run python -m se_theory_neutral_substrate scaffold --dry-run
  uv run python -m se_theory_neutral_substrate scaffold --overwrite
  uv run python -m se_theory_neutral_substrate ref-validate
  uv run python -m se_theory_neutral_substrate ref-validate --strict

Call chain:
  __main__.py -> cli.main()
              -> orchestrate.run_validate()  (sync_all called internally)
              -> sync.sync_all()             (sync only, no validation)
              -> reference.run_scaffold()     (scaffold + validate reference/)
              -> reference.run_ref_validate() (validate reference/ only)
"""

import argparse

from se_manifest_schema.sync import sync_all

from se_theory_neutral_substrate.orchestrate import run_validate
from se_theory_neutral_substrate.reference import run_ref_validate, run_scaffold


def build_parser() -> argparse.ArgumentParser:
    """Build the argument parser."""
    parser = argparse.ArgumentParser(
        prog="se-manifest-schema",
        description="Sync and validate the SE manifest schema.",
    )
    subparsers = parser.add_subparsers(dest="command")

    validate_parser = subparsers.add_parser(
        "validate",
        help="Sync and validate manifest-schema.toml and SE_MANIFEST.toml.",
    )
    validate_parser.add_argument(
        "--strict",
        action="store_true",
        help="Treat warnings as errors.",
    )
    validate_parser.add_argument(
        "--require-tag",
        action="store_true",
        help="Require CITATION.cff version to match current git tag.",
    )

    subparsers.add_parser(
        "sync",
        help="Sync pyproject.toml fallback-version from CITATION.cff version.",
    )

    # -- scaffold -------------------------------------------------------------
    scaffold_parser = subparsers.add_parser(
        "scaffold",
        help=(
            "Scaffold reference/ artifacts from Lean 4 source. "
            "Adds stub entries for symbols not yet in the registry. "
            "Existing descriptions, names, and cite_ids are preserved."
        ),
    )
    scaffold_parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Report what would change without writing any files.",
    )
    scaffold_parser.add_argument(
        "--overwrite",
        action="store_true",
        help="Overwrite existing descriptions, names, and cite_ids with re-derived values.",
    )

    # -- ref-validate ---------------------------------------------------------
    ref_validate_parser = subparsers.add_parser(
        "ref-validate",
        help=(
            "Validate reference/ artifacts against Lean 4 source. "
            "Reports orphaned symbols and missing entries. Writes nothing."
        ),
    )
    ref_validate_parser.add_argument(
        "--strict",
        action="store_true",
        help="Treat warnings (orphaned symbols, missing stubs) as errors.",
    )

    return parser


def main(argv: list[str] | None = None) -> int:
    """Run the command-line interface.

    Returns:
        0 on success, 1 on error, 2 if no command given.
    """
    parser = build_parser()
    args = parser.parse_args(argv)

    try:
        if args.command == "validate":
            return run_validate(
                strict=args.strict,
                require_tag=args.require_tag,
            )
        if args.command == "sync":
            sync_all()
            return 0
        if args.command == "scaffold":
            return run_scaffold(
                dry_run=args.dry_run,
                overwrite=args.overwrite,
            )
        if args.command == "ref-validate":
            return run_ref_validate(
                strict=args.strict,
            )

    except (ValueError, FileNotFoundError, RuntimeError) as e:
        print(f"Error: {e}")
        return 1

    parser.print_help()
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
