# Conversion from Paper to Lean

> General process of how the NS paper was encoded into a Lean project.

## Step 1. Concept Mapping

Read the associated academic paper and
extract every noun that has a technical definition.

For the NS paper, that includes:

- Primitive (and its kinds: neutral, causal, normative)
- Framework / interpretive stance
- Admissibility
- Extension / extending a substrate with a framework
- Consistency / inconsistency under extension
- Neutrality
- Framework-variance
- FrameworksContradict
- Identity regime (downstream, not in NS itself)

Then consider dependencies:

```text
PrimitiveKind (depends on nothing)
Primitive (depends on PrimitiveKind)
Ontology (depends on Primitive)

Framework (depends on Primitive)
  └── Admissible (depends on Framework)
  └── extensionInconsistent (depends on Ontology + Framework)
      └── ExtensionStable (depends on extensionInconsistent)

FrameworkVariant (depends on Primitive + Framework + Admissible)
  └── InterpretivelyNonCommitted (depends on FrameworkVariant + Ontology)
      └── Neutral (depends on ExtensionStable + InterpretivelyNonCommitted)

FrameworksContradict (depends on Framework)

framework_contestability_lemma (depends on FrameworkVariant + Neutral)
separate_stability (depends on Neutral + FrameworksContradict)
ontological_neutrality_theorem (depends on everything above)
```

This graph is the file structure.
Each layer depends only on layers above it.

## Step 2. Decide What Kind of Thing Each Concept Is

Lean 4 provides several tools. Choosing wrong creates pain:

| Lean construct | Use when                                                        |
| -------------- | --------------------------------------------------------------- |
| `structure`    | A data-carrying type (a thing that has fields)                  |
| `inductive`    | A type with distinct cases / finite alternatives                |
| `class`        | A property you want to infer automatically via typeclass search |
| `def`          | A computable function or a named proposition                    |
| `abbrev`       | A transparent alias (Lean unfolds it eagerly)                   |
| `axiom`        | A claim you assert without proof (use sparingly, document why)  |

For NS specifically:

- `PrimitiveKind` — `inductive` (three cases: neutral, causal, normative)
- `Primitive` — `structure` (carries a kind and an id)
- `Ontology` — `abbrev` (transparent alias for `List Primitive`)
- `Framework` — `structure` (carries affirms/denies functions + consistency proof)
- `Admissible` — `def` (see decision below)

**The Admissible decision:**

The `class` approach is elegant when you have a few canonical objects
and want to write `[Admissible F]` in theorem signatures.
It becomes awkward when you need to existentially quantify
over all admissible frameworks, as neutrality requires,
because typeclass search does not enumerate.

The `def` approach is more flexible for neutrality proofs.
Writing `∀ F, Admissible F → ...` is straightforward to work with.

**Decision:** `def Admissible` for frameworks (needed for universal quantification).
Use `class` only for substrate-level properties with fixed concrete instances.

## Step 3. Build Order Within the File

The dependency graph determines the order within `Core.lean`:

```text
Section 1: Types
  PrimitiveKind, Primitive, Ontology, Framework

Section 2: Predicates
  Admissible, containsCausalOrNormative, extensionInconsistent,
  ExtensionStable, FrameworkVariant, InterpretivelyNonCommitted,
  Neutral, FrameworksContradict

Section 3: Axioms
  framework_relativity, neutral_primitives_undisputed,
  causal_normative_affirmed

Section 4: Helper Lemmas
  any_true_implies_exists, any_false_implies_none

Section 5: Theorems
  only_neutral_primitives_implies_INC,
  not_neutral_if_causal_or_normative, neutral_if_only_neutral,
  ontological_neutrality_theorem, framework_contestability_lemma,
  separate_stability

Section 6: Verification
  #check entries, concrete examples
```

Never define something after it is used.
Never start the next section until the current section compiles.

## Step 4. Axiom Discipline

Axioms encode domain assumptions Lean cannot verify.
Each axiom requires documentation of three things:

1. **WHY** — what empirical claim it encodes
2. **SCOPE** — in what domains it fails
3. **ROLE** — which theorems depend on it and how

The NS axioms and their roles:

| Axiom                           | Role                                                               |
| ------------------------------- | ------------------------------------------------------------------ |
| `framework_relativity`          | Required for lower bound only                                      |
| `neutral_primitives_undisputed` | Required for upper bound; fails when identity is contested         |
| `causal_normative_affirmed`     | Required to instantiate `FrameworkVariant` for concrete primitives |

The lower bound (`not_neutral_if_causal_or_normative`) requires only
`framework_relativity` and holds structurally in any domain where
causal and normative primitives are contested.

The upper bound (`neutral_if_only_neutral`) additionally requires
`neutral_primitives_undisputed` and holds only in domains where
identity conditions are not themselves contested.

In domains where only the lower bound applies,
cite `NS.THEOREM.LOWER_BOUND_ONLY`.

## Step 5. Consider Audience and API

NS has three audiences:

```text
INTERNAL         │  EXTERNAL SURFACE      │  DOWNSTREAM
                 │                        │
Core math        │  What NS publishes     │  Regime theory
Axioms           │  What regimes see      │  Civic tools
Helper lemmas    │  and depend on         │  Other SE papers
Proof details    │                        │
```

The external surface is the contract. Regimes write:

```lean
import NeutralSubstrate
open SE.NeutralSubstrate
-- done, everything on the surface available
```

Three files implement this separation:

- `Core.lean` — all definitions, axioms, proofs (internal)
- `Spec.lean` — stable string citation IDs of the form `NS.{KIND}.{NAME}`
- `Surface.lean` — explicit `export` statements; curated stable surface

`Surface.lean` controls exactly which names cross the boundary.
Names not listed there are internal and may change without notice.
String IDs in `Spec.lean` are stable across all Core refactors —
the ID is the contract, the theorem is the implementation.

## Step 6. Build Loop

For each file, in this order:

1. Write types and definitions with `sorry` for proof fields
2. Confirm the file typechecks (`lake build`)
3. Fill in proofs
4. Only then move to the next file

Never start the next file until the current file compiles.
This is the discipline that keeps formalizations stable.
