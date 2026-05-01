# Implementing 0.4.0: Interpretive Non-Commitment (INC)

> Approaching a breaking change to a core definition in Lean.

## Two Properties

The SE-100 paper defines neutrality as requiring two properties:

- **EXT** - Extension Stability: S remains consistent when extended
  by any admissible framework
- **INC** - Interpretive Non-Commitment: S does not assert any
  framework-variant proposition at the substrate layer

The current formalization defines:

```lean
def Neutral (S : Ontology) : Prop := ExtensionStable S
```

It encodes EXT only.
The paper's full neutrality requires:

```lean
def Neutral (S : Ontology) : Prop :=
  ExtensionStable S ∧ InterpretivelyNonCommitted S
```

## Breaking Change

Lean proofs are fragile under definition changes.
When `Neutral` acquires a second conjunct, every proof that unfolds
or destructs `Neutral` breaks because the goal shape changes.

Concretely, this tactic:

```lean
unfold Neutral ExtensionStable extensionInconsistent
```

currently exposes a single universally quantified proposition.
After 0.4.0 it exposes a conjunction.
Every proof using this pattern
must be updated to handle both conjuncts.

Affected proofs in Core.lean:

```text
neutral_if_only_neutral
not_neutral_if_causal_or_normative
ontological_neutrality_theorem
framework_contestability_lemma
separate_stability
```

Affected proofs in TestRegime.lean:

```lean
toySubstrate_is_neutral
incidentSubstrate_is_neutral
```

So 0.4.0 is a minor version bump, not a patch;
it requires coordinated updates across multiple files.

## Build Order

Make additive changes first, breaking changes last.
Keeps build green as long as possible during transition.

### Phase 1. Additive (no breakage)

```text
1. Define InterpretivelyNonCommitted in Core Section 2

   def InterpretivelyNonCommitted (S : Ontology) : Prop :=
     ∀ p ∈ S, ¬FrameworkVariant p

   WHY: Pure addition. Nothing depends on it yet.

2. Prove standalone lemma in Core Section 5

   theorem only_neutral_primitives_implies_INC :
     ∀ S, containsCausalOrNormative S = false →
     InterpretivelyNonCommitted S

   WHY: Establishes that INC follows from the same condition
   as the upper bound of the main theorem.

3. Add NS_ID_DEF_INTERPRETIVELY_NON_COMMITTED to Spec
4. Export InterpretivelyNonCommitted from Surface
5. Add #check to TestBasic
   Build and confirm green.
```

### Phase 2. Breaking (change Neutral, fix all downstream)

All of these are done in a single editing session.

```text
1. Update Neutral definition in Core Section 2

   def Neutral (S : Ontology) : Prop :=
     ExtensionStable S ∧ InterpretivelyNonCommitted S

   Build will temporarily fail on steps 7-12 below.

2. Update `neutral_if_only_neutral`
   Establish both ExtensionStable and InterpretivelyNonCommitted.
   The INC direction uses only_neutral_primitives_implies_INC (from step 2).
   The EXT direction is unchanged.

3. Update `not_neutral_if_causal_or_normative`
   Goal shape changes. May need to extract EXT conjunct explicitly.
   Check whether proof closes or needs adjustment.

4. Update `ontological_neutrality_theorem`
   Both directions affected. Rebuild from updated helper theorems.

5.  Update `framework_contestability_lemma`
    Add INC violation as second conclusion.
    Remove "deferred" note from doc comment.

6.  Update `separate_stability`
    Uses Neutral - check whether proof closes.
    Likely minor adjustment.

7.  Update `TestRegime` proofs
    `toySubstrate_is_neutral` and `incidentSubstrate_is_neutral`
    both call `neutral_if_only_neutral`. If that proof
    strategy changes, these may need updating.

    Build green before committing.
```

## The INC Proof Question

The key question for Phase 2 is whether the INC direction of the
updated `neutral_if_only_neutral` requires a new axiom.

The claim to prove is:

```text
containsCausalOrNormative S = false →
InterpretivelyNonCommitted S
```

Which unfolds to:

```lean
containsCausalOrNormative S = false →
∀ p ∈ S, ¬FrameworkVariant p
```

Which unfolds to:

```lean
containsCausalOrNormative S = false →
∀ p ∈ S, ¬∃ F1 F2, Admissible F1 ∧ Admissible F2 ∧
  F1.affirms p = true ∧ F2.denies p = true
```

For p ∈ S where containsCausalOrNormative S = false, we know p.kind = neutral.
We need to show no admissible framework denies a neutral primitive
(from neutral_primitives_undisputed) AND no admissible framework affirms
a neutral primitive in a way that creates variance.

The denial half follows from neutral_primitives_undisputed.
The affirmation half is not currently axiomatized.

This means Phase 2 may require a new axiom:

```lean
axiom neutral_primitives_not_affirmed_as_variant :
  ∀ p : Primitive, p.kind = PrimitiveKind.neutral →
  ∀ F : Framework, Admissible F → F.affirms p = false
```

Or FrameworkVariant can be weakened to only require
the denial direction, making it provably false for neutral primitives
using neutral_primitives_undisputed alone.
Attempt proof without a new axiom first.
Add axiom if proof does not close.

## No Changes in 0.4.0

```text
Spec IDs for existing theorems: stable, no rename
Surface exports for existing names: stable, additive only
NeutralSubstrate.lean §1-§4: structure unchanged
TestBasic type checks for existing names: stable
CITATION.cff, lakefile.toml: version bump only
```

## Definition of Done for 0.4.0

```text
DONE lake build        - 0 errors
DONE lake build TestBasic - all #check entries pass
DONE lake build TestRegime- incident example still proves separate_stability
DONE Neutral defined as EXT ∧ INC
DONE framework_contestability_lemma proves both violations
DONE "deferred to 0.4.0" note removed from all doc comments
DONE NeutralSubstrate.lean Section 2 updated with InterpretivelyNonCommitted
DONE CHANGELOG.md 0.4.0 section added
DONE CITATION.cff and lakefile.toml bumped to 0.4.0
```
