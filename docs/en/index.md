# SE Theory: Neutral Substrate

> Lean 4 formalization of the Neutral Substrate layer of
> Structural Explainability theory.

This repository formalizes the substrate conditions needed to remain compatible
with admissible interpretive frameworks without settling contested causal or
normative propositions at the foundational layer.

Lean source files under `SE/` are authoritative for formal definitions,
predicates, assumptions, theorems, and proof obligations.

- [Lean API Reference](https://structural-explainability.github.io/se-theory-neutral-substrate/lean/)
- [GitHub Repository](https://github.com/structural-explainability/se-theory-neutral-substrate)
- [Citation Metadata](https://github.com/structural-explainability/se-theory-neutral-substrate/blob/main/CITATION.cff)

## Neutral Substrate

The Neutral Substrate theory separates foundational commitments from
framework-relative interpretation.

The formalization distinguishes:

- propositions carried by a language
- commitments made by a substrate
- consequences of commitment theories
- admissible interpretive frameworks
- referential regimes and commitments
- causal and normative classification
- attributional and object-level propositions
- framework-relative variation and invariance
- interpretive non-commitment
- extension stability
- neutrality by design
- the neutrality constraint

Neutral Substrate theory is upstream of identity regimes, persistence theories,
operational identity, and interpretive kernels.

## Theory Structure

```text
Propositional Language
        ↓
Commitment Theory, Consequence, and Consistency
        ↓
Frameworks, Referents, and Substrates
        ↓
Referential Commitments
        ↓
Classification, Attribution, and Interpretation
        ↓
Framework-Relative Variation and Invariance
        ↓
Contestability and Referential Common Ground
        ↓
Interpretive Non-Commitment and Extension Stability
        ↓
Neutrality by Design
        ↓
Neutrality Constraint
```

## Covers

This repository covers:

- propositional-language foundations
- commitment theories and theory extension
- consequence systems and consistency
- interpretive framework systems
- admissible framework classes
- referent carriers
- referential regimes
- substrate systems and commitments
- referential commitments
- causal and normative classification
- attribution propositions
- permitted attribution
- object-level interpretive propositions
- object-level causal or normative commitments
- framework-variant propositions
- framework-invariant propositions
- framework-compatible commitment sets
- contested causal or normative propositions
- design-time guarantees
- contestability
- referential common ground
- substrate consistency
- interpretive non-commitment
- extension stability
- neutrality by design
- the neutrality constraint
- Lean-side citation identifiers
- machine-readable reference artifacts
- the public Lean import surface

## Owns

This repository owns:

- the curated public root `SE.lean`
- foundational Lean modules under `SE/Logic/`
- framework modules under `SE/Framework/`
- referent modules under `SE/Referent/`
- substrate modules under `SE/Substrate/`
- Neutral Substrate theory under `SE/NeutralSubstrate/`
- Lean tests under `SETest/`
- stable citation identifiers in `SE/NeutralSubstrate/Spec.lean`
- reference declarations under `reference/`
- generated artifacts under `data/neutral-substrate/`
- machine-checked Neutral Substrate theorems

## Out of Scope

Those concerns belong to downstream Structural Explainability repositories:

- transformation theory
- persistence theory
- identity-regime theory
- operational identity auditing
- interpretive-kernel theory
- regime profiles
- regime classification matrices
- mapping semantics
- accountable-record models
- evolution protocols
- domain-specific scheduling semantics
- runtime validation
- runtime systems
- operational policy

## Authority

Lean source files are authoritative for:

- formal definitions
- predicates
- assumptions
- theorems
- proof obligations
- public theorem interfaces

Reference artifacts under `reference/` declare repository-owned classification,
traceability, citation mapping, and export intent for the Lean public surface.

Generated artifacts under `data/neutral-substrate/` are outputs.
They do not define theory semantics independently of Lean or the reference declarations.

The reusable `se-theory-reference-kit` owns generic reference validation,
scaffolding, cataloging, inspection, and export machinery.

## Documentation

Documentation is descriptive only and may provide:

- orientation
- explanatory summaries
- structural descriptions
- navigation
- non-authoritative theorem descriptions

It must not:

- introduce formal semantics absent from Lean
- redefine Lean predicates in incompatible terms
- introduce undeclared terminology
- encode additional rules or invariants
- diverge from Lean module naming

Exact declaration signatures and source documentation are available in the
[Lean API Reference](https://structural-explainability.github.io/se-theory-neutral-substrate/lean/).

## Repository Contents

```text
SE.lean
SE/
├── Logic/
├── Framework/
├── Referent/
├── Substrate/
└── NeutralSubstrate/

SETest.lean
SETest/
└── NeutralSubstrate/

reference/
data/neutral-substrate/
docbuild/
docs/
```

## Import

Downstream Lean projects should import the public surface:

```lean
import SE
```

The curated public import surface is declared in:

```text
SE.lean
```

## Validation

Build and validate the Lean theory:

```shell
lake build
lake test
lake lint
```

Validate reference artifacts:

```shell
uv run se-theory-reference validate
uv run se-theory-reference validate --strict
uv run se-theory-reference export --check
uv run se-theory-reference catalog --check
uv run se-theory-reference inspect
```

Validate the repository manifest:

```shell
uvx se-manifest-schema validate-manifest --strict
```

Build the narrative documentation:

```shell
uv run python -m zensical build
```

The deployment workflow builds the generated Lean API documentation from
`docbuild/` and publishes it with the Zensical site.

## Tooling Boundary

Python and other tooling may be used for:

- documentation generation
- formatting and linting
- repository automation
- reference-artifact validation
- generated-artifact export checks

Tooling must not:

- define formal correctness
- replace Lean definitions or proofs
- validate theory semantics independently of Lean
- introduce downstream theory dependencies
