# SE Theory: Neutral Substrate (NS)

> Lean 4 formalization of the Neutral Substrate specification from
> Structural Explainability (SE) theory.

For normative definitions, stability guarantees, and theorem statements,
see `NeutralSubstrate.lean` (the authoritative source).
This document provides a brief orientation only.
See [process](./process.md) for an overview of the Lean implementation process.
See [process-040](./process-040.md) for an overview of
proving NS from a conjunction (`ExtensionStable ∧ InterpretivelyNonCommitted`)
rather than a single proposition (`ExtensionStable`).

## Neutral Substrate

```text
Neutral substrate definitions are independent of identity regimes.
Regime-specific persistence is evaluated downstream.
```

This repository treats the neutral substrate as a formal theory layer that can
be imported by downstream Structural Explainability repositories.

## Dependencies

This repository is a foundational theory-layer repository for Structural
Explainability.

It should not depend on transformation theory, persistence theory, identity
regimes, or structural-explainability integration theory. Those repositories
consume the neutral substrate, not the reverse.

## Covers

This repository covers:

- neutral structural primitives
- substrate well-formedness vocabulary
- admissibility conditions
- extension stability
- interpretive non-commitment
- separation constraints
- substrate-level invariants
- neutrality axioms
- neutrality theorems
- Lean-side reference identifiers
- machine-readable neutral-substrate contract artifacts
- public Lean import surface

## Owns

This repository owns:

- Lean definitions under `NeutralSubstrate/`
- the public import surface `NeutralSubstrate.lean`
- curated exports in `NeutralSubstrate/Surface.lean`
- canonical citation IDs in `NeutralSubstrate/Spec.lean`
- reference artifacts under `reference/`
- generated neutral-substrate artifacts under `data/neutral-substrate/`
- validation and export tooling for neutral-substrate artifacts
- machine-checked theorems for neutral substrate theory

## Does not own

This repository does not own:

- transformation theory
- persistence theory
- identity regimes
- regime profiles
- regime classification matrices
- regime-specific persistence semantics
- mapping semantics
- accountable entities
- exchange protocols
- domain examples
- operational validation
- runtime systems
- operational policy

## Design Constraints

Lean source files are authoritative for formal definitions, predicates, axioms,
theorems, proof obligations, and reference rules.

Python and generated data may mirror, validate, export, or document the Lean
surface. They must not define theory semantics independently of Lean.

Constructor-level vocabulary is intentionally not duplicated in this README.
See the Lean source files and reference registries for current values.

The neutral substrate must remain upstream of transformation, persistence,
identity-regime, and integration theory.

## Documentation Constraints

Documentation is descriptive only.

It may provide orientation, summaries, and navigation. It must not introduce
formal semantics absent from Lean.

Documentation must not:

- restate formal definitions in alternative form
- introduce new terminology not present in Lean or reference artifacts
- encode rules or invariants not present in Lean
- diverge from Lean module naming

Documentation may provide:

- explanatory summaries
- structural descriptions
- navigation and orientation
- non-authoritative theorem descriptions

## Contents

Primary Lean locations:

```text
NeutralSubstrate/Core.lean
NeutralSubstrate/Spec.lean
NeutralSubstrate/Surface.lean
NeutralSubstrate.lean
```

Reference artifacts mirror the Lean public surface:

```text
reference/
```

Generated neutral-substrate contract artifacts are in:

```text
data/neutral-substrate/
```

## Build

Use VS Code Menu:
View / Command Palette / `Developer: Reload Window` to refresh.

```shell
elan self update
lake update
lake build
lake build TestAll
uv run se-ref-validate
uv run se-ref-export --check
uv run se-validate --strict
uv run python -m pyright
uv run python -m pytest
uv run python -m zensical build
```

## Import

Downstream Lean projects should import the public surface:

```text
import NeutralSubstrate
```

The public import surface is curated in:

```text
NeutralSubstrate.lean
NeutralSubstrate/Surface.lean
```

## Tooling

Python and other tooling may be used for:

- documentation generation
- formatting and linting
- repository automation
- reference artifact validation
- generated contract export checks

They must not:

- define correctness
- validate theory semantics independently of Lean
- replace Lean definitions or proofs
- introduce downstream theory dependencies
