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

---

## Basic

The neutral substrate is a typed structure `S = (N, E, τ)` where:

- `N` is a finite set of nodes
- `E ⊆ N × N` is a set of directed edges
- `τ : N → T` is a type assignment over a fixed type alphabet `T`

No identity, persistence, or domain semantics are attached at this layer.

## Structure

The root file provides a single import surface:

```lean
import NeutralSubstrate
```

All definitions are organized under `NeutralSubstrate/` and exported
through this entry point. Consumers import `NeutralSubstrate` only;
internal module paths are not part of the public interface.

## Admissibility

A structure must satisfy explicit conditions before it can support regime
application.

Admissibility is necessary but not sufficient for any particular regime.

A substrate `S` is **admissible** if and only if it satisfies all of:

- **Finiteness**: `N` and `E` are finite
- **Type coverage**: `τ` is total over `N`
- **Acyclicity**: the graph `(N, E)` contains no directed cycles
- **Non-emptiness**: `N` is non-empty

Admissibility is a precondition for regime application.
No identity regime may be applied to a structure that fails admissibility.

Formal definition: `NeutralSubstrate.Admissible`

## Separation

The substrate must remain free of regime-specific encoding.
Separation constraints prohibit the substrate from encoding:

- identity labels or regime selectors
- persistence markers or temporal ordering
- mapping targets or interpretation hints
- operational flags or validation state

A substrate that encodes any of the above is **not neutral**
and falls outside the scope of this repository.

Formal definition: `NeutralSubstrate.Separated`

## Invariants

The following invariants hold for all admissible, separated substrates,
independently of any regime applied above them:

- **Type stability**: `τ` does not change under structural operations
  that preserve node identity
- **Edge integrity**: every edge `(u, v) ∈ E` has `u, v ∈ N`
- **Acyclicity preservation**: structural operations defined at this
  layer do not introduce cycles

Formal definitions: `NeutralSubstrate.Invariants`

## Theorems

Machine-checked theorems established at this layer:

- **Admissibility is decidable**: given a finite structure, admissibility
  can be determined algorithmically
- **Separation is preserved under substrate operations**: operations
  defined here cannot introduce regime encoding
- **Invariants are stable**: all substrate invariants hold after any
  admissibility-preserving operation

Formal proofs: `NeutralSubstrate.Theorems`

## Witness

A minimal concrete witness demonstrating that the admissibility conditions
are satisfiable:

- A single-node structure `S₀ = ({n₀}, ∅, {n₀ ↦ t₀})` for any `t₀ ∈ T`
- Satisfies finiteness, type coverage, acyclicity, and non-emptiness
- Satisfies all separation constraints
- Establishes that the admissibility definition is non-vacuous

Formal definition: `NeutralSubstrate.Witness`

---

## Design Principles

### Neutrality

The substrate must not encode identity-regime behavior.

All regime semantics are external to this layer.

### Lean as Authority

All correctness is expressed and verified in Lean.

No external system defines or validates theory semantics.

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
