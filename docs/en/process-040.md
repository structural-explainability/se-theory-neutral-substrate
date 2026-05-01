# Implementing 0.4.0: Interpretive Non-Commitment (INC)

> Approaching a breaking change to a core definition in Lean.

## Two Properties

The SE-100 paper defines neutrality as requiring two properties:

- **EXT** Extension Stability: S remains consistent when extended
  by any admissible framework
- **INC** Interpretive Non-Commitment: S does not assert any
  framework-variant proposition at the substrate layer

The 0.3.0 formalization encoded EXT only:

```lean
def Neutral (S : Ontology) : Prop := ExtensionStable S
```

The 0.4.0 formalization encodes both:

```lean
def Neutral (S : Ontology) : Prop :=
  ExtensionStable S ∧ InterpretivelyNonCommitted S
```

## Why This Is a Breaking Change

Lean proofs are fragile under definition changes.
When `Neutral` acquires a second conjunct, every proof that unfolds
or destructs `Neutral` breaks because the goal shape changes.

Concretely, this tactic:

```lean
unfold Neutral ExtensionStable extensionInconsistent
```

previously exposed a single universally quantified proposition.
After 0.4.0 it exposes a conjunction.
Every proof using this pattern required updating to handle both conjuncts.

Affected proofs in `Core.lean`:

```text
neutral_if_only_neutral
not_neutral_if_causal_or_normative
ontological_neutrality_theorem
framework_contestability_lemma
separate_stability
```

Affected proofs in `TestRegime.lean`:

```text
toySubstrate_is_neutral
incidentSubstrate_is_neutral
```

This is why 0.4.0 is a minor version bump, not a patch.

## Build Order

Additive changes first, breaking changes last.
This kept the build green as long as possible during transition.

### Phase 1. Additive (no breakage)

```text
1. Define InterpretivelyNonCommitted in Core Section 2

   def InterpretivelyNonCommitted (S : Ontology) : Prop :=
     ∀ p ∈ S, ¬FrameworkVariant p

   WHY: Pure addition. Nothing depends on it yet.
   Build stayed green after this step.

2. Prove standalone lemma in Core Section 5

   theorem only_neutral_primitives_implies_INC :
     ∀ S, containsCausalOrNormative S = false →
     InterpretivelyNonCommitted S

   WHY: Established that INC follows from neutral_primitives_undisputed
   alone. Answered the open question: no new axiom needed for Phase 2.

3. Added NS_ID_DEF_INTERPRETIVELY_NON_COMMITTED to Spec
4. Exported InterpretivelyNonCommitted from Surface
5. Added #check to TestBasic
   Build confirmed green before Phase 2.
```

### Phase 2. Breaking (change Neutral, fix all downstream)

All changes made in a single editing session.
Build not committed until fully green.

```text
1. Updated Neutral definition in Core Section 2
   def Neutral (S : Ontology) : Prop :=
     ExtensionStable S ∧ InterpretivelyNonCommitted S

2. Updated neutral_if_only_neutral
   constructor splits into EXT and INC conjuncts.
   INC direction: exact only_neutral_primitives_implies_INC S h_only_neutral
   EXT direction: unchanged from 0.3.0.

3. Updated not_neutral_if_causal_or_normative
   Extracted h_neutral.1 (EXT conjunct) before proceeding.
   INC conjunct never needed for this direction.

4. Updated ontological_neutrality_theorem
   No change to proof body; forward and backward still delegate
   to not_neutral_if_causal_or_normative and neutral_if_only_neutral.

5. Updated framework_contestability_lemma
   Now uses INC directly: h_neutral.2 p hp_in_S h_variant
   Both EXT and INC violations documented.
   "deferred to 0.4.0" note removed.

6. Updated separate_stability
   Uses h_neutral.1 to extract EXT before applying to F1 and F2.

7. TestRegime proofs closed without changes.
   neutral_if_only_neutral signature unchanged; proofs still apply.
```

## The INC Proof Question Resolved

The key question for Phase 2 was whether the INC direction of the
updated `neutral_if_only_neutral` required a new axiom.

**Answer: no new axiom needed.**

The proof of `only_neutral_primitives_implies_INC` only needs to
negate the denial half of `FrameworkVariant`:

```lean
FrameworkVariant p :=
  ∃ F1 F2, Admissible F1 ∧ Admissible F2 ∧
    F1.affirms p = true ∧ F2.denies p = true
```

To prove `¬FrameworkVariant p` for a neutral primitive, it suffices
to show no admissible F2 can satisfy `F2.denies p = true`.
This follows directly from `neutral_primitives_undisputed`.
The affirmation half (`F1.affirms p`) is never consulted.

The proof:

```lean
theorem only_neutral_primitives_implies_INC :
    ∀ S : Ontology, containsCausalOrNormative S = false →
    InterpretivelyNonCommitted S := by
  intro S h_only_neutral
  unfold InterpretivelyNonCommitted FrameworkVariant
  intro p hp_in_S
  intro ⟨_F1, F2, _hF1_adm, hF2_adm, _hF1_affirms, hF2_denies⟩
  have h_all_neutral := any_false_implies_none S _ h_only_neutral
  have hp_neutral_kind : (p.kind != PrimitiveKind.neutral) = false :=
    h_all_neutral p hp_in_S
  simp at hp_neutral_kind
  have h_not_denied := neutral_primitives_undisputed p hp_neutral_kind F2 hF2_adm
  rw [h_not_denied] at hF2_denies
  contradiction
```

## Definition of Done for 0.4.0

```text
DONE  lake build                 0 errors
DONE  lake build TestBasic       all #check entries pass
DONE  lake build TestRegime      incident example still proves separate_stability
DONE  Neutral defined as EXT ∧ INC
DONE  framework_contestability_lemma proves both EXT and INC violations
DONE  "deferred to 0.4.0" note removed from all doc comments
DONE  NeutralSubstrate.lean Section 2 updated with InterpretivelyNonCommitted
DONE  CHANGELOG.md 0.4.0 section added
DONE  CITATION.cff and lakefile.toml bumped to 0.4.0
```
