"""scaffold_reference.py.

Reads reference/index.toml from an SE theory repo, scans each artifact's
Lean 4 source module for declarations, then:

  VALIDATE  — checks every lean_symbol in the registry still exists in Lean,
              and reports symbols present in Lean but missing from the registry.

  SCAFFOLD  — adds stub entries for any missing symbols.  Existing entries
              (descriptions, names, cite_ids) are NEVER modified unless
              --overwrite is given.

  SKIP      — artifacts with generated=true or format=json (proof-registry.json
              is Lean-generated, not our job here).

Source-module resolution order for a given artifact:
  1. source_module field on the [[artifact]] entry in index.toml
  2. Unique source_module values already in the existing registry file
  3. Surface module from registry header with "Surface" replaced by "Core"
  4. The surface_module declared at the top of index.toml

Usage
-----
  # validate + scaffold (default)
  python scaffold_reference.py --repo /path/to/se-theory-neutral-substrate

  # dry-run: report only, write nothing
  python scaffold_reference.py --repo /path/to/se-theory-neutral-substrate --dry-run

  # overwrite existing descriptions/names/cite_ids with re-derived values
  python scaffold_reference.py --repo /path/to/se-theory-neutral-substrate --overwrite

  # all three theory repos under a common parent directory
  python scaffold_reference.py --all /path/to/structural-explainability

  # if Lean sources live under a src/ subdirectory
  python scaffold_reference.py --repo ... --lean-root /path/to/repo/src

index.toml artifact entries may carry an optional hint:
  source_module = "NeutralSubstrate.Core"
This tells the scaffolder exactly which module to scan for that artifact.
"""

import argparse
from dataclasses import dataclass, field
from pathlib import Path
import re
import sys
from typing import Any

try:
    import tomllib
except ImportError:
    try:
        import tomli as tomllib  # pip install tomli
    except ImportError:
        print("error: requires tomllib (Python 3.11+) or: pip install tomli")
        sys.exit(1)


# ---------------------------------------------------------------------------
# Lean 4 declaration extraction
# ---------------------------------------------------------------------------

# Maps a Lean keyword to the canonical section name used in registries.
LEAN_DECL_TO_SECTION: dict[str, str] = {
    "inductive": "type",
    "structure": "type",
    "theorem": "theorem",
    "lemma": "theorem",
    "axiom": "axiom",
    "def": "predicate",
    "abbrev": "predicate",
}

# Pattern: optional "noncomputable", then keyword, then identifier.
_DECL_RE = re.compile(
    r"^(?:private\s+|protected\s+)?(?:noncomputable\s+)?"
    r"(theorem|lemma|def|abbrev|inductive|structure|axiom|class|instance)\s+(\w+)",
    re.MULTILINE,
)

# artifact kind suffix -> which Lean decl kinds to collect
# Derived lazily from the last hyphen-delimited word before "-registry".
_SECTION_LEAN_KINDS: dict[str, set[str]] = {
    "type": {"inductive", "structure"},
    "predicate": {"def", "abbrev"},
    "theorem": {"theorem", "lemma"},
    "axiom": {"axiom"},
    "witness": {"def", "abbrev"},
}


@dataclass
class LeanDecl:
    """Represents a single top-level declaration extracted from a Lean file."""

    name: str
    kind: str  # raw Lean keyword
    section: str  # registry section name


def extract_decls(lean_file: Path) -> list[LeanDecl]:
    """Extract all top-level declarations from a Lean file."""
    if not lean_file.exists():
        return []
    text = lean_file.read_text(encoding="utf-8")
    decls = []
    for m in _DECL_RE.finditer(text):
        keyword, name = m.group(1), m.group(2)
        section = LEAN_DECL_TO_SECTION.get(keyword, "unknown")
        decls.append(LeanDecl(name=name, kind=keyword, section=section))
    return decls


def extract_decls_for_section(lean_file: Path, target_section: str) -> list[LeanDecl]:
    """Extract declarations for a section.

    Args:
        lean_file (Path): _description_
        target_section (str): _description_

    Returns:
        list[LeanDecl]: _description_
    """
    wanted_kinds = _SECTION_LEAN_KINDS.get(target_section)
    decls = extract_decls(lean_file)
    if wanted_kinds is None:
        return decls  # unknown section: return everything
    return [d for d in decls if d.kind in wanted_kinds]


# ---------------------------------------------------------------------------
# Module path resolution
# ---------------------------------------------------------------------------


def module_to_path(module: str, lean_root: Path) -> Path:
    """'NeutralSubstrate.Core'  ->  lean_root/NeutralSubstrate/Core.lean."""
    parts = module.split(".")
    return lean_root.joinpath(*parts[:-1]) / f"{parts[-1]}.lean"


def infer_core_module(surface_module: str) -> str:
    """'NeutralSubstrate.Surface'  ->  'NeutralSubstrate.Core'  (best-effort)."""
    return surface_module.replace("Surface", "Core")


# ---------------------------------------------------------------------------
# Artifact-kind → section name
# ---------------------------------------------------------------------------


def kind_to_section(artifact_kind: str) -> str:
    """Kind to section.

    'substrate-type-registry'      ->  'type'
    'se-predicate-registry'        ->  'predicate'
    'regime-theorem-registry'      ->  'theorem'
    'proof-registry'               ->  '' (handled elsewhere)
    """
    without_suffix = artifact_kind.removesuffix("-registry")
    return (
        without_suffix.rsplit("-", 1)[-1] if "-" in without_suffix else without_suffix
    )


# ---------------------------------------------------------------------------
# TOML reading helpers
# ---------------------------------------------------------------------------


def load_toml(path: Path) -> dict[str, Any]:
    """Load a TOML file into a dict."""
    return tomllib.loads(path.read_text(encoding="utf-8"))


def existing_registry_symbols(data: dict) -> dict[str, dict]:
    """Returns {lean_symbol: entry_dict} for all entries in a registry."""
    result: dict[str, dict] = {}
    for section_val in data.values():
        if not isinstance(section_val, dict):
            continue
        for entry in section_val.values():
            if isinstance(entry, dict) and "lean_symbol" in entry:
                sym = entry["lean_symbol"]
                result[sym] = entry
    return result


def existing_section_entries(data: dict, section: str) -> dict[str, dict]:
    """Returns {entry_id: entry_dict} for a specific section."""
    return {k: v for k, v in data.get(section, {}).items() if isinstance(v, dict)}


def source_modules_from_registry(data: dict) -> list[str]:
    """Collect unique source_module values from existing registry entries."""
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
# Minimal TOML writer  (no external dependency)
# ---------------------------------------------------------------------------


def _toml_str(v: Any) -> str:
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, str):
        escaped = v.replace("\\", "\\\\").replace('"', '\\"')
        return f'"{escaped}"'
    return str(v)


def write_registry_toml(path: Path, data: dict, header_keys: list[str]) -> None:
    """Write a registry TOML file.

    `header_keys` lists which top-level scalar
    keys to emit first (in order); nested table sections follow.
    """
    lines: list[str] = []

    # Header scalars
    for key in header_keys:
        if key in data and not isinstance(data[key], dict):
            lines.append(f"{key} = {_toml_str(data[key])}")
    lines.append("")

    # Nested table sections  [section.id]
    for section_key, section_val in data.items():
        if section_key in header_keys or not isinstance(section_val, dict):
            continue
        for entry_id, entry in section_val.items():
            if not isinstance(entry, dict):
                continue
            lines.append(f"[{section_key}.{entry_id}]")
            for field_key, field_val in entry.items():
                lines.append(f"{field_key} = {_toml_str(field_val)}")
            lines.append("")

    path.write_text("\n".join(lines), encoding="utf-8")


# ---------------------------------------------------------------------------
# Scaffold-entry generation
# ---------------------------------------------------------------------------

PLACEHOLDER = ""  # empty string: clearly needs human input


def make_stub_entry(decl: LeanDecl, source_module: str, repo: str) -> dict:
    """Make a stub registry entry for a Lean declaration."""
    entry: dict[str, Any] = {
        "id": decl.name,
        "cite_id": PLACEHOLDER,
        "name": PLACEHOLDER,
        "lean_symbol": decl.name,
        "source_module": source_module,
        "description": PLACEHOLDER,
    }
    if decl.section in ("theorem", "axiom"):
        entry["status"] = "pending"
    return entry


def merge_entries(existing: dict, stub: dict, overwrite: bool) -> dict:
    """Merge stub into existing entry.

    Without --overwrite, human-authored
    fields (description, name, cite_id) are preserved unchanged.
    Fields with placeholder values in existing are refreshed from stub.
    """
    HUMAN_FIELDS = {"description", "name", "cite_id"}
    result = dict(existing)
    for key, val in stub.items():
        if key not in existing:
            result[key] = val  # new field: add it
        elif overwrite:
            result[key] = val  # forced overwrite
        elif key in HUMAN_FIELDS and existing[key] == PLACEHOLDER:
            result[key] = val  # was empty: keep stub
        # else: preserve existing human-authored value
    return result


# ---------------------------------------------------------------------------
# Core per-artifact logic
# ---------------------------------------------------------------------------


@dataclass
class ArtifactResult:
    """Accumulates results and messages for processing a single artifact."""

    artifact_id: str
    ok: bool = True
    messages: list[str] = field(default_factory=list)
    wrote: bool = False

    def fail(self, msg: str) -> None:
        """Record a failure message and mark the artifact as not OK."""
        self.messages.append(f"  FAIL  {msg}")
        self.ok = False

    def warn(self, msg: str) -> None:
        """Record a warning message."""
        self.messages.append(f"  warn  {msg}")

    def info(self, msg: str) -> None:
        """Record an informational message."""
        self.messages.append(f"  +     {msg}")

    def note(self, msg: str) -> None:
        """Record a note message."""
        self.messages.append(f"        {msg}")


def process_artifact(
    artifact: dict,
    repo_root: Path,
    lean_root: Path,
    index_surface_module: str,
    dry_run: bool,
    overwrite: bool,
) -> ArtifactResult:
    """Process a single artifact entry from index.toml.

    Args:
        artifact (dict): The artifact entry from index.toml.
        repo_root (Path): Root path of the repository.
        lean_root (Path): Root path of the Lean source files.
        index_surface_module (str): The surface module declared in index.toml.
        dry_run (bool): If True, do not write any files; only report.
        overwrite (bool): If True, overwrite existing descriptions/names/cite_ids.

    Returns:
        ArtifactResult: The result of processing the artifact.
    """
    art_id = artifact.get("id", "<unnamed>")
    rel_path = artifact.get("path", "")
    fmt = artifact.get("format", "toml")
    generated = artifact.get("generated", False)
    kind = artifact.get("kind", "")
    section = kind_to_section(kind)

    result = ArtifactResult(artifact_id=art_id)

    # Skip generated and non-TOML artifacts
    if generated or fmt != "toml":
        result.note("skipped (generated or non-toml)")
        return result

    art_path = repo_root / rel_path

    # --- Load existing file if present ---
    existing_data: dict = {}
    if art_path.exists():
        try:
            existing_data = load_toml(art_path)
        except Exception as exc:
            result.fail(f"TOML parse error: {exc}")
            return result
        result.note("existing file found")
    else:
        result.note("no existing file — will create")

    # --- Determine source modules to scan ---
    source_modules: list[str] = []

    # Priority 1: explicit hint on artifact entry in index.toml
    if "source_module" in artifact:
        source_modules = [artifact["source_module"]]

    # Priority 2: modules already referenced in registry entries
    if not source_modules and existing_data:
        source_modules = source_modules_from_registry(existing_data)

    # Priority 3: derive Core from surface_module
    if not source_modules:
        surface = existing_data.get("surface_module", index_surface_module)
        derived = infer_core_module(surface)
        source_modules = [derived]
        result.note(f"source module inferred as {derived}")

    # --- Scan Lean files ---
    all_lean_decls: list[LeanDecl] = []
    for mod in source_modules:
        lean_file = module_to_path(mod, lean_root)
        if not lean_file.exists():
            result.fail(f"lean file not found: {lean_file}  (module: {mod})")
            continue
        decls = extract_decls_for_section(lean_file, section)
        all_lean_decls.extend(decls)

    if not result.ok:
        return result

    lean_by_name: dict[str, LeanDecl] = {d.name: d for d in all_lean_decls}

    # --- Existing entries ---
    existing_entries = existing_section_entries(existing_data, section)
    existing_symbols = {
        e["lean_symbol"] for e in existing_entries.values() if "lean_symbol" in e
    }

    # --- Validate existing entries against Lean ---
    orphaned = existing_symbols - set(lean_by_name.keys())
    for sym in sorted(orphaned):
        result.warn(
            f"lean_symbol no longer in Lean: {sym!r}  (orphaned — check for rename)"
        )

    # --- Missing entries: in Lean but not in registry ---
    missing_names = set(lean_by_name.keys()) - existing_symbols
    added: list[str] = []

    if missing_names:
        # Determine source_module for each missing symbol
        # (use first source module as default; could be refined if multi-module)
        sym_to_module: dict[str, str] = {}
        for mod in source_modules:
            lean_file = module_to_path(mod, lean_root)
            for d in extract_decls(lean_file):
                if d.name not in sym_to_module:
                    sym_to_module[d.name] = mod

        section_data = existing_data.setdefault(section, {})
        repo_name = existing_data.get("repo", repo_root.name)

        for name in sorted(missing_names):
            decl = lean_by_name[name]
            mod = sym_to_module.get(name, source_modules[0])
            stub = make_stub_entry(decl, mod, repo_name)

            if name in section_data:
                section_data[name] = merge_entries(section_data[name], stub, overwrite)
            else:
                section_data[name] = stub
                added.append(name)
                result.info(f"stub added: {section}.{name}")

    # --- Validate all entries have required fields ---
    REQUIRED = {"id", "cite_id", "lean_symbol", "source_module", "description"}
    STATUS_SECTIONS = {"theorem", "axiom"}
    if section in STATUS_SECTIONS:
        REQUIRED |= {"status"}

    for entry_id, entry in existing_section_entries(existing_data, section).items():
        for req_field in sorted(REQUIRED):
            if req_field not in entry:
                result.warn(f"missing field {req_field!r} on {section}.{entry_id}")
        sym = entry.get("lean_symbol", "")
        if sym and sym not in lean_by_name:
            pass  # already reported as orphaned above

    # --- Determine header keys for writing ---
    HEADER_KEYS = ["schema", "repo", "surface_module", "namespace"]

    # Ensure registry-level metadata is present for new files
    if not existing_data.get("schema"):
        existing_data["schema"] = f"se-{kind}-1"
    if not existing_data.get("repo"):
        existing_data["repo"] = repo_root.name
    if not existing_data.get("surface_module"):
        existing_data["surface_module"] = index_surface_module

    # --- Summary ---
    if not orphaned and not missing_names:
        result.note("all lean_symbols match")

    # --- Write ---
    if not dry_run and (added or not art_path.exists()):
        art_path.parent.mkdir(parents=True, exist_ok=True)
        write_registry_toml(art_path, existing_data, HEADER_KEYS)
        result.wrote = True

    return result


# ---------------------------------------------------------------------------
# Repo-level orchestration
# ---------------------------------------------------------------------------


def process_repo(
    repo_root: Path,
    lean_root: Path,
    dry_run: bool,
    overwrite: bool,
) -> bool:
    """Process a single repository: read index.toml, then process each artifact.

    Args:
        repo_root (Path): Root path of the repository.
        lean_root (Path): Root path of the Lean source files.
        dry_run (bool): If True, do not write any files; only report.
        overwrite (bool): If True, overwrite existing descriptions/names/cite_ids.

    Returns:
        bool: True if all artifacts processed successfully, False if any failed.
    """
    index_path = repo_root / "reference" / "index.toml"
    if not index_path.exists():
        print("  [skip] no reference/index.toml")
        return True

    try:
        index = load_toml(index_path)
    except Exception as exc:
        print(f"  [error] cannot parse index.toml: {exc}")
        return False

    index_surface_module = index.get("surface_module", "")
    artifacts = index.get("artifact", [])

    all_ok = True
    for artifact in artifacts:
        art_id = artifact.get("id", "<unnamed>")
        r = process_artifact(
            artifact,
            repo_root,
            lean_root,
            index_surface_module,
            dry_run,
            overwrite,
        )
        status = "ok" if r.ok else "FAIL"
        wrote = (
            "  [wrote]"
            if r.wrote
            else ("  [dry-run]" if dry_run and not artifact.get("generated") else "")
        )
        print(f"  [{status}]  {art_id}{wrote}")
        for msg in r.messages:
            print(msg)
        if not r.ok:
            all_ok = False

    return all_ok


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

THEORY_REPOS = [
    "se-theory-neutral-substrate",
    "se-theory-identity-regimes",
    "se-theory-structural-explainability",
]


def main() -> None:
    """Main entry point: parse arguments, determine repos to process, and run."""
    parser = argparse.ArgumentParser(
        description="Scaffold and validate SE theory reference TOML files from Lean 4 source.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    parser.add_argument("--repo", type=Path, help="Path to a single theory repo root")
    parser.add_argument(
        "--lean-root", type=Path, help="Lean source root (default: same as --repo)"
    )
    parser.add_argument(
        "--all",
        type=Path,
        dest="parent",
        help="Process all three theory repos under this parent dir",
    )
    parser.add_argument(
        "--dry-run", action="store_true", help="Report only — write nothing"
    )
    parser.add_argument(
        "--overwrite",
        action="store_true",
        help="Overwrite existing descriptions, names, and cite_ids",
    )
    args = parser.parse_args()

    repos: list[Path] = []
    if args.parent:
        for name in THEORY_REPOS:
            p = args.parent / name
            if p.exists():
                repos.append(p)
            else:
                print(f"[warn] not found, skipping: {p}")
    elif args.repo:
        repos.append(args.repo)
    else:
        parser.error("Provide --repo <path> or --all <parent-dir>")

    if not repos:
        print("[error] no repos found")
        sys.exit(1)

    if args.dry_run:
        print("[dry-run mode — nothing will be written]\n")

    overall_ok = True
    for repo in repos:
        lean_root = args.lean_root or repo
        print(f"\n{'=' * 60}")
        print(f"  {repo.name}")
        print(f"  lean-root: {lean_root}")
        print(f"{'=' * 60}")
        ok = process_repo(repo, lean_root, args.dry_run, args.overwrite)
        if not ok:
            overall_ok = False

    print()
    if overall_ok:
        print("done — all checks passed")
        sys.exit(0)
    else:
        print("done — one or more checks failed")
        sys.exit(1)


if __name__ == "__main__":
    main()
