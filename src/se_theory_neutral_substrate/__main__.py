"""Module entry point for se-theory-neutral-substrate.

Enables `uv run python -m se_theory_neutral_substrate`.
Delegates immediately to the CLI entry point.
All logic lives in cli.py, validate.py, sync.py, and load.py.
"""

from se_theory_neutral_substrate.cli import main

if __name__ == "__main__":
    raise SystemExit(main())
