import NeutralSubstrate


/-!
File: test/TestBasic.lean

Notes:

- Verifies all public names are reachable via the top-level import.
- Reproduces the Part 8 examples from Core as regression tests.
- If Core changes in a way that breaks these, the build fails here.
- Does not import Core directly: uses only `import NeutralSubstrate`.
-/

open SE.NeutralSubstrate


-- ============================================================
-- SECTION 1: TYPE CHECKS
-- ============================================================

-- REQ.TEST.BASIC.TYPES
--   All normative public names resolve after open.

#check @PrimitiveKind
#check @Primitive
#check @Ontology
#check @Framework
#check @Admissible
#check @Neutral
#check @ExtensionStable
#check @containsCausalOrNormative
#check @extensionInconsistent
#check @FrameworkVariant
#check @FrameworksContradict
#check @InterpretivelyNonCommitted
#check @framework_relativity
#check @neutral_primitives_undisputed
#check @causal_normative_affirmed
#check @not_neutral_if_causal_or_normative
#check @neutral_if_only_neutral
#check @ontological_neutrality_theorem
#check @framework_contestability_lemma
#check @separate_stability


-- ============================================================
-- SECTION 2: THEOREM SIGNATURES
-- ============================================================

-- REQ.TEST.BASIC.SIGNATURES
--   Confirm expected types of all main theorems.

#check @not_neutral_if_causal_or_normative
-- ∀ (S : Ontology), containsCausalOrNormative S = true → ¬Neutral S

#check @neutral_if_only_neutral
-- ∀ (S : Ontology), containsCausalOrNormative S = false → Neutral S

#check @ontological_neutrality_theorem
-- ∀ (S : Ontology), Neutral S ↔ containsCausalOrNormative S = false

#check @framework_contestability_lemma
-- ∀ (p : Primitive), FrameworkVariant p → ∀ (S : Ontology), p ∈ S → ¬Neutral S

#check @only_neutral_primitives_implies_INC
-- ∀ (S : Ontology), containsCausalOrNormative S = false →
--   InterpretivelyNonCommitted S

#check @separate_stability
-- ∀ (S : Ontology), Neutral S → ∀ (F1 F2 : Framework),
--   Admissible F1 → Admissible F2 → FrameworksContradict F1 F2 →
--   ¬extensionInconsistent S F1 ∧ ¬extensionInconsistent S F2


-- ============================================================
-- SECTION 3: CONCRETE EXAMPLES
-- ============================================================

-- REQ.TEST.BASIC.EXAMPLES
--   Regression tests for the Part 8 verification suite.
--   These catch definition changes that alter computational behavior.

-- An empty ontology is neutral.
example : Neutral [] := by
  apply neutral_if_only_neutral; rfl

-- An ontology with only neutral primitives is neutral.
example : Neutral [⟨.neutral, "entity_A"⟩, ⟨.neutral, "entity_B"⟩] := by
  apply neutral_if_only_neutral; native_decide

-- An ontology with a causal primitive is not neutral.
example : ¬Neutral [⟨.causal, "A_caused_B"⟩] := by
  apply not_neutral_if_causal_or_normative; native_decide

-- An ontology with a normative primitive is not neutral.
example : ¬Neutral [⟨.normative, "X_obligated_to_Y"⟩] := by
  apply not_neutral_if_causal_or_normative; native_decide

-- Mixing neutral and causal primitives is not neutral.
example : ¬Neutral [⟨.neutral, "entity_E"⟩, ⟨.causal, "A_caused_B"⟩] := by
  apply not_neutral_if_causal_or_normative; native_decide

-- A framework-variant primitive makes any substrate containing it non-neutral.
-- Uses causal_normative_affirmed + framework_relativity to construct the witness.
example : ¬Neutral [⟨.causal, "A_caused_B"⟩] := by
  apply framework_contestability_lemma ⟨.causal, "A_caused_B"⟩
  · obtain ⟨F2, hF2_adm, hF2_denies⟩ :=
      framework_relativity ⟨.causal, "A_caused_B"⟩ (by decide)
    obtain ⟨F1, hF1_adm, hF1_affirms⟩ :=
      causal_normative_affirmed ⟨.causal, "A_caused_B"⟩ (by decide)
    exact ⟨F1, F2, hF1_adm, hF2_adm, hF1_affirms, hF2_denies⟩
  · simp [List.mem_cons]


-- ============================================================
-- SECTION 4: SPEC CITATION IDs
-- ============================================================

-- REQ.TEST.BASIC.SPEC
--   Confirm all citation IDs are reachable via the Spec namespace.

open SE.NeutralSubstrate.Spec in
#check NS_ID_TYPE_PRIMITIVE_KIND
open SE.NeutralSubstrate.Spec in
#check NS_ID_TYPE_PRIMITIVE
open SE.NeutralSubstrate.Spec in
#check NS_ID_TYPE_ONTOLOGY
open SE.NeutralSubstrate.Spec in
#check NS_ID_TYPE_FRAMEWORK
open SE.NeutralSubstrate.Spec in
#check NS_ID_DEF_NEUTRAL
open SE.NeutralSubstrate.Spec in
#check NS_ID_DEF_ADMISSIBLE
open SE.NeutralSubstrate.Spec in
#check NS_ID_DEF_FRAMEWORK_VARIANT
open SE.NeutralSubstrate.Spec in
#check NS_ID_DEF_FRAMEWORKS_CONTRADICT
open SE.NeutralSubstrate.Spec in
#check NS_ID_DEF_INTERPRETIVELY_NON_COMMITTED
open SE.NeutralSubstrate.Spec in
#check NS_ID_AXIOM_FRAMEWORK_RELATIVITY
open SE.NeutralSubstrate.Spec in
#check NS_ID_AXIOM_NEUTRAL_PRIMITIVES_UNDISPUTED
open SE.NeutralSubstrate.Spec in
#check NS_ID_AXIOM_CAUSAL_NORMATIVE_AFFIRMED
open SE.NeutralSubstrate.Spec in
#check NS_ID_THEOREM_ONTOLOGICAL_NEUTRALITY
open SE.NeutralSubstrate.Spec in
#check NS_ID_THEOREM_NOT_NEUTRAL_IF_CAUSAL_OR_NORMATIVE
open SE.NeutralSubstrate.Spec in
#check NS_ID_THEOREM_NEUTRAL_IF_ONLY_NEUTRAL
open SE.NeutralSubstrate.Spec in
#check NS_ID_THEOREM_LOWER_BOUND_ONLY
open SE.NeutralSubstrate.Spec in
#check NS_ID_THEOREM_FRAMEWORK_CONTESTABILITY
open SE.NeutralSubstrate.Spec in
#check NS_ID_THEOREM_SEPARATE_STABILITY
open SE.NeutralSubstrate.Spec in
#check NS_ID_THEOREM_ONLY_NEUTRAL_IMPLIES_INC
