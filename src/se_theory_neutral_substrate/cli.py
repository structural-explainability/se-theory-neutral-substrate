"""cli.py - Command-line interface for se-manifest-schema.

Parses arguments and dispatches to orchestrate.py or sync.py.
Owns nothing except argument parsing and error handling.
All logic lives in orchestrate.py and sync.py.

Entry points:
  uv run se-manifest-validate
  uv run se-manifest-validate --strict
  uv run se-manifest-validate --require-tag

  uv run se-manifest-version-sync

  uv run se-ref-scaffold
  uv run se-ref-scaffold --dry-run
  uv run se-ref-scaffold --overwrite

  uv run se-ref-validate
  uv run se-ref-validate --strict

Call chain:
  __main__.py -> cli.main()
              -> orchestrate.run_validate()  (sync_all called internally)
              -> sync.sync_all()             (sync only, no validation)
              -> reference.run_scaffold()     (scaffold + validate reference/)
              -> reference.run_ref_validate() (validate reference/ only)
"""

import argparse
import sys

from se_manifest_schema.sync import sync_all

from se_theory_neutral_substrate.orchestrate import run_validate
from se_theory_neutral_substrate.reference import run_ref_validate, run_scaffold


def build_parser() -> argparse.ArgumentParser:
    """Build the argument parser."""
    parser = argparse.ArgumentParser(
        prog="se-theory-neutral-substrate",
        description="Manifest and reference tooling for se-theory-neutral-substrate.",
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

    # -- ref-scaffold -------------------------------------------------------------
    ref_scaffold_parser = subparsers.add_parser(
        "ref-scaffold",
        help=(
            "Scaffold reference/ artifacts from Lean 4 source. "
            "Adds stub entries for symbols not yet in the registry. "
            "Existing descriptions, names, and cite_ids are preserved."
        ),
    )
    ref_scaffold_parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Report what would change without writing any files.",
    )
    ref_scaffold_parser.add_argument(
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


def validate_main() -> int:
    """Validate the manifest schema and sync if needed. Returns 0 on success, 1 on error."""
    return main(["validate"] + sys.argv[1:])


def sync_main() -> int:
    """Sync the manifest schema. Returns 0 on success, 1 on error."""
    return main(["sync"] + sys.argv[1:])


def ref_scaffold_main() -> int:
    """Scaffold reference/ artifacts from Lean 4 source. Returns 0 on success, 1 on error."""
    return main(["ref-scaffold"] + sys.argv[1:])


def ref_validate_main() -> int:
    """Validate reference/ artifacts against Lean 4 source. Returns 0 on success, 1 on error."""
    return main(["ref-validate"] + sys.argv[1:])


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
        if args.command == "ref-scaffold":
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
