"""reference.py - Scaffold and validate reference/ artifacts from Lean 4 source.

Reads reference/index.toml, walks each artifact, and either validates
existing entries against current Lean declarations or adds stub entries
for symbols not yet in the registry.

Existing human-authored fields (description, name, cite_id) are never
overwritten unless run_scaffold is called with overwrite=True.

Artifacts with generated=true or format=json are always skipped.
proof-registry.json is Lean-generated; this module does not touch it.

Entry points:
  run_scaffold(dry_run, overwrite) -> int
  run_ref_validate(strict)         -> int

Copy this file unchanged to each theory repo.  _find_repo_root() locates
the repo root via pyproject.toml, so the same source works in all three.
"""

from dataclasses import dataclass, field
from pathlib import Path
import re
import sys
from typing import Any

try:
    import tomllib
except ImportError:
    try:
        import tomli as tomllib  # type: ignore[no-redef]
    except ImportError:
        print("error: requires tomllib (Python 3.11+) or: pip install tomli")
        sys.exit(1)


# ---------------------------------------------------------------------------
# Repo root detection
# ---------------------------------------------------------------------------


def _find_repo_root() -> Path:
    """Walk up from this file until pyproject.toml is found."""
    for parent in Path(__file__).resolve().parents:
        if (parent / "pyproject.toml").exists():
            return parent
    raise FileNotFoundError(
        "Cannot locate repo root: no pyproject.toml found above "
        f"{Path(__file__).resolve()}"
    )


# ---------------------------------------------------------------------------
# Lean 4 declaration extraction
# ---------------------------------------------------------------------------

LEAN_DECL_TO_SECTION: dict[str, str] = {
    "inductive": "type",
    "structure": "type",
    "theorem": "theorem",
    "lemma": "theorem",
    "axiom": "axiom",
    "def": "predicate",
    "abbrev": "predicate",
}

_DECL_RE = re.compile(
    r"^(?:private\s+|protected\s+)?(?:noncomputable\s+)?"
    r"(theorem|lemma|def|abbrev|inductive|structure|axiom|class|instance)\s+(\w+)",
    re.MULTILINE,
)

_SECTION_LEAN_KINDS: dict[str, set[str]] = {
    "type": {"inductive", "structure"},
    "predicate": {"def", "abbrev"},
    "theorem": {"theorem", "lemma"},
    "axiom": {"axiom"},
    "witness": {"def", "abbrev"},
}


@dataclass
class LeanDecl:
    """Lean declaration with name, kind (inductive, theorem, etc), and section (type, theorem, etc)."""

    name: str
    kind: str
    section: str


def _extract_decls(lean_file: Path) -> list[LeanDecl]:
    if not lean_file.exists():
        return []
    text = lean_file.read_text(encoding="utf-8")
    return [
        LeanDecl(
            name=m.group(2),
            kind=m.group(1),
            section=LEAN_DECL_TO_SECTION.get(m.group(1), "unknown"),
        )
        for m in _DECL_RE.finditer(text)
    ]


def _extract_for_section(lean_file: Path, target_section: str) -> list[LeanDecl]:
    wanted = _SECTION_LEAN_KINDS.get(target_section)
    if wanted is None:
        return []  # non-Lean section (dependency, traceability, etc.): skip extraction
    return [d for d in _extract_decls(lean_file) if d.kind in wanted]


# ---------------------------------------------------------------------------
# Module path resolution
# ---------------------------------------------------------------------------


def _module_to_path(module: str, lean_root: Path) -> Path:
    parts = module.split(".")
    return lean_root.joinpath(*parts[:-1]) / f"{parts[-1]}.lean"


def _infer_core_module(surface_module: str) -> str:
    return surface_module.replace("Surface", "Core")


def _kind_to_section(artifact_kind: str) -> str:
    """'substrate-type-registry' -> 'type', 'se-theorem-registry' -> 'theorem'."""
    without_suffix = artifact_kind.removesuffix("-registry")
    return (
        without_suffix.rsplit("-", 1)[-1] if "-" in without_suffix else without_suffix
    )


# ---------------------------------------------------------------------------
# TOML helpers
# ---------------------------------------------------------------------------


def _load_toml(path: Path) -> dict[str, Any]:
    return tomllib.loads(path.read_text(encoding="utf-8"))


def _section_entries(data: dict, section: str) -> dict[str, dict]:
    return {k: v for k, v in data.get(section, {}).items() if isinstance(v, dict)}


def _source_modules_in_registry(data: dict) -> list[str]:
    seen: set[str] = set()
    result: list[str] = []
    for section_val in data.values():
        if not isinstance(section_val, dict):
            continue
        for entry in section_val.values():
            if isinstance(entry, dict):
                mod = entry.get("source_module", "")
                if mod and mod not in seen:
                    seen.add(mod)
                    result.append(mod)
    return result


# ---------------------------------------------------------------------------
# Minimal TOML writer (no external dependency)
# ---------------------------------------------------------------------------

_HEADER_KEYS = ["schema", "repo", "surface_module", "namespace"]


def _toml_val(v: Any) -> str:
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, str):
        return '"' + v.replace("\\", "\\\\").replace('"', '\\"') + '"'
    return str(v)


def _write_registry_toml(path: Path, data: dict) -> None:
    lines: list[str] = []
    for key in _HEADER_KEYS:
        if key in data and not isinstance(data[key], dict):
            lines.append(f"{key} = {_toml_val(data[key])}")
    lines.append("")
    for section_key, section_val in data.items():
        if section_key in _HEADER_KEYS or not isinstance(section_val, dict):
            continue
        for entry_id, entry in section_val.items():
            if not isinstance(entry, dict):
                continue
            lines.append(f"[{section_key}.{entry_id}]")
            for fk, fv in entry.items():
                lines.append(f"{fk} = {_toml_val(fv)}")
            lines.append("")
    path.write_text("\n".join(lines), encoding="utf-8")


# ---------------------------------------------------------------------------
# Stub generation and merge
# ---------------------------------------------------------------------------

_PLACEHOLDER = ""
_HUMAN_FIELDS = {"description", "name", "cite_id"}
_REQUIRED_BASE = {"id", "cite_id", "lean_symbol", "source_module", "description"}
_REQUIRED_STATUS = {"theorem"}  # axioms are postulated in Lean, not proved/pending


def _make_stub(decl: LeanDecl, source_module: str) -> dict[str, Any]:
    entry: dict[str, Any] = {
        "id": decl.name,
        "cite_id": _PLACEHOLDER,
        "name": _PLACEHOLDER,
        "lean_symbol": decl.name,
        "source_module": source_module,
        "description": _PLACEHOLDER,
    }
    if decl.section in _REQUIRED_STATUS:
        entry["status"] = "pending"
    return entry


def _merge(existing: dict, stub: dict, overwrite: bool) -> dict:
    result = dict(existing)
    for key, val in stub.items():
        if (
            key not in existing
            or overwrite
            or key in _HUMAN_FIELDS
            and existing[key] == _PLACEHOLDER
        ):
            result[key] = val
    return result


# ---------------------------------------------------------------------------
# Per-artifact processing
# ---------------------------------------------------------------------------


@dataclass
class _ArtifactResult:
    artifact_id: str
    ok: bool = True
    messages: list[str] = field(default_factory=list)
    wrote: bool = False
    added: int = 0
    orphaned: int = 0

    def _emit(self, prefix: str, msg: str) -> None:
        self.messages.append(f"  {prefix}  {msg}")

    def fail(self, msg: str) -> None:
        self.ok = False
        self._emit("FAIL", msg)

    def warn(self, msg: str) -> None:
        self._emit("warn", msg)

    def added_sym(self, msg: str) -> None:
        self._emit("+   ", msg)

    def note(self, msg: str) -> None:
        self._emit("    ", msg)


def _process_artifact(
    artifact: dict,
    repo_root: Path,
    lean_root: Path,
    index_surface_module: str,
    dry_run: bool,
    overwrite: bool,
) -> _ArtifactResult:

    art_id = artifact.get("id", "<unnamed>")
    rel_path = artifact.get("path", "")
    fmt = artifact.get("format", "toml")
    generated = artifact.get("generated", False)
    kind = artifact.get("kind", "")
    section = _kind_to_section(kind)
    result = _ArtifactResult(artifact_id=art_id)

    if generated or fmt != "toml":
        result.note("skipped (generated or non-toml)")
        return result

    art_path = repo_root / rel_path
    existing_data: dict = {}

    if art_path.exists():
        try:
            existing_data = _load_toml(art_path)
        except Exception as exc:
            result.fail(f"TOML parse error: {exc}")
            return result
    else:
        result.note("no existing file — will create")

    # Source module resolution
    source_modules: list[str] = []
    if "source_module" in artifact:
        source_modules = [artifact["source_module"]]
    if not source_modules and existing_data:
        source_modules = _source_modules_in_registry(existing_data)
    if not source_modules:
        surface = existing_data.get("surface_module", index_surface_module)
        derived = _infer_core_module(surface)
        source_modules = [derived]
        result.note(f"source module inferred: {derived}")

    # Scan Lean files
    all_decls: list[LeanDecl] = []
    for mod in source_modules:
        lean_file = _module_to_path(mod, lean_root)
        if not lean_file.exists():
            result.fail(f"lean file not found: {lean_file}")
            continue
        all_decls.extend(_extract_for_section(lean_file, section))

    if not result.ok:
        return result

    lean_by_name: dict[str, LeanDecl] = {d.name: d for d in all_decls}

    # All declared symbols regardless of kind — used to disambiguate orphans
    # from kind-mismatches (e.g. inductive refactored to abbrev).
    all_lean_by_name: dict[str, LeanDecl] = {}
    sym_to_mod: dict[str, str] = {}
    for mod in source_modules:
        for d in _extract_decls(_module_to_path(mod, lean_root)):
            all_lean_by_name.setdefault(d.name, d)
            sym_to_mod.setdefault(d.name, mod)
    existing_entries = _section_entries(existing_data, section)
    existing_symbols: set[str] = {
        e["lean_symbol"] for e in existing_entries.values() if "lean_symbol" in e
    }

    # Orphaned entries
    for sym in sorted(existing_symbols - set(lean_by_name)):
        if sym in all_lean_by_name:
            actual = all_lean_by_name[sym].kind
            result.warn(
                f"lean_symbol declared as {actual!r} not {section!r}: {sym!r}"
                f"  (kind mismatch — intentional refactor?)"
            )
        else:
            result.warn(f"lean_symbol no longer in Lean: {sym!r}  (orphaned)")
            result.orphaned += 1

    # Symbols already registered in any section — prevents duplicate stubs
    # when a symbol's Lean kind doesn't match its registry section (e.g.
    # abbrev Ontology living in substrate-types as a semantic type).
    cross_registered: set[str] = {
        e["lean_symbol"]
        for sv in existing_data.values()
        if isinstance(sv, dict)
        for e in sv.values()
        if isinstance(e, dict) and "lean_symbol" in e
    }

    # Missing entries
    section_data: dict = existing_data.setdefault(section, {})
    for name in sorted(set(lean_by_name) - existing_symbols):
        if name in cross_registered:
            result.note(f"skipped: {name!r} already registered in another section")
            continue
        decl = lean_by_name[name]
        stub = _make_stub(decl, sym_to_mod.get(name, source_modules[0]))
        if name in section_data:
            section_data[name] = _merge(section_data[name], stub, overwrite)
        else:
            section_data[name] = stub
            result.added_sym(f"stub added: {section}.{name}")
            result.added += 1

    # Required-field validation — only applies to Lean symbol sections.
    # Dependency and traceability registries use a different schema and are
    # hand-authored; their entries intentionally omit lean_symbol/source_module.
    if section in _SECTION_LEAN_KINDS:
        required = _REQUIRED_BASE | (
            {"status"} if section in _REQUIRED_STATUS else set()
        )
        for entry_id, entry in _section_entries(existing_data, section).items():
            for req in sorted(required):
                if req not in entry:
                    result.warn(f"missing field {req!r} on {section}.{entry_id}")

    if result.orphaned == 0 and result.added == 0:
        result.note("all lean_symbols match")

    # Ensure header metadata for new files
    existing_data.setdefault("schema", f"se-{kind}-1")
    existing_data.setdefault("repo", repo_root.name)
    existing_data.setdefault("surface_module", index_surface_module)

    # Write
    if not dry_run and (result.added > 0 or not art_path.exists()):
        art_path.parent.mkdir(parents=True, exist_ok=True)
        _write_registry_toml(art_path, existing_data)
        result.wrote = True

    return result


# ---------------------------------------------------------------------------
# Public entry points
# ---------------------------------------------------------------------------


def run_scaffold(dry_run: bool = False, overwrite: bool = False) -> int:
    """Scaffold and validate all reference artifacts for this repo.

    Returns:
        0 on success, 1 if any artifact fails.
    """
    repo_root = _find_repo_root()
    lean_root = repo_root
    index_path = repo_root / "reference" / "index.toml"

    if not index_path.exists():
        print(f"error: reference/index.toml not found in {repo_root}")
        return 1

    try:
        index = _load_toml(index_path)
    except Exception as exc:
        print(f"error: cannot parse reference/index.toml: {exc}")
        return 1

    index_surface_module = index.get("surface_module", "")

    if dry_run:
        print("[dry-run — nothing will be written]")

    all_ok = True
    for artifact in index.get("artifact", []):
        r = _process_artifact(
            artifact,
            repo_root,
            lean_root,
            index_surface_module,
            dry_run,
            overwrite,
        )
        tag = "ok  " if r.ok else "FAIL"
        note = "  [wrote]" if r.wrote else ""
        print(f"  [{tag}]  {r.artifact_id}{note}")
        for msg in r.messages:
            print(msg)
        if not r.ok:
            all_ok = False

    return 0 if all_ok else 1


def run_ref_validate(strict: bool = False) -> int:
    """Validate reference artifacts without adding any stubs.

    Returns:
        0 on success, 1 on any failure or (with strict) any warning.
    """
    repo_root = _find_repo_root()
    lean_root = repo_root
    index_path = repo_root / "reference" / "index.toml"

    if not index_path.exists():
        print(f"error: reference/index.toml not found in {repo_root}")
        return 1

    try:
        index = _load_toml(index_path)
    except Exception as exc:
        print(f"error: cannot parse reference/index.toml: {exc}")
        return 1

    index_surface_module = index.get("surface_module", "")
    all_ok = True

    for artifact in index.get("artifact", []):
        # dry_run=True, overwrite=False: validate only, no writes, no additions
        r = _process_artifact(
            artifact,
            repo_root,
            lean_root,
            index_surface_module,
            dry_run=True,
            overwrite=False,
        )
        has_warnings = any("warn" in m for m in r.messages)
        tag = "ok  " if r.ok else "FAIL"
        print(f"  [{tag}]  {r.artifact_id}")
        for msg in r.messages:
            if "skipped" not in msg:
                print(msg)
        if not r.ok or (strict and has_warnings):
            all_ok = False

    return 0 if all_ok else 1
