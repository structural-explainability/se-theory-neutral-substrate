"""reference_tool/paths.py - Reference-tool path helpers."""

from pathlib import Path

from se_theory_neutral_substrate.paths import (
    reference_dir,
    resolve_repo_path,
)
from se_theory_neutral_substrate.reference_tool.config import LEAN_PUBLIC_ROOT


def lean_module_to_path(module: str, root: Path | None = None) -> Path:
    """Resolve a Lean module name to its repository source path."""
    module_name = module.strip()

    if not module_name:
        raise ValueError("Lean module name must be nonempty.")

    if "/" in module_name or "\\" in module_name:
        raise ValueError(f"Expected Lean module name, got path-like value: {module}")

    parts = module_name.split(".")

    if any(not part for part in parts):
        raise ValueError(f"Malformed Lean module name: {module}")

    if module_name != LEAN_PUBLIC_ROOT and not module_name.startswith(
        f"{LEAN_PUBLIC_ROOT}."
    ):
        raise ValueError(
            f"Expected Lean module under {LEAN_PUBLIC_ROOT}, got: {module_name}"
        )

    relative_path = Path(*parts).with_suffix(".lean")
    return resolve_repo_path(relative_path, root=root)


def reference_artifact_path(path: str | Path, root: Path | None = None) -> Path:
    """Resolve a declared reference artifact path.

    The declared path must be repository-relative and under reference/.
    """
    resolved = resolve_repo_path(path, root=root)
    reference = reference_dir(root).resolve()

    try:
        resolved.relative_to(reference)
    except ValueError as exc:
        raise ValueError(
            f"Reference artifact path is not under reference/: {path}"
        ) from exc

    return resolved
