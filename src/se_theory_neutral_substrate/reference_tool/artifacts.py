"""reference_tool/artifacts.py - Artifact processing for reference registries."""

from pathlib import Path
from typing import Any

from se_theory_neutral_substrate.load import load_toml
from se_theory_neutral_substrate.reference_tool.lean import (
    SECTION_LEAN_KINDS,
    LeanDecl,
    extract_decls,
    extract_for_section,
    extract_spec_ids,
    infer_core_modules,
    infer_spec_module,
)
from se_theory_neutral_substrate.reference_tool.models import (
    ArtifactPlan,
    ArtifactResult,
)
from se_theory_neutral_substrate.reference_tool.paths import (
    lean_module_to_path,
    reference_artifact_path,
)
from se_theory_neutral_substrate.reference_tool.registry import (
    kind_to_section,
    section_entries,
    source_modules_in_registry,
    write_registry_toml,
)
from se_theory_neutral_substrate.reference_tool.stubs import (
    make_stub,
    merge_entry,
)
from se_theory_neutral_substrate.reference_tool.validation import (
    validate_cite_ids_against_spec,
    validate_required_fields,
)

Artifact = dict[str, Any]
RegistryData = dict[str, Any]


def plan_artifact(
    artifact: Artifact,
    repo_root: Path,
) -> ArtifactPlan | ArtifactResult:
    """Validate artifact metadata and return a processing plan or final result."""
    artifact_id = str(artifact.get("id", "<unnamed>"))
    result = ArtifactResult(artifact_id=artifact_id)

    artifact_format = artifact.get("format", "toml")
    generated = artifact.get("generated", False)

    if generated or artifact_format != "toml":
        result.note("skipped (generated or non-toml)")
        return result

    rel_path = artifact.get("path", "")
    if not isinstance(rel_path, str) or not rel_path:
        result.fail("artifact path must be a nonempty string")
        return result

    kind = str(artifact.get("kind", ""))
    section = kind_to_section(kind)

    return ArtifactPlan(
        artifact_id=artifact_id,
        path=reference_artifact_path(rel_path, root=repo_root),
        kind=kind,
        section=section,
    )


def process_artifact(
    artifact: Artifact,
    repo_root: Path,
    index_surface_module: str,
    dry_run: bool,
    overwrite: bool,
    all_registered: set[str] | None = None,
) -> ArtifactResult:
    """Process one artifact from reference/index.toml."""
    plan = plan_artifact(artifact, repo_root)

    if isinstance(plan, ArtifactResult):
        return plan

    result = ArtifactResult(artifact_id=plan.artifact_id)
    existing_data = load_existing_artifact(plan.path, result)

    if not result.ok:
        return result

    source_modules = resolve_source_modules(
        artifact=artifact,
        repo_root=repo_root,
        index_surface_module=index_surface_module,
        result=result,
        existing_data=existing_data,
    )

    lean_decls = collect_section_declarations(
        source_modules,
        plan.section,
        repo_root,
        result,
    )

    if not result.ok:
        return result

    lean_by_name = {decl.name: decl for decl in lean_decls}
    all_lean_by_name, symbol_to_module = collect_all_declarations(
        source_modules,
        repo_root,
    )

    existing_entries = section_entries(existing_data, plan.section)
    existing_symbols = {
        str(entry["lean_symbol"])
        for entry in existing_entries.values()
        if "lean_symbol" in entry
    }

    warn_for_orphaned_symbols(
        existing_symbols=existing_symbols,
        lean_symbols=set(lean_by_name),
        all_lean_by_name=all_lean_by_name,
        section=plan.section,
        result=result,
    )

    add_missing_stubs(
        existing_data=existing_data,
        plan=plan,
        lean_by_name=lean_by_name,
        symbol_to_module=symbol_to_module,
        source_modules=source_modules,
        all_registered=all_registered,
        overwrite=overwrite,
        result=result,
    )

    if overwrite:
        refresh_existing_stubs(
            existing_data=existing_data,
            plan=plan,
            lean_by_name=lean_by_name,
            symbol_to_module=symbol_to_module,
            source_modules=source_modules,
        )

    validate_lean_symbol_section(
        existing_data=existing_data,
        plan=plan,
        repo_root=repo_root,
        index_surface_module=index_surface_module,
        result=result,
    )

    if result.orphaned == 0 and result.added == 0:
        result.note("all lean_symbols match")

    ensure_artifact_header(
        data=existing_data,
        kind=plan.kind,
        repo_name=repo_root.name,
        index_surface_module=index_surface_module,
    )

    write_artifact_if_needed(
        path=plan.path,
        data=existing_data,
        dry_run=dry_run,
        overwrite=overwrite,
        result=result,
    )

    return result


def load_existing_artifact(path: Path, result: ArtifactResult) -> RegistryData:
    """Load an existing TOML artifact or return empty data."""
    if not path.exists():
        result.note("no existing file; will create")
        return {}

    try:
        return load_toml(path)
    except Exception as exc:
        result.fail(f"TOML parse error: {exc}")
        return {}


def resolve_source_modules(
    artifact: Artifact,
    repo_root: Path,
    index_surface_module: str,
    result: ArtifactResult,
    existing_data: RegistryData,
) -> list[str]:
    """Resolve source modules for an artifact."""
    source_modules: list[str] = []

    source_module = artifact.get("source_module")
    if isinstance(source_module, str) and source_module:
        source_modules = [source_module]

    if not source_modules and existing_data:
        source_modules = source_modules_in_registry(existing_data)

    if not source_modules:
        surface = existing_data.get("surface_module", index_surface_module)

        if not isinstance(surface, str) or not surface:
            surface = index_surface_module

        source_modules = infer_core_modules(surface, lean_root=repo_root)

        if source_modules:
            result.note("source modules inferred: " + ", ".join(source_modules))
        else:
            derived = surface.replace("Surface", "Core")
            source_modules = [derived]
            result.note(f"source module inferred: {derived}")

    return source_modules


def collect_section_declarations(
    source_modules: list[str],
    section: str,
    repo_root: Path,
    result: ArtifactResult,
) -> list[LeanDecl]:
    """Collect Lean declarations matching the registry section."""
    declarations: list[LeanDecl] = []

    for module in source_modules:
        lean_file = lean_module_to_path(module, root=repo_root)

        if not lean_file.exists():
            result.fail(f"lean file not found: {lean_file}")
            continue

        declarations.extend(extract_for_section(lean_file, section))

    return declarations


def collect_all_declarations(
    source_modules: list[str],
    repo_root: Path,
) -> tuple[dict[str, LeanDecl], dict[str, str]]:
    """Collect all Lean declarations and their source modules."""
    all_lean_by_name: dict[str, LeanDecl] = {}
    symbol_to_module: dict[str, str] = {}

    for module in source_modules:
        lean_file = lean_module_to_path(module, root=repo_root)

        for declaration in extract_decls(lean_file):
            all_lean_by_name.setdefault(declaration.name, declaration)
            symbol_to_module.setdefault(declaration.name, module)

    return all_lean_by_name, symbol_to_module


def warn_for_orphaned_symbols(
    existing_symbols: set[str],
    lean_symbols: set[str],
    all_lean_by_name: dict[str, LeanDecl],
    section: str,
    result: ArtifactResult,
) -> None:
    """Warn for symbols missing from the expected Lean section."""
    for symbol in sorted(existing_symbols - lean_symbols):
        if symbol in all_lean_by_name:
            actual = all_lean_by_name[symbol].kind
            result.warn(
                f"lean_symbol declared as {actual!r} not {section!r}: {symbol!r}"
                "  (kind mismatch - intentional refactor?)"
            )
        else:
            result.warn(f"lean_symbol no longer in Lean: {symbol!r}  (orphaned)")
            result.orphaned += 1


def add_missing_stubs(
    existing_data: RegistryData,
    plan: ArtifactPlan,
    lean_by_name: dict[str, LeanDecl],
    symbol_to_module: dict[str, str],
    source_modules: list[str],
    all_registered: set[str] | None,
    overwrite: bool,
    result: ArtifactResult,
) -> None:
    """Add stub registry entries for Lean symbols not yet registered."""
    existing_entries = section_entries(existing_data, plan.section)
    existing_symbols = {
        str(entry["lean_symbol"])
        for entry in existing_entries.values()
        if "lean_symbol" in entry
    }

    section_data = existing_data.setdefault(plan.section, {})

    if not isinstance(section_data, dict):
        result.fail(f"section {plan.section!r} must be a table")
        return

    for name in sorted(set(lean_by_name) - existing_symbols):
        if all_registered and name in all_registered:
            result.note(f"skipped: {name!r} already registered in another artifact")
            continue

        declaration = lean_by_name[name]
        source_module = symbol_to_module.get(name, source_modules[0])
        stub = make_stub(declaration, source_module)

        existing = section_data.get(name)
        if isinstance(existing, dict):
            section_data[name] = merge_entry(existing, stub, overwrite)
        else:
            section_data[name] = stub
            result.added_sym(f"stub added: {plan.section}.{name}")
            result.added += 1


def refresh_existing_stubs(
    existing_data: RegistryData,
    plan: ArtifactPlan,
    lean_by_name: dict[str, LeanDecl],
    symbol_to_module: dict[str, str],
    source_modules: list[str],
) -> None:
    """Refresh generated fields for existing entries when overwrite is enabled."""
    section_data = existing_data.get(plan.section)

    if not isinstance(section_data, dict):
        return

    for name, declaration in lean_by_name.items():
        existing = section_data.get(name)

        if not isinstance(existing, dict):
            continue

        source_module = symbol_to_module.get(name, source_modules[0])
        stub = make_stub(declaration, source_module)
        section_data[name] = merge_entry(existing, stub, overwrite=True)


def validate_lean_symbol_section(
    existing_data: RegistryData,
    plan: ArtifactPlan,
    repo_root: Path,
    index_surface_module: str,
    result: ArtifactResult,
) -> None:
    """Run validation that applies only to Lean symbol registry sections."""
    if plan.section not in SECTION_LEAN_KINDS:
        return

    validate_required_fields(existing_data, plan.section, result)

    spec_module = infer_spec_module(index_surface_module)
    spec_file = lean_module_to_path(spec_module, root=repo_root)
    spec_ids = extract_spec_ids(spec_file)

    validate_cite_ids_against_spec(
        existing_data,
        plan.section,
        spec_ids,
        result,
    )


def ensure_artifact_header(
    data: RegistryData,
    kind: str,
    repo_name: str,
    index_surface_module: str,
) -> None:
    """Ensure required top-level artifact metadata exists."""
    data.setdefault("schema", f"se-{kind}-1")
    data.setdefault("repo", repo_name)
    data.setdefault("surface_module", index_surface_module)


def write_artifact_if_needed(
    path: Path,
    data: RegistryData,
    dry_run: bool,
    overwrite: bool,
    result: ArtifactResult,
) -> None:
    """Write artifact TOML when scaffold changed it."""
    if dry_run:
        return

    if result.added > 0 or not path.exists() or overwrite:
        path.parent.mkdir(parents=True, exist_ok=True)
        write_registry_toml(path, data)
        result.wrote = True


def process_artifacts(
    dry_run: bool,
    overwrite: bool,
    repo_root: Path,
    index: RegistryData,
    index_surface_module: str,
    all_registered: set[str],
) -> bool:
    """Process all artifacts from the reference index."""
    all_ok = True

    artifacts = index.get("artifact", [])
    if not isinstance(artifacts, list):
        print("error: reference/index.toml field 'artifact' must be a list")
        return False

    for artifact in artifacts:
        if not isinstance(artifact, dict):
            print("  [FAIL]  invalid artifact entry")
            all_ok = False
            continue

        result = process_artifact(
            artifact=artifact,
            repo_root=repo_root,
            index_surface_module=index_surface_module,
            dry_run=dry_run,
            overwrite=overwrite,
            all_registered=all_registered,
        )

        tag = "ok  " if result.ok else "FAIL"
        note = "  [wrote]" if result.wrote else ""
        print(f"  [{tag}]  {result.artifact_id}{note}")

        for message in result.messages:
            print(message)

        if not result.ok:
            all_ok = False

    return all_ok
