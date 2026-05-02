"""tests/test_paths.py - Tests for paths.py."""

from pathlib import Path

import pytest

from se_theory_neutral_substrate.paths import (
    reference_artifact_path,
    reference_dir,
    reference_index_path,
    repo_root,
    resolve_repo_path,
)

# ---------------------------------------------------------------------------
# repo_root
# ---------------------------------------------------------------------------


def test_repo_root_finds_pyproject(tmp_path: Path) -> None:
    """repo_root finds pyproject.toml walking up from a subdirectory."""
    (tmp_path / "pyproject.toml").touch()
    subdir = tmp_path / "src" / "pkg"
    subdir.mkdir(parents=True)
    assert repo_root(subdir) == tmp_path


def test_repo_root_finds_se_manifest(tmp_path: Path) -> None:
    """repo_root accepts SE_MANIFEST.toml as a root marker."""
    (tmp_path / "SE_MANIFEST.toml").touch()
    assert repo_root(tmp_path) == tmp_path


def test_repo_root_finds_git(tmp_path: Path) -> None:
    """repo_root accepts .git as a root marker."""
    (tmp_path / ".git").mkdir()
    assert repo_root(tmp_path) == tmp_path


def test_repo_root_prefers_nearest_marker(tmp_path: Path) -> None:
    """repo_root returns the nearest ancestor with a marker."""
    (tmp_path / "pyproject.toml").touch()
    inner = tmp_path / "sub"
    inner.mkdir()
    (inner / "pyproject.toml").touch()
    assert repo_root(inner) == inner


def test_repo_root_raises_when_not_found(tmp_path: Path) -> None:
    """repo_root raises FileNotFoundError when no marker exists anywhere."""
    empty = tmp_path / "a" / "b" / "c"
    empty.mkdir(parents=True)
    with pytest.raises(FileNotFoundError, match="Could not find repository root"):
        repo_root(empty)


def test_repo_root_accepts_file_path(tmp_path: Path) -> None:
    """repo_root accepts a file path and walks up from its parent."""
    (tmp_path / "pyproject.toml").touch()
    f = tmp_path / "some_file.py"
    f.touch()
    assert repo_root(f) == tmp_path


def test_repo_root_no_arg_returns_path(monkeypatch: pytest.MonkeyPatch) -> None:
    """repo_root() with no argument returns a valid Path."""
    result = repo_root()
    assert isinstance(result, Path)
    assert result.exists()


# ---------------------------------------------------------------------------
# reference_dir
# ---------------------------------------------------------------------------


def test_reference_dir_default(tmp_path: Path) -> None:
    """reference_dir returns <root>/reference."""
    assert reference_dir(tmp_path) == tmp_path / "reference"


def test_reference_dir_uses_repo_root_when_no_arg(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    """reference_dir calls repo_root() when root is not provided."""
    (tmp_path / "pyproject.toml").touch()
    monkeypatch.chdir(tmp_path)
    result = reference_dir()
    assert result == repo_root() / "reference"


# ---------------------------------------------------------------------------
# reference_index_path
# ---------------------------------------------------------------------------


def test_reference_index_path(tmp_path: Path) -> None:
    """reference_index_path returns <root>/reference/index.toml."""
    assert reference_index_path(tmp_path) == tmp_path / "reference" / "index.toml"


# ---------------------------------------------------------------------------
# resolve_repo_path
# ---------------------------------------------------------------------------


def test_resolve_repo_path_simple(tmp_path: Path) -> None:
    """resolve_repo_path resolves a simple relative path under the repo."""
    result = resolve_repo_path("reference/index.toml", root=tmp_path)
    assert result == (tmp_path / "reference" / "index.toml").resolve()


def test_resolve_repo_path_rejects_absolute(tmp_path: Path) -> None:
    absolute = Path(tmp_path.anchor) / "absolute" / "path.toml"
    with pytest.raises(ValueError):
        resolve_repo_path(absolute, root=tmp_path)


def test_resolve_repo_path_rejects_escape(tmp_path: Path) -> None:
    """resolve_repo_path raises ValueError for paths escaping the repo root."""
    with pytest.raises(ValueError, match="escapes repository root"):
        resolve_repo_path("../../outside", root=tmp_path)


def test_resolve_repo_path_nested(tmp_path: Path) -> None:
    """resolve_repo_path handles nested relative paths."""
    result = resolve_repo_path("a/b/c.toml", root=tmp_path)
    assert result == (tmp_path / "a" / "b" / "c.toml").resolve()


# ---------------------------------------------------------------------------
# reference_artifact_path
# ---------------------------------------------------------------------------


def test_reference_artifact_path_valid(tmp_path: Path) -> None:
    """reference_artifact_path resolves a path under reference/."""
    result = reference_artifact_path("reference/substrate-types.toml", root=tmp_path)
    assert result == (tmp_path / "reference" / "substrate-types.toml").resolve()


def test_reference_artifact_path_rejects_outside_reference(tmp_path: Path) -> None:
    """reference_artifact_path raises ValueError for paths outside reference/."""
    with pytest.raises(ValueError, match="not under reference"):
        reference_artifact_path("other/file.toml", root=tmp_path)


def test_reference_artifact_path_rejects_absolute(tmp_path: Path) -> None:
    """reference_artifact_path raises ValueError for absolute paths."""
    with pytest.raises(ValueError):
        reference_artifact_path("/absolute/path.toml", root=tmp_path)
