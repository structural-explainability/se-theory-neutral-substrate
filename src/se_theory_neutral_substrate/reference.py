"""Compatibility wrapper for reference registry tooling.

Public callers should continue to import run_scaffold and run_ref_validate from
this module. The implementation lives in reference_tool/.
"""

from se_theory_neutral_substrate.reference_tool.runner import (
    run_ref_validate,
    run_scaffold,
)

__all__ = [
    "run_ref_validate",
    "run_scaffold",
]
