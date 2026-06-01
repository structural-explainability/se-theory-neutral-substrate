"""paths.py - General repository path helpers.

Owns:
  - repo_root()              - find the repository root
  - reference_dir()          - path to reference/
  - reference_index_path()   - path to reference/index.toml
  - resolve_repo_path()      - resolve repo-relative paths safely

Does not own:
  - Lean module path resolution
  - reference artifact path policy
  - file loading
  - validation logic
  - CLI argument parsing

Reference-tool-specific helpers live in reference_tool/paths.py.
"""

from pathlib import Path

from se_theory_neutral_substrate.reference_tool.config import (
    REFERENCE_DIR_NAME,
    REFERENCE_INDEX_NAME,
)


def repo_root(start: Path | None = None) -> Path:
    """Find and return the repository root.

    Args:
        start: Optional starting path. Defaults to this file's location.

    Returns:
        Absolute path to the repository root.

    Raises:
        FileNotFoundError: If no repository root marker is found.
    """
    current = (start or Path(__file__)).resolve()

    if current.is_file():
        current = current.parent

    markers = ("pyproject.toml", "SE_MANIFEST.toml", ".git")

    for candidate in (current, *current.parents):
        if any((candidate / marker).exists() for marker in markers):
            return candidate

    raise FileNotFoundError(
        f"Could not find repository root from: {current}. "
        "Expected pyproject.toml, SE_MANIFEST.toml, or .git."
    )


def resolve_repo_path(path: str | Path, root: Path | None = None) -> Path:
    """Resolve a repository-relative path safely.

    Args:
        path: Repository-relative path.
        root: Optional repository root. Defaults to repo_root().

    Returns:
        Absolute resolved path.

    Raises:
        ValueError: If path is absolute or resolves outside the repository root.
    """
    repo = (root or repo_root()).resolve()
    relative_path = Path(path)

    if relative_path.is_absolute():
        raise ValueError(
            f"Expected repo-relative path, got absolute path: {relative_path}"
        )

    resolved = (repo / relative_path).resolve()

    try:
        resolved.relative_to(repo)
    except ValueError as exc:
        raise ValueError(f"Path escapes repository root: {relative_path}") from exc

    return resolved


def reference_dir(root: Path | None = None) -> Path:
    """Return the path to reference/."""
    return resolve_repo_path(REFERENCE_DIR_NAME, root=root)


def reference_index_path(root: Path | None = None) -> Path:
    """Return the path to reference/index.toml."""
    return reference_dir(root) / REFERENCE_INDEX_NAME
