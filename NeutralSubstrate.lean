import NeutralSubstrate.Core
import NeutralSubstrate.Spec
import NeutralSubstrate.Surface

/-!
# Neutral Substrate (NS)

Lean 4 formalization of the Neutral Substrate specification from
Structural Explainability (SE) theory.
Defines the necessary and sufficient conditions for
ontological neutrality under durable interpretive disagreement.

## 1.  Scope (Informative)

Applies to substrates optimized for stability across disagreeing
interpretive frameworks.
Does not apply to substrates optimized for other objectives.

This library does not encode identity regimes, persistence behavior,
domain semantics, or operational validation.

## 2.  Public Surface (Normative)

The following names constitute the normative public surface of this library.
They are stable across patch versions.
Breaking changes require a minor version increment.
Names in `NeutralSubstrate.Core` not listed here are
internal and may change without notice.

### 2.1.  Types

- `PrimitiveKind`  the three primitive classifications
- `Primitive`      basic unit of ontological commitment
- `Ontology`       a finite list of primitives
- `Framework`      an interpretive stance over primitives

### 2.2.  Predicates

- `Neutral`                   extension stability holds
- `Admissible`                framework is internally consistent
- `ExtensionStable`           no admissible framework causes inconsistency
- `containsCausalOrNormative` boolean test for non-neutral content
- `extensionInconsistent`     a framework denies a substrate primitive
- `FrameworkVariant`          admissible frameworks disagree about a primitive
- `FrameworksContradict`      one framework affirms what another denies

### 2.3.  Axioms

- `framework_relativity`          causal/normative primitives are contested
- `neutral_primitives_undisputed` neutral primitives are framework-invariant
- `causal_normative_affirmed`     causal/normative primitives are affirmed

### 2.4  Theorems

- `ontological_neutrality_theorem`     main biconditional result
- `not_neutral_if_causal_or_normative` only-if direction
- `neutral_if_only_neutral`            if direction
- `framework_contestability_lemma`     framework-variant primitives cannot appear in NS
- `separate_stability`                 an NS is separately consistent with each of two mutually
                                         contradicting frameworks

### 2.5.  Asymmetry Note (Normative)

The two directions of `ontological_neutrality_theorem` have different
epistemic status and different axiom dependencies.

The lower bound (`not_neutral_if_causal_or_normative`) follows from
`framework_relativity` alone.
It holds structurally in any domain where causal and normative
primitives are contested across admissible frameworks.

The upper bound (`neutral_if_only_neutral`) additionally requires
`neutral_primitives_undisputed`.
It holds only in domains where identity conditions are not themselves contested.
In domains where identity is contested, only the lower bound applies.
Cite `NS.THEOREM.LOWER_BOUND_ONLY` when documenting this restriction.

## 3.  Usage (Informative)

```lean
import NeutralSubstrate
open SE.NeutralSubstrate        -- types, predicates, axioms, theorems
open SE.NeutralSubstrate.Spec   -- citation IDs (optional)
```

## 4.  Metadata (Informative)

Version, authorship, and release date: see `CITATION.cff`.
Scope, layer, and governance: see `SE_MANIFEST.toml`.

## 5.  File Notes (Informative)

- This file must remain thin: imports only, no logic.
- Downstream regime libraries depend on this file as their sole NS import.
- Internal structure (Core, Spec, Surface) is not part of the public contract.
-/
