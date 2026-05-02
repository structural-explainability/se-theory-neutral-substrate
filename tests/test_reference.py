"""tests/test_reference.py - Tests for reference.py."""

from pathlib import Path

import pytest

from se_theory_neutral_substrate.reference import (
    LeanDecl,
    _ArtifactResult,
    _extract_decls,
    _extract_for_section,
    _find_repo_root,
    _infer_core_module,
    _kind_to_section,
    _make_stub,
    _merge,
    _module_to_path,
    _section_entries,
    _source_modules_in_registry,
    _toml_val,
    _write_registry_toml,
    run_ref_validate,
    run_scaffold,
)

# ---------------------------------------------------------------------------
# _toml_val
# ---------------------------------------------------------------------------


def test_toml_val_string() -> None:
    assert _toml_val("hello") == '"hello"'


def test_toml_val_string_escapes_quotes() -> None:
    assert _toml_val('say "hi"') == '"say \\"hi\\""'


def test_toml_val_string_escapes_backslash() -> None:
    assert _toml_val("a\\b") == '"a\\\\b"'


def test_toml_val_bool_true() -> None:
    assert _toml_val(True) == "true"


def test_toml_val_bool_false() -> None:
    assert _toml_val(False) == "false"


def test_toml_val_int() -> None:
    assert _toml_val(42) == "42"


# ---------------------------------------------------------------------------
# _infer_core_module
# ---------------------------------------------------------------------------


def test_infer_core_module_replaces_surface() -> None:
    assert _infer_core_module("NeutralSubstrate.Surface") == "NeutralSubstrate.Core"


def test_infer_core_module_no_surface_unchanged() -> None:
    assert _infer_core_module("NeutralSubstrate.Core") == "NeutralSubstrate.Core"


# ---------------------------------------------------------------------------
# _kind_to_section
# ---------------------------------------------------------------------------


def test_kind_to_section_type() -> None:
    assert _kind_to_section("substrate-type-registry") == "type"


def test_kind_to_section_predicate() -> None:
    assert _kind_to_section("substrate-predicate-registry") == "predicate"


def test_kind_to_section_theorem() -> None:
    assert _kind_to_section("se-theorem-registry") == "theorem"


def test_kind_to_section_axiom() -> None:
    assert _kind_to_section("substrate-axiom-registry") == "axiom"


def test_kind_to_section_dependency() -> None:
    assert _kind_to_section("dependency-registry") == "dependency"


def test_kind_to_section_traceability() -> None:
    assert _kind_to_section("traceability-registry") == "traceability"


# ---------------------------------------------------------------------------
# _module_to_path
# ---------------------------------------------------------------------------


def test_module_to_path(tmp_path: Path) -> None:
    result = _module_to_path("NeutralSubstrate.Core", tmp_path)
    assert result == tmp_path / "NeutralSubstrate" / "Core.lean"


def test_module_to_path_single_segment(tmp_path: Path) -> None:
    result = _module_to_path("Core", tmp_path)
    assert result == tmp_path / "Core.lean"


def test_module_to_path_three_segments(tmp_path: Path) -> None:
    result = _module_to_path("SE.Neutral.Core", tmp_path)
    assert result == tmp_path / "SE" / "Neutral" / "Core.lean"


# ---------------------------------------------------------------------------
# _extract_decls
# ---------------------------------------------------------------------------


def test_extract_decls_empty_file(tmp_path: Path) -> None:
    f = tmp_path / "Empty.lean"
    f.write_text("-- nothing here\n", encoding="utf-8")
    assert _extract_decls(f) == []


def test_extract_decls_missing_file(tmp_path: Path) -> None:
    assert _extract_decls(tmp_path / "Missing.lean") == []


def test_extract_decls_theorem(tmp_path: Path) -> None:
    f = tmp_path / "T.lean"
    f.write_text("theorem my_thm : True := trivial\n", encoding="utf-8")
    decls = _extract_decls(f)
    assert any(d.name == "my_thm" and d.kind == "theorem" for d in decls)


def test_extract_decls_lemma_maps_to_theorem_section(tmp_path: Path) -> None:
    f = tmp_path / "T.lean"
    f.write_text("lemma my_lemma : True := trivial\n", encoding="utf-8")
    decls = _extract_decls(f)
    assert any(d.name == "my_lemma" and d.section == "theorem" for d in decls)


def test_extract_decls_inductive_maps_to_type(tmp_path: Path) -> None:
    f = tmp_path / "T.lean"
    f.write_text("inductive MyType where\n  | mk\n", encoding="utf-8")
    decls = _extract_decls(f)
    assert any(d.name == "MyType" and d.section == "type" for d in decls)


def test_extract_decls_def_maps_to_predicate(tmp_path: Path) -> None:
    f = tmp_path / "T.lean"
    f.write_text("def myPred (x : Nat) : Bool := true\n", encoding="utf-8")
    decls = _extract_decls(f)
    assert any(d.name == "myPred" and d.section == "predicate" for d in decls)


def test_extract_decls_abbrev_maps_to_predicate(tmp_path: Path) -> None:
    f = tmp_path / "T.lean"
    f.write_text("abbrev MyAlias := List Nat\n", encoding="utf-8")
    decls = _extract_decls(f)
    assert any(d.name == "MyAlias" and d.kind == "abbrev" for d in decls)


def test_extract_decls_axiom(tmp_path: Path) -> None:
    f = tmp_path / "T.lean"
    f.write_text("axiom my_axiom : True\n", encoding="utf-8")
    decls = _extract_decls(f)
    assert any(d.name == "my_axiom" and d.section == "axiom" for d in decls)


def test_extract_decls_noncomputable_def(tmp_path: Path) -> None:
    f = tmp_path / "T.lean"
    f.write_text("noncomputable def myDef : Nat := 0\n", encoding="utf-8")
    decls = _extract_decls(f)
    assert any(d.name == "myDef" for d in decls)


def test_extract_decls_multiple(tmp_path: Path) -> None:
    f = tmp_path / "T.lean"
    f.write_text(
        "inductive A where\ndef b : Bool := true\ntheorem c : True := trivial\n",
        encoding="utf-8",
    )
    names = {d.name for d in _extract_decls(f)}
    assert names == {"A", "b", "c"}


# ---------------------------------------------------------------------------
# _extract_for_section
# ---------------------------------------------------------------------------


def test_extract_for_section_type_only(tmp_path: Path) -> None:
    f = tmp_path / "T.lean"
    f.write_text(
        "inductive MyType where\ndef myPred : Bool := true\n", encoding="utf-8"
    )
    decls = _extract_for_section(f, "type")
    assert all(d.section == "type" for d in decls)
    assert any(d.name == "MyType" for d in decls)
    assert not any(d.name == "myPred" for d in decls)


def test_extract_for_section_unknown_returns_empty(tmp_path: Path) -> None:
    f = tmp_path / "T.lean"
    f.write_text(
        "def x : Bool := true\ntheorem y : True := trivial\n", encoding="utf-8"
    )
    assert _extract_for_section(f, "dependency") == []
    assert _extract_for_section(f, "traceability") == []
    assert _extract_for_section(f, "unknown") == []


# ---------------------------------------------------------------------------
# _section_entries
# ---------------------------------------------------------------------------


def test_section_entries_returns_dict_entries() -> None:
    data = {"type": {"A": {"id": "A"}, "B": {"id": "B"}}, "schema": "x"}
    result = _section_entries(data, "type")
    assert set(result.keys()) == {"A", "B"}


def test_section_entries_missing_section() -> None:
    assert _section_entries({}, "type") == {}


def test_section_entries_skips_non_dict_values() -> None:
    data = {"type": {"A": {"id": "A"}, "B": "not-a-dict"}}
    result = _section_entries(data, "type")
    assert "B" not in result


# ---------------------------------------------------------------------------
# _source_modules_in_registry
# ---------------------------------------------------------------------------


def test_source_modules_in_registry_collects_unique() -> None:
    data = {
        "type": {
            "A": {"lean_symbol": "A", "source_module": "Core"},
            "B": {"lean_symbol": "B", "source_module": "Core"},
        },
        "predicate": {
            "C": {"lean_symbol": "C", "source_module": "Other"},
        },
    }
    result = _source_modules_in_registry(data)
    assert set(result) == {"Core", "Other"}


def test_source_modules_in_registry_skips_empty() -> None:
    data = {"type": {"A": {"lean_symbol": "A", "source_module": ""}}}
    assert _source_modules_in_registry(data) == []


# ---------------------------------------------------------------------------
# _make_stub
# ---------------------------------------------------------------------------


def test_make_stub_theorem_has_status() -> None:
    decl = LeanDecl(name="my_thm", kind="theorem", section="theorem")
    stub = _make_stub(decl, "Core")
    assert stub["status"] == "pending"
    assert stub["lean_symbol"] == "my_thm"
    assert stub["source_module"] == "Core"


def test_make_stub_predicate_no_status() -> None:
    decl = LeanDecl(name="myPred", kind="def", section="predicate")
    stub = _make_stub(decl, "Core")
    assert "status" not in stub


def test_make_stub_fields_complete() -> None:
    decl = LeanDecl(name="X", kind="inductive", section="type")
    stub = _make_stub(decl, "MyModule")
    assert all(
        k in stub
        for k in (
            "id",
            "cite_id",
            "name",
            "lean_symbol",
            "source_module",
            "description",
        )
    )


# ---------------------------------------------------------------------------
# _merge
# ---------------------------------------------------------------------------


def test_merge_preserves_existing_description() -> None:
    existing = {"id": "X", "description": "existing desc", "lean_symbol": "X"}
    stub = {"id": "X", "description": "", "lean_symbol": "X", "name": ""}
    result = _merge(existing, stub, overwrite=False)
    assert result["description"] == "existing desc"


def test_merge_adds_missing_fields() -> None:
    existing = {"id": "X", "lean_symbol": "X"}
    stub = {"id": "X", "lean_symbol": "X", "source_module": "Core"}
    result = _merge(existing, stub, overwrite=False)
    assert result["source_module"] == "Core"


def test_merge_overwrites_when_flag_set() -> None:
    existing = {"id": "X", "description": "old", "lean_symbol": "X"}
    stub = {"id": "X", "description": "new", "lean_symbol": "X"}
    result = _merge(existing, stub, overwrite=True)
    assert result["description"] == "new"


def test_merge_fills_placeholder_description() -> None:
    existing = {"id": "X", "description": "", "lean_symbol": "X"}
    stub = {"id": "X", "description": "", "lean_symbol": "X"}
    result = _merge(existing, stub, overwrite=False)
    assert result["description"] == ""


# ---------------------------------------------------------------------------
# _write_registry_toml
# ---------------------------------------------------------------------------


def test_write_registry_toml_roundtrip(tmp_path: Path) -> None:
    """Written TOML can be parsed back with correct values."""
    try:
        import tomllib
    except ImportError:
        import tomli as tomllib  # type: ignore[no-redef]

    path = tmp_path / "out.toml"
    data = {
        "schema": "test-1",
        "repo": "my-repo",
        "type": {
            "A": {"id": "A", "lean_symbol": "A", "description": "desc A"},
        },
    }
    _write_registry_toml(path, data)
    parsed = tomllib.loads(path.read_text(encoding="utf-8"))
    assert parsed["schema"] == "test-1"
    assert parsed["type"]["A"]["lean_symbol"] == "A"


def test_write_registry_toml_header_keys_first(tmp_path: Path) -> None:
    path = tmp_path / "out.toml"
    data = {"schema": "s", "repo": "r", "type": {"A": {"id": "A"}}}
    _write_registry_toml(path, data)
    lines = path.read_text(encoding="utf-8").splitlines()
    assert lines[0].startswith("schema")
    assert lines[1].startswith("repo")


# ---------------------------------------------------------------------------
# _ArtifactResult
# ---------------------------------------------------------------------------


def test_artifact_result_defaults_ok() -> None:
    r = _ArtifactResult(artifact_id="test")
    assert r.ok is True
    assert r.messages == []
    assert r.added == 0
    assert r.orphaned == 0


def test_artifact_result_fail_sets_ok_false() -> None:
    r = _ArtifactResult(artifact_id="test")
    r.fail("something broke")
    assert r.ok is False
    assert any("FAIL" in m for m in r.messages)


def test_artifact_result_warn_preserves_ok() -> None:
    r = _ArtifactResult(artifact_id="test")
    r.warn("just a warning")
    assert r.ok is True
    assert any("warn" in m for m in r.messages)


# ---------------------------------------------------------------------------
# _find_repo_root
# ---------------------------------------------------------------------------


def test_find_repo_root_returns_path() -> None:
    result = _find_repo_root()
    assert isinstance(result, Path)
    assert (result / "pyproject.toml").exists()


# ---------------------------------------------------------------------------
# run_scaffold — integration against real repo
# ---------------------------------------------------------------------------


def test_run_scaffold_dry_run_returns_0() -> None:
    """run_scaffold --dry-run succeeds against the real repo."""
    assert run_scaffold(dry_run=True, overwrite=False) == 0


def test_run_scaffold_dry_run_writes_nothing(tmp_path: Path) -> None:
    """run_scaffold --dry-run does not create any new files."""
    root = _find_repo_root()
    ref_dir = root / "reference"
    before = set(ref_dir.iterdir()) if ref_dir.exists() else set()
    run_scaffold(dry_run=True)
    after = set(ref_dir.iterdir()) if ref_dir.exists() else set()
    assert before == after


# ---------------------------------------------------------------------------
# run_ref_validate — integration against real repo
# ---------------------------------------------------------------------------


def test_run_ref_validate_returns_0() -> None:
    """run_ref_validate succeeds against the real repo."""
    assert run_ref_validate(strict=False) == 0


def test_run_ref_validate_strict_no_hard_failures() -> None:
    """run_ref_validate --strict returns 0 when no hard failures exist."""
    result = run_ref_validate(strict=True)
    assert result == 0


# ---------------------------------------------------------------------------
# run_scaffold — behaviour with a synthetic repo
# ---------------------------------------------------------------------------


def _make_synthetic_repo(tmp_path: Path, lean_content: str, toml_content: str) -> Path:
    (tmp_path / "pyproject.toml").write_text(
        '[project]\nname = "test"\n', encoding="utf-8"
    )
    ref = tmp_path / "reference"
    ref.mkdir()

    lean_dir = tmp_path / "MyLib"
    lean_dir.mkdir()
    (lean_dir / "Core.lean").write_text(lean_content, encoding="utf-8")

    (ref / "index.toml").write_text(
        'schema = "se-reference-index-1"\n'
        'repo = "test"\n'
        'surface_module = "MyLib.Surface"\n\n'
        '[[artifact]]\n'
        'id = "my-types"\n'
        'path = "reference/my-types.toml"\n'
        'kind = "my-type-registry"\n'
        'format = "toml"\n'
        'generated = false\n'
        'required = true\n'
        'source_module = "MyLib.Core"\n',
        encoding="utf-8",
    )
    if toml_content:
        (ref / "my-types.toml").write_text(toml_content, encoding="utf-8")

    return tmp_path


def test_run_scaffold_adds_stub_for_new_symbol(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    """run_scaffold adds a stub entry for a symbol present in Lean but not in the registry."""
    try:
        import tomllib
    except ImportError:
        import tomli as tomllib  # type: ignore[no-redef]

    lean = "inductive NewType where\n  | mk\n"
    existing_toml = 'schema = "se-my-type-registry-1"\nrepo = "test"\nsurface_module = "MyLib.Surface"\n'
    repo = _make_synthetic_repo(tmp_path, lean, existing_toml)
    monkeypatch.setattr(
        "se_theory_neutral_substrate.reference._find_repo_root", lambda: repo
    )

    result = run_scaffold(dry_run=False, overwrite=False)
    assert result == 0

    written = tomllib.loads(
        (repo / "reference" / "my-types.toml").read_text(encoding="utf-8")
    )
    assert "NewType" in written.get("type", {})


def test_run_scaffold_preserves_existing_description(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    """run_scaffold does not overwrite an existing description."""
    lean = "inductive ExistingType where\n  | mk\n"
    existing_toml = (
        'schema = "se-my-type-registry-1"\nrepo = "test"\nsurface_module = "MyLib.Surface"\n\n'
        '[type.ExistingType]\nid = "ExistingType"\ncite_id = "MY.TYPE.ExistingType"\n'
        'name = "Existing"\nlean_symbol = "ExistingType"\nsource_module = "MyLib.Core"\n'
        'description = "kept description"\n'
    )
    repo = _make_synthetic_repo(tmp_path, lean, existing_toml)
    monkeypatch.setattr(
        "se_theory_neutral_substrate.reference._find_repo_root", lambda: repo
    )

    run_scaffold(dry_run=False, overwrite=False)

    try:
        import tomllib
    except ImportError:
        import tomli as tomllib  # type: ignore[no-redef]

    written = tomllib.loads(
        (repo / "reference" / "my-types.toml").read_text(encoding="utf-8")
    )
    assert written["type"]["ExistingType"]["description"] == "kept description"


def test_run_scaffold_overwrite_replaces_description(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    """run_scaffold --overwrite replaces an existing description."""
    lean = "inductive ExistingType where\n  | mk\n"
    existing_toml = (
        'schema = "se-my-type-registry-1"\nrepo = "test"\nsurface_module = "MyLib.Surface"\n\n'
        '[type.ExistingType]\nid = "ExistingType"\ncite_id = ""\nname = ""\n'
        'lean_symbol = "ExistingType"\nsource_module = "MyLib.Core"\n'
        'description = "old description"\n'
    )
    repo = _make_synthetic_repo(tmp_path, lean, existing_toml)
    monkeypatch.setattr(
        "se_theory_neutral_substrate.reference._find_repo_root", lambda: repo
    )

    run_scaffold(dry_run=False, overwrite=True)

    try:
        import tomllib
    except ImportError:
        import tomli as tomllib  # type: ignore[no-redef]

    written = tomllib.loads(
        (repo / "reference" / "my-types.toml").read_text(encoding="utf-8")
    )
    # overwrite replaces with placeholder (empty string) from stub
    assert written["type"]["ExistingType"]["description"] == ""


def test_run_scaffold_missing_index_returns_1(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    """run_scaffold returns 1 when reference/index.toml does not exist."""
    (tmp_path / "pyproject.toml").touch()
    monkeypatch.setattr(
        "se_theory_neutral_substrate.reference._find_repo_root", lambda: tmp_path
    )
    assert run_scaffold() == 1


def test_run_ref_validate_missing_index_returns_1(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    """run_ref_validate returns 1 when reference/index.toml does not exist."""
    (tmp_path / "pyproject.toml").touch()
    monkeypatch.setattr(
        "se_theory_neutral_substrate.reference._find_repo_root", lambda: tmp_path
    )
    assert run_ref_validate() == 1
