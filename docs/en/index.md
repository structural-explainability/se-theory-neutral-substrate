# SE Theory: Neutral Substrate (NS)

Lean 4 formalization of the Neutral Substrate specification from
Structural Explainability (SE) theory.

For normative definitions, stability guarantees, and theorem statements,
see `NeutralSubstrate.lean` (the authoritative source).
This document provides a brief orientation only.
See [process](./process.md) for an overview of the Lean implementation process.
See [process-040](./process-040.md) for an overview of
proving NS from a conjunction (`ExtensionStable ∧ InterpretivelyNonCommitted`)
rather than a single proposition (`ExtensionStable`).

## Core

- **File:** `NeutralSubstrate/Core.lean`
- **Namespace:** `SE.NeutralSubstrate`

All mathematical content:
types, predicates, axioms, helper lemmas, and theorems.
Nothing is exported from this file directly.
Internal structure.
May change without notice provided the public surface
(see Surface) remains stable.

**Types:** `PrimitiveKind`, `Primitive`, `Ontology`, `Framework`

**Predicates:** `Neutral`, `Admissible`, `ExtensionStable`,
`InterpretivelyNonCommitted`, `containsCausalOrNormative`,
`extensionInconsistent`, `FrameworkVariant`, `FrameworksContradict`

**Axioms:** `framework_relativity`, `neutral_primitives_undisputed`,
`causal_normative_affirmed`

**Theorems:** `ontological_neutrality_theorem`,
`not_neutral_if_causal_or_normative`, `neutral_if_only_neutral`,
`only_neutral_primitives_implies_INC`,
`framework_contestability_lemma`, `separate_stability`

## Spec

- **File:** `NeutralSubstrate/Spec.lean`
- **Namespace:** `SE.NeutralSubstrate.Spec`

Canonical citation identifiers for all public names.
Stable string constants of the form `NS.{KIND}.{NAME}`.
No logic, no Prop, no dependency on Core.

Use these IDs in regime documentation and conformance trace matrices:

```lean
open SE.NeutralSubstrate.Spec
#check NS_ID_THEOREM_ONTOLOGICAL_NEUTRALITY
-- "NS.THEOREM.ONTOLOGICAL_NEUTRALITY"
```

## Surface

- **File:** `NeutralSubstrate/Surface.lean`

Explicit re-export of all normative public names from Core.
Controls what `import NeutralSubstrate` provides.
Names not listed in this file are internal.
Do not import Surface directly;
import `NeutralSubstrate` and receive the surface automatically.

## Metadata

Version, authorship, and release date: see `CITATION.cff`.
Scope, layer, and governance: see `SE_MANIFEST.toml`.
