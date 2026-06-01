"""reference_tool/lean.py - Expected Lean public surface for se-theory-neutral-substrate.

Owns:
  - SURFACE_TYPES       - exported public Lean types
  - SURFACE_PREDICATES  - exported public Lean predicates
  - SURFACE_AXIOMS      - exported public Lean axioms
  - SURFACE_THEOREMS    - exported public Lean theorems
  - SURFACE_SYMBOLS     - combined exported public Lean symbols

Does not own:
  - parsing Lean files
  - validating reference artifacts
  - loading TOML or JSON files
  - CLI or orchestration behavior

This module mirrors NeutralSubstrate/Surface.lean so Python validation can check
that reference artifacts cover the public Lean surface.

Current strategy:
  Keep this file aligned manually with NeutralSubstrate/Surface.lean.

Future strategy:
  Replace or supplement these constants by parsing Surface.lean directly.

Call chain:
  __main__.py -> cli.main()
              -> orchestrate.run_validate()
              -> validate_reference.validate_reference()
              -> lean_surface.SURFACE_SYMBOLS
"""

from dataclasses import dataclass
from pathlib import Path
import re

LEAN_DECL_TO_SECTION: dict[str, str] = {
    "inductive": "type",
    "structure": "type",
    "theorem": "theorem",
    "lemma": "theorem",
    "axiom": "axiom",
    "def": "predicate",
    "abbrev": "predicate",
}

SECTION_LEAN_KINDS: dict[str, set[str]] = {
    "type": {"inductive", "structure"},
    "predicate": {"def", "abbrev"},
    "theorem": {"theorem", "lemma"},
    "axiom": {"axiom"},
    "requirement": {"def"},
    "witness": {"def", "abbrev"},
}

DECL_RE = re.compile(
    r"^(?:private\s+|protected\s+)?(?:noncomputable\s+)?"
    r"(theorem|lemma|def|abbrev|inductive|structure|axiom|class|instance)\s+(\w+)",
    re.MULTILINE,
)

SPEC_STRING_RE = re.compile(
    r"def\s+(\w+)\s*:\s*String\s*:=\s*\"([^\"]+)\"",
    re.MULTILINE,
)

SURFACE_TYPES: frozenset[str] = frozenset(
    {
        "PrimitiveKind",
        "Primitive",
        "Ontology",
        "Framework",
    }
)


SURFACE_PREDICATES: frozenset[str] = frozenset(
    {
        "Admissible",
        "containsCausalOrNormative",
        "extensionInconsistent",
        "ExtensionStable",
        "Neutral",
        "FrameworkVariant",
        "FrameworksContradict",
        "InterpretivelyNonCommitted",
    }
)


SURFACE_AXIOMS: frozenset[str] = frozenset(
    {
        "framework_relativity",
        "neutral_primitives_undisputed",
        "causal_normative_affirmed",
    }
)


SURFACE_THEOREMS: frozenset[str] = frozenset(
    {
        "not_neutral_if_causal_or_normative",
        "neutral_if_only_neutral",
        "ontological_neutrality_theorem",
        "only_neutral_primitives_implies_INC",
        "framework_contestability_lemma",
        "separate_stability",
    }
)


SURFACE_SYMBOLS: frozenset[str] = frozenset(
    {
        *SURFACE_TYPES,
        *SURFACE_PREDICATES,
        *SURFACE_AXIOMS,
        *SURFACE_THEOREMS,
    }
)


SURFACE_BY_KIND: dict[str, frozenset[str]] = {
    "type": SURFACE_TYPES,
    "predicate": SURFACE_PREDICATES,
    "axiom": SURFACE_AXIOMS,
    "theorem": SURFACE_THEOREMS,
}


@dataclass(frozen=True)
class LeanDecl:
    """Lean declaration with name, kind, and reference section."""

    name: str
    kind: str
    section: str


def extract_decls(lean_file: Path) -> list[LeanDecl]:
    """Extract top-level Lean declarations from a Lean file."""
    if not lean_file.exists():
        return []

    text = lean_file.read_text(encoding="utf-8")
    return [
        LeanDecl(
            name=match.group(2),
            kind=match.group(1),
            section=LEAN_DECL_TO_SECTION.get(match.group(1), "unknown"),
        )
        for match in DECL_RE.finditer(text)
    ]


def extract_for_section(lean_file: Path, target_section: str) -> list[LeanDecl]:
    """Extract Lean declarations matching a reference section."""
    wanted = SECTION_LEAN_KINDS.get(target_section)
    if wanted is None:
        return []
    return [decl for decl in extract_decls(lean_file) if decl.kind in wanted]


def extract_spec_ids(spec_file: Path) -> set[str]:
    """Extract stable citation IDs from a Spec.lean file."""
    if not spec_file.exists():
        return set()

    text = spec_file.read_text(encoding="utf-8")
    return {match.group(2) for match in SPEC_STRING_RE.finditer(text)}


def expected_symbols_for_kind(kind: str) -> frozenset[str]:
    """Return expected public Lean symbols for a surface kind.

    Args:
        kind: Surface kind. Expected values are type, predicate, axiom, theorem.

    Returns:
        The expected exported Lean symbols for the requested kind.

    Raises:
        ValueError: If kind is not a known surface kind.
    """
    try:
        return SURFACE_BY_KIND[kind]
    except KeyError as e:
        valid_kinds = ", ".join(sorted(SURFACE_BY_KIND))
        raise ValueError(
            f"Unknown Lean surface kind: {kind}. Expected one of: {valid_kinds}"
        ) from e


def infer_core_modules(surface_module: str, lean_root: Path) -> list[str]:
    """Infer Core modules under the surface namespace."""
    if not surface_module.endswith(".Surface"):
        return []

    root_module = surface_module.removesuffix(".Surface")
    root_dir = lean_root.joinpath(*root_module.split("."))

    if not root_dir.exists():
        return []

    core_files = sorted(root_dir.rglob("Core.lean"))

    root_core = root_dir / "Core.lean"
    if root_core in core_files:
        core_files.remove(root_core)
        core_files.insert(0, root_core)

    return [path_to_module(path, lean_root) for path in core_files]


def infer_spec_module(surface_module: str) -> str:
    """Infer the Spec module from the public surface module."""
    if surface_module.endswith(".Surface"):
        return surface_module.removesuffix(".Surface") + ".Spec"
    return surface_module + ".Spec"


def missing_expected_surface_symbols(registered: set[str]) -> set[str]:
    """Return expected public-surface symbols missing from reference registries."""
    return set(SURFACE_SYMBOLS) - registered


def path_to_module(path: Path, lean_root: Path) -> str:
    """Convert a Lean file path to a module name."""
    rel = path.relative_to(lean_root).with_suffix("")
    return ".".join(rel.parts)
