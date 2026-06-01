"""tests/test_reference.py - Tests for reference tooling."""

from pathlib import Path

import pytest

from se_theory_neutral_substrate.load import load_toml
from se_theory_neutral_substrate.paths import repo_root
from se_theory_neutral_substrate.reference_tool.config import LEAN_PUBLIC_ROOT
from se_theory_neutral_substrate.reference_tool.lean import (
    SURFACE_AXIOMS,
    SURFACE_BY_KIND,
    SURFACE_PREDICATES,
    SURFACE_SYMBOLS,
    SURFACE_THEOREMS,
    SURFACE_TYPES,
    LeanDecl,
    expected_symbols_for_kind,
    extract_decls,
    extract_for_section,
    missing_expected_surface_symbols,
)
from se_theory_neutral_substrate.reference_tool.models import ArtifactResult
from se_theory_neutral_substrate.reference_tool.registry import (
    kind_to_section,
    module_to_path,
    section_entries,
    source_modules_in_registry,
    toml_value,
    write_registry_toml,
)
from se_theory_neutral_substrate.reference_tool.runner import (
    run_ref_validate,
    run_scaffold,
)
from se_theory_neutral_substrate.reference_tool.stubs import (
    HUMAN_FIELDS,
    REQUIRED_BASE_FIELDS,
    REQUIRED_STATUS_SECTIONS,
    make_stub,
    merge_entry,
)
from se_theory_neutral_substrate.reference_tool.validation import is_strict_warning

# ---------------------------------------------------------------------------
# config
# ---------------------------------------------------------------------------


def test_reference_tool_public_root() -> None:
    assert LEAN_PUBLIC_ROOT == "SE.NeutralSubstrate"


# ---------------------------------------------------------------------------
# ArtifactResult
# ---------------------------------------------------------------------------


def test_artifact_result() -> None:
    result = ArtifactResult(artifact_id="test")
    assert result.artifact_id == "test"
    assert result.ok is True
    assert result.messages == []


def test_artifact_result_defaults_ok() -> None:
    result = ArtifactResult(artifact_id="test")
    assert result.ok is True
    assert result.messages == []
    assert result.added == 0
    assert result.orphaned == 0


def test_artifact_result_fail_sets_ok_false() -> None:
    result = ArtifactResult(artifact_id="test")
    result.fail("something broke")
    assert result.ok is False
    assert any("FAIL" in message for message in result.messages)


def test_artifact_result_warn_preserves_ok() -> None:
    result = ArtifactResult(artifact_id="test")
    result.warn("just a warning")
    assert result.ok is True
    assert any("warn" in message for message in result.messages)


# ---------------------------------------------------------------------------
# toml_value
# ---------------------------------------------------------------------------


def test_toml_value_string() -> None:
    assert toml_value("hello") == '"hello"'


def test_toml_value_string_escapes_quotes() -> None:
    assert toml_value('say "hi"') == '"say \\"hi\\""'


def test_toml_value_string_escapes_backslash() -> None:
    assert toml_value("a\\b") == '"a\\\\b"'


def test_toml_value_bool_true() -> None:
    assert toml_value(True) == "true"


def test_toml_value_bool_false() -> None:
    assert toml_value(False) == "false"


def test_toml_value_int() -> None:
    assert toml_value(42) == "42"


# ---------------------------------------------------------------------------
# kind_to_section
# ---------------------------------------------------------------------------


def test_kind_to_section_type() -> None:
    assert kind_to_section("substrate-type-registry") == "type"


def test_kind_to_section_predicate() -> None:
    assert kind_to_section("substrate-predicate-registry") == "predicate"


def test_kind_to_section_theorem() -> None:
    assert kind_to_section("se-theorem-registry") == "theorem"


def test_kind_to_section_axiom() -> None:
    assert kind_to_section("substrate-axiom-registry") == "axiom"


def test_kind_to_section_dependency() -> None:
    assert kind_to_section("dependency-registry") == "dependency"


def test_kind_to_section_traceability() -> None:
    assert kind_to_section("traceability-registry") == "traceability"


# ---------------------------------------------------------------------------
# module_to_path
# ---------------------------------------------------------------------------


def test_module_to_path(tmp_path: Path) -> None:
    result = module_to_path("SE.NeutralSubstrate.Core", tmp_path)
    assert result == tmp_path / "SE" / "NeutralSubstrate" / "Core.lean"


def test_module_to_path_single_segment(tmp_path: Path) -> None:
    result = module_to_path("Core", tmp_path)
    assert result == tmp_path / "Core.lean"


def test_module_to_path_three_segments(tmp_path: Path) -> None:
    result = module_to_path("SE.Neutral.Core", tmp_path)
    assert result == tmp_path / "SE" / "Neutral" / "Core.lean"


# ---------------------------------------------------------------------------
# extract_decls
# ---------------------------------------------------------------------------


def test_extract_decls_empty_file(tmp_path: Path) -> None:
    path = tmp_path / "Empty.lean"
    path.write_text("-- nothing here\n", encoding="utf-8")
    assert extract_decls(path) == []


def test_extract_decls_missing_file(tmp_path: Path) -> None:
    assert extract_decls(tmp_path / "Missing.lean") == []


def test_extract_decls_theorem(tmp_path: Path) -> None:
    path = tmp_path / "T.lean"
    path.write_text("theorem my_thm : True := trivial\n", encoding="utf-8")
    decls = extract_decls(path)
    assert any(decl.name == "my_thm" and decl.kind == "theorem" for decl in decls)


def test_extract_decls_lemma_maps_to_theorem_section(tmp_path: Path) -> None:
    path = tmp_path / "T.lean"
    path.write_text("lemma my_lemma : True := trivial\n", encoding="utf-8")
    decls = extract_decls(path)
    assert any(decl.name == "my_lemma" and decl.section == "theorem" for decl in decls)


def test_extract_decls_inductive_maps_to_type(tmp_path: Path) -> None:
    path = tmp_path / "T.lean"
    path.write_text("inductive MyType where\n  | mk\n", encoding="utf-8")
    decls = extract_decls(path)
    assert any(decl.name == "MyType" and decl.section == "type" for decl in decls)


def test_extract_decls_def_maps_to_predicate(tmp_path: Path) -> None:
    path = tmp_path / "T.lean"
    path.write_text("def myPred (x : Nat) : Bool := true\n", encoding="utf-8")
    decls = extract_decls(path)
    assert any(decl.name == "myPred" and decl.section == "predicate" for decl in decls)


def test_extract_decls_abbrev_preserves_kind(tmp_path: Path) -> None:
    path = tmp_path / "T.lean"
    path.write_text("abbrev MyAlias := List Nat\n", encoding="utf-8")
    decls = extract_decls(path)
    assert any(decl.name == "MyAlias" and decl.kind == "abbrev" for decl in decls)


def test_extract_decls_axiom(tmp_path: Path) -> None:
    path = tmp_path / "T.lean"
    path.write_text("axiom my_axiom : True\n", encoding="utf-8")
    decls = extract_decls(path)
    assert any(decl.name == "my_axiom" and decl.section == "axiom" for decl in decls)


def test_extract_decls_noncomputable_def(tmp_path: Path) -> None:
    path = tmp_path / "T.lean"
    path.write_text("noncomputable def myDef : Nat := 0\n", encoding="utf-8")
    decls = extract_decls(path)
    assert any(decl.name == "myDef" for decl in decls)


def test_extract_decls_multiple(tmp_path: Path) -> None:
    path = tmp_path / "T.lean"
    path.write_text(
        "inductive A where\ndef b : Bool := true\ntheorem c : True := trivial\n",
        encoding="utf-8",
    )
    names = {decl.name for decl in extract_decls(path)}
    assert names == {"A", "b", "c"}


# ---------------------------------------------------------------------------
# extract_for_section
# ---------------------------------------------------------------------------


def test_extract_for_section_type_only(tmp_path: Path) -> None:
    path = tmp_path / "T.lean"
    path.write_text(
        "inductive MyType where\ndef myPred : Bool := true\n",
        encoding="utf-8",
    )
    decls = extract_for_section(path, "type")
    assert all(decl.section == "type" for decl in decls)
    assert any(decl.name == "MyType" for decl in decls)
    assert not any(decl.name == "myPred" for decl in decls)


def test_extract_for_section_unknown_returns_empty(tmp_path: Path) -> None:
    path = tmp_path / "T.lean"
    path.write_text(
        "def x : Bool := true\ntheorem y : True := trivial\n",
        encoding="utf-8",
    )
    assert extract_for_section(path, "dependency") == []
    assert extract_for_section(path, "traceability") == []
    assert extract_for_section(path, "unknown") == []


# ---------------------------------------------------------------------------
# section_entries
# ---------------------------------------------------------------------------


def test_section_entries_returns_dict_entries() -> None:
    data = {"type": {"A": {"id": "A"}, "B": {"id": "B"}}, "schema": "x"}
    result = section_entries(data, "type")
    assert set(result.keys()) == {"A", "B"}


def test_section_entries_missing_section() -> None:
    assert section_entries({}, "type") == {}


def test_section_entries_skips_non_dict_values() -> None:
    data = {"type": {"A": {"id": "A"}, "B": "not-a-dict"}}
    result = section_entries(data, "type")
    assert "B" not in result


# ---------------------------------------------------------------------------
# source_modules_in_registry
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
    result = source_modules_in_registry(data)
    assert set(result) == {"Core", "Other"}


def test_source_modules_in_registry_skips_empty() -> None:
    data = {"type": {"A": {"lean_symbol": "A", "source_module": ""}}}
    assert source_modules_in_registry(data) == []


# ---------------------------------------------------------------------------
# make_stub
# ---------------------------------------------------------------------------


def test_make_stub_theorem_has_status() -> None:
    decl = LeanDecl(name="my_thm", kind="theorem", section="theorem")
    stub = make_stub(decl, "Core")
    assert stub["status"] == "pending"
    assert stub["lean_symbol"] == "my_thm"
    assert stub["source_module"] == "Core"


def test_make_stub_predicate_no_status() -> None:
    decl = LeanDecl(name="myPred", kind="def", section="predicate")
    stub = make_stub(decl, "Core")
    assert "status" not in stub


def test_make_stub_fields_complete() -> None:
    decl = LeanDecl(name="X", kind="inductive", section="type")
    stub = make_stub(decl, "MyModule")
    assert all(
        key in stub
        for key in (
            "id",
            "cite_id",
            "name",
            "lean_symbol",
            "source_module",
            "description",
        )
    )


def test_stub_constants_are_stable() -> None:
    assert "description" in HUMAN_FIELDS
    assert "lean_symbol" in REQUIRED_BASE_FIELDS
    assert "theorem" in REQUIRED_STATUS_SECTIONS


# ---------------------------------------------------------------------------
# merge_entry
# ---------------------------------------------------------------------------


def test_merge_preserves_existing_description() -> None:
    existing = {"id": "X", "description": "existing desc", "lean_symbol": "X"}
    stub = {"id": "X", "description": "", "lean_symbol": "X", "name": ""}
    result = merge_entry(existing, stub, overwrite=False)
    assert result["description"] == "existing desc"


def test_merge_adds_missing_fields() -> None:
    existing = {"id": "X", "lean_symbol": "X"}
    stub = {"id": "X", "lean_symbol": "X", "source_module": "Core"}
    result = merge_entry(existing, stub, overwrite=False)
    assert result["source_module"] == "Core"


def test_merge_overwrites_when_flag_set() -> None:
    existing = {"id": "X", "description": "old", "lean_symbol": "X"}
    stub = {"id": "X", "description": "new", "lean_symbol": "X"}
    result = merge_entry(existing, stub, overwrite=True)
    assert result["description"] == "new"


def test_merge_fills_placeholder_description() -> None:
    existing = {"id": "X", "description": "", "lean_symbol": "X"}
    stub = {"id": "X", "description": "", "lean_symbol": "X"}
    result = merge_entry(existing, stub, overwrite=False)
    assert result["description"] == ""


# ---------------------------------------------------------------------------
# write_registry_toml
# ---------------------------------------------------------------------------


def test_write_registry_toml_roundtrip(tmp_path: Path) -> None:
    path = tmp_path / "out.toml"
    data = {
        "schema": "test-1",
        "repo": "my-repo",
        "type": {
            "A": {"id": "A", "lean_symbol": "A", "description": "desc A"},
        },
    }
    write_registry_toml(path, data)
    parsed = load_toml(path)
    assert parsed["schema"] == "test-1"
    assert parsed["type"]["A"]["lean_symbol"] == "A"


def test_write_registry_toml_header_keys_first(tmp_path: Path) -> None:
    path = tmp_path / "out.toml"
    data = {"schema": "s", "repo": "r", "type": {"A": {"id": "A"}}}
    write_registry_toml(path, data)
    lines = path.read_text(encoding="utf-8").splitlines()
    assert lines[0].startswith("schema")
    assert lines[1].startswith("repo")


# ---------------------------------------------------------------------------
# strict warning handling
# ---------------------------------------------------------------------------


def test_is_strict_warning_true_for_regular_warning() -> None:
    assert is_strict_warning("  warn  missing field 'cite_id'") is True


def test_is_strict_warning_false_for_kind_mismatch() -> None:
    assert is_strict_warning("  warn  kind mismatch - intentional refactor?") is False


def test_is_strict_warning_false_for_non_warning() -> None:
    assert is_strict_warning("      all lean_symbols match") is False


# ---------------------------------------------------------------------------
# repo root
# ---------------------------------------------------------------------------


def test_find_repo_root_returns_path() -> None:
    result = repo_root()
    assert isinstance(result, Path)
    assert (result / "pyproject.toml").exists()


# ---------------------------------------------------------------------------
# run_scaffold and run_ref_validate against real repo
# ---------------------------------------------------------------------------


def test_run_scaffold_dry_run_returns_0() -> None:
    assert run_scaffold(dry_run=True, overwrite=False) == 0


def test_run_scaffold_dry_run_writes_nothing() -> None:
    root = repo_root()
    ref_dir = root / "reference"
    before = set(ref_dir.iterdir()) if ref_dir.exists() else set()
    run_scaffold(dry_run=True)
    after = set(ref_dir.iterdir()) if ref_dir.exists() else set()
    assert before == after


def test_run_ref_validate_returns_0() -> None:
    assert run_ref_validate(strict=False) == 0


def test_run_ref_validate_strict_no_hard_failures() -> None:
    assert run_ref_validate(strict=True) == 0


# ---------------------------------------------------------------------------
# synthetic repo helpers
# ---------------------------------------------------------------------------


def _make_synthetic_repo(tmp_path: Path, lean_content: str, toml_content: str) -> Path:
    (tmp_path / "pyproject.toml").write_text(
        '[project]\nname = "test"\n',
        encoding="utf-8",
    )

    ref = tmp_path / "reference"
    ref.mkdir()

    lean_dir = tmp_path / "SE" / "NeutralSubstrate"
    lean_dir.mkdir(parents=True)
    (lean_dir / "Core.lean").write_text(lean_content, encoding="utf-8")
    (lean_dir / "Spec.lean").write_text("", encoding="utf-8")

    (ref / "index.toml").write_text(
        'schema = "se-reference-index-1"\n'
        'repo = "test"\n'
        'surface_module = "SE.NeutralSubstrate"\n\n'
        '[[artifact]]\n'
        'id = "my-types"\n'
        'path = "reference/my-types.toml"\n'
        'kind = "my-type-registry"\n'
        'format = "toml"\n'
        'generated = false\n'
        'required = true\n'
        'source_module = "SE.NeutralSubstrate.Core"\n',
        encoding="utf-8",
    )

    if toml_content:
        (ref / "my-types.toml").write_text(toml_content, encoding="utf-8")

    return tmp_path


def _patch_repo_root(monkeypatch: pytest.MonkeyPatch, repo: Path) -> None:
    monkeypatch.setattr(
        "se_theory_neutral_substrate.reference_tool.runner.repo_root",
        lambda: repo,
    )


# ---------------------------------------------------------------------------
# run_scaffold with a synthetic repo
# ---------------------------------------------------------------------------


def test_run_scaffold_adds_stub_for_new_symbol(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    lean = "inductive NewType where\n  | mk\n"
    existing_toml = (
        'schema = "se-my-type-registry-1"\n'
        'repo = "test"\n'
        'surface_module = "SE.NeutralSubstrate"\n'
    )
    repo = _make_synthetic_repo(tmp_path, lean, existing_toml)
    _patch_repo_root(monkeypatch, repo)

    result = run_scaffold(dry_run=False, overwrite=False)

    assert result == 0
    written = load_toml(repo / "reference" / "my-types.toml")
    assert "NewType" in written.get("type", {})


def test_run_scaffold_preserves_existing_description(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    lean = "inductive ExistingType where\n  | mk\n"
    existing_toml = (
        'schema = "se-my-type-registry-1"\n'
        'repo = "test"\n'
        'surface_module = "SE.NeutralSubstrate"\n\n'
        '[type.ExistingType]\n'
        'id = "ExistingType"\n'
        'cite_id = "MY.TYPE.ExistingType"\n'
        'name = "Existing"\n'
        'lean_symbol = "ExistingType"\n'
        'source_module = "SE.NeutralSubstrate.Core"\n'
        'description = "kept description"\n'
    )
    repo = _make_synthetic_repo(tmp_path, lean, existing_toml)
    _patch_repo_root(monkeypatch, repo)

    result = run_scaffold(dry_run=False, overwrite=False)

    assert result == 0
    written = load_toml(repo / "reference" / "my-types.toml")
    assert written["type"]["ExistingType"]["description"] == "kept description"


def test_run_scaffold_overwrite_replaces_description(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    lean = "inductive ExistingType where\n  | mk\n"
    existing_toml = (
        'schema = "se-my-type-registry-1"\n'
        'repo = "test"\n'
        'surface_module = "SE.NeutralSubstrate"\n\n'
        '[type.ExistingType]\n'
        'id = "ExistingType"\n'
        'cite_id = ""\n'
        'name = ""\n'
        'lean_symbol = "ExistingType"\n'
        'source_module = "SE.NeutralSubstrate.Core"\n'
        'description = "old description"\n'
    )
    repo = _make_synthetic_repo(tmp_path, lean, existing_toml)
    _patch_repo_root(monkeypatch, repo)

    result = run_scaffold(dry_run=False, overwrite=True)

    assert result == 0
    written = load_toml(repo / "reference" / "my-types.toml")
    assert written["type"]["ExistingType"]["description"] == ""


def test_run_scaffold_missing_index_returns_1(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    (tmp_path / "pyproject.toml").touch()
    _patch_repo_root(monkeypatch, tmp_path)

    assert run_scaffold() == 1


def test_run_ref_validate_missing_index_returns_1(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    (tmp_path / "pyproject.toml").touch()
    _patch_repo_root(monkeypatch, tmp_path)

    assert run_ref_validate() == 1


# ---------------------------------------------------------------------------
# Lean public surface expectations
# ---------------------------------------------------------------------------


def test_surface_symbols_are_union_of_surface_kinds() -> None:
    expected = (
        set(SURFACE_TYPES)
        | set(SURFACE_PREDICATES)
        | set(SURFACE_AXIOMS)
        | set(SURFACE_THEOREMS)
    )

    assert set(SURFACE_SYMBOLS) == expected


def test_surface_by_kind_matches_kind_constants() -> None:
    assert SURFACE_BY_KIND["type"] == SURFACE_TYPES
    assert SURFACE_BY_KIND["predicate"] == SURFACE_PREDICATES
    assert SURFACE_BY_KIND["axiom"] == SURFACE_AXIOMS
    assert SURFACE_BY_KIND["theorem"] == SURFACE_THEOREMS


def test_expected_symbols_for_kind_type() -> None:
    assert expected_symbols_for_kind("type") == SURFACE_TYPES


def test_expected_symbols_for_kind_predicate() -> None:
    assert expected_symbols_for_kind("predicate") == SURFACE_PREDICATES


def test_expected_symbols_for_kind_axiom() -> None:
    assert expected_symbols_for_kind("axiom") == SURFACE_AXIOMS


def test_expected_symbols_for_kind_theorem() -> None:
    assert expected_symbols_for_kind("theorem") == SURFACE_THEOREMS


def test_expected_symbols_for_kind_rejects_unknown_kind() -> None:
    with pytest.raises(ValueError, match="Unknown Lean surface kind"):
        expected_symbols_for_kind("not-a-kind")


def test_missing_expected_surface_symbols_returns_missing_symbols() -> None:
    registered = set(SURFACE_SYMBOLS) - {"Framework", "Neutral"}

    assert missing_expected_surface_symbols(registered) == {
        "Framework",
        "Neutral",
    }


def test_missing_expected_surface_symbols_empty_when_all_registered() -> None:
    assert missing_expected_surface_symbols(set(SURFACE_SYMBOLS)) == set()
