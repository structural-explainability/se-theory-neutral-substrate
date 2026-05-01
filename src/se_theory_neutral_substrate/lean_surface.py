"""lean_surface.py - Expected Lean public surface for se-theory-neutral-substrate.

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
