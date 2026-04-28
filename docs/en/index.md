# SE Theory: Neutral Substrate

> Lean 4 formalization of the neutral structural substrate
> of Structural Explainability.

This repository defines the minimal structural conditions
under which identity regimes may be applied,
without encoding identity, persistence, domain semantics,
or operational behavior.

## Boundary

This documentation is non-authoritative.
All formal definitions, invariants, and theorems are defined exclusively
in Lean source files under `NeutralSubstrate/`.

If documentation and Lean diverge, Lean is correct.

## Purpose

The neutral substrate establishes the **admissibility boundary**
for Structural Explainability.

It answers:

- What must be true of a structure before any identity regime can be applied?
- What must remain absent to preserve neutrality?
- What invariants hold independently of any regime?

It does not define identity regimes or their behavior.

## Scope

### Includes

- Neutral structural primitives
- Substrate well-formedness
- Admissibility conditions
- Separation constraints (non-encoding of regimes)
- Substrate-level invariants
- Machine-checked Lean theorems

### Excludes

- Identity regimes (OBL, NOR, OCC, CTX, REC, ENR)
- Regime profiles and derivation
- Persistence behavior
- Mapping semantics
- Domain-specific data or examples
- Operational validation logic
- Runtime systems

## Structure

The root file provides a single import surface:

```lean
import NeutralSubstrate
```

## Design Principles

### Neutrality

The substrate must not encode identity-regime behavior.

All regime semantics are external to this layer.

### Admissibility

A structure must satisfy explicit conditions before it can support regime
application.

Admissibility is necessary but not sufficient for any particular regime.

### Separation

Structural definitions must remain independent from:

- identity
- persistence
- interpretation
- operational concerns

### Invariance

Substrate-level invariants hold regardless of which regime is applied.

### Lean as Authority

All correctness is expressed and verified in Lean.

No external system defines or validates theory semantics.

## Relationship to Other Theory Repositories

### se-theory-identity-regimes

Defines the six identity regimes over admissible substrates.

Imports this repository.

### se-theory-structural-explainability

Integrates results across substrate and regimes.

Imports this repository and the identity-regimes repository.

## Build

```shell
elan self update
lake update
lake build
```

## Tooling

Python tooling is used for:

- documentation generation (Zensical)
- repository hygiene (pre-commit, ruff)

Python tooling must not:

- define correctness
- validate theory semantics
- replace Lean proofs
