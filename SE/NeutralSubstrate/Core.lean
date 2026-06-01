-- ============================================================
-- NeutralSubstrate/Core.lean
-- ============================================================

-- REQ.FILE.CORE
--   All mathematical content for the Neutral Substrate library.
--   Types, predicates, axioms, helper lemmas, and theorems.
--   Nothing is exported from this file directly.
--   Downstream consumers import via NeutralSubstrate.Surface.

-- WHY: Isolating all math here means Surface.lean controls
--   exactly what is visible to regime authors. Core can be
--   refactored without breaking the public surface.

namespace SE.NeutralSubstrate


-- ============================================================
-- SECTION 1: TYPES
-- ============================================================

-- REQ.CORE.TYPES
--   Basic vocabulary. No dependencies outside this section.

/-- The three mutually exclusive kinds a primitive may have.

    - `causal`   : asserts a causal relation (e.g., "A caused B")
    - `normative`: asserts a normative conclusion (e.g., "X was obligated")
    - `neutral`  : asserts only existence or identity (e.g., "entity E exists")

    The trichotomy is exhaustive for this domain.
    Every primitive is classifiable as exactly one of these. -/
inductive PrimitiveKind where
  | causal
  | normative
  | neutral
  deriving DecidableEq, Repr

/-- A primitive: the basic unit of ontological commitment.

    - `kind` : classifies the primitive as causal, normative, or neutral
    - `id`   : placeholder identifier; a richer model could carry structure

    `DecidableEq` enables computational equality checks.
    `Repr` enables printing for debugging. -/
structure Primitive where
  kind : PrimitiveKind
  id   : String
  deriving DecidableEq, Repr

/-- An ontology is a finite list of primitives.

    WHY List not Set: List is computable. `#eval` and `native_decide`
    require decidable membership, which List provides directly.
    For finite collections the two representations are equivalent. -/
abbrev Ontology := List Primitive

/-- A framework assigns truth values to primitives.

    - `affirms`   : primitives the framework asserts as true
    - `denies`    : primitives the framework asserts as false
    - `consistent`: a framework cannot both affirm and deny the same primitive

    A framework may be silent on a primitive (neither affirms nor denies).
    Admissible frameworks may contradict each other; each is only required
    to be internally consistent. -/
structure Framework where
  affirms    : Primitive → Bool
  denies     : Primitive → Bool
  consistent : ∀ p, ¬(affirms p = true ∧ denies p = true)


-- ============================================================
-- SECTION 2: PREDICATES
-- ============================================================

-- REQ.CORE.PREDICATES
--   The core properties reasoned about in the theorems.

/-- A framework is admissible if it represents a legitimate interpretive stance.

    All internally consistent frameworks are admissible.
    Admissibility is not universality: admissible frameworks may contradict
    one another, as when two jurisdictions reach opposite legal conclusions.
    The set of admissible frameworks is characterized by internal consistency,
    not mutual compatibility.

    ALT: A richer model could add domain-specific admissibility conditions
    (e.g., recognized jurisdiction, established causal methodology).
    This definition is intentionally minimal. -/
def Admissible (_ : Framework) : Prop := True

/-- Does an ontology contain any causal or normative primitive?

    Returns `true` if any primitive has `kind ≠ neutral`.
    This is the boolean function the main theorem is stated over. -/
def containsCausalOrNormative (S : Ontology) : Bool :=
  S.any fun p => p.kind != PrimitiveKind.neutral

/-- Extension is inconsistent when a framework denies a primitive the substrate contains.

    This models the conflict arising when an interpretive framework
    contradicts a substrate-level commitment. -/
def extensionInconsistent (S : Ontology) (F : Framework) : Prop :=
  ∃ p, p ∈ S ∧ F.denies p = true

/-- Extension stability: no admissible framework causes inconsistency.

    For all admissible frameworks F, extending S with F produces no contradiction.
    This captures the requirement that the substrate survives interpretive disagreement. -/
def ExtensionStable (S : Ontology) : Prop :=
  ∀ F : Framework, Admissible F → ¬extensionInconsistent S F

/-- A primitive is framework-variant if admissible frameworks disagree about it:
    some affirm it, some deny it.

    This captures the paper's claim that causal and normative propositions
    have truth conditions determined by interpretive frameworks rather than
    by framework-invariant referential structure.

    WHY: Framework-variance is the structural property that makes a primitive
    unsafe to embed at the substrate layer. If p is framework-variant, then
    any substrate asserting p will be inconsistent with some admissible framework. -/
def FrameworkVariant (p : Primitive) : Prop :=
  ∃ F1 F2 : Framework, Admissible F1 ∧ Admissible F2 ∧
    F1.affirms p = true ∧ F2.denies p = true

/-- Interpretive non-commitment: no primitive in the substrate is framework-variant.

    A substrate satisfies INC when every primitive it contains has truth
    conditions that are framework-invariant: no admissible framework
    affirms it while another denies it.

    WHY: INC is the second neutrality requirement from Case (2025) alongside
    EXT (extension stability). Together they constitute full neutrality.
    A substrate satisfying INC makes no interpretive commitments at the
    foundational layer: it does not assert propositions whose truth depends
    on the conclusions of any particular interpretive framework.

    OBS: For substrates where containsCausalOrNormative S = false,
    INC follows from neutral_primitives_undisputed alone.
    See only_neutral_primitives_implies_INC.
    No additional axiom is required. -/
def InterpretivelyNonCommitted (S : Ontology) : Prop :=
  ∀ p ∈ S, ¬FrameworkVariant p

/-- Neutrality is extension stability and interpretive non-commitment.

    An ontology is neutral iff it can be extended by any admissible framework
    without revision or contradiction (EXT), and it does not assert any
    framework-variant proposition at the substrate layer (INC).

    WHY: Both requirements are necessary. EXT alone is sufficient for the
    lower bound but the full paper theorem requires INC alongside EXT.
    See ontological_neutrality_theorem for the biconditional result. -/
def Neutral (S : Ontology) : Prop :=
  ExtensionStable S ∧ InterpretivelyNonCommitted S

/-- Two frameworks mutually contradict when one affirms what the other denies.

    Note: mutual contradiction does not affect admissibility.
    Each framework may be internally consistent while contradicting the other.
    The set of admissible frameworks is characterized by internal consistency,
    not mutual compatibility.

    OBS: This is the structural condition instantiated in the incident example:
    F1 (engineering) and F2 (legal) contradict each other over Responsible(a,e)
    while each remains separately consistent with the neutral substrate. -/
def FrameworksContradict (F1 F2 : Framework) : Prop :=
  ∃ p : Primitive, F1.affirms p = true ∧ F2.denies p = true


-- ============================================================
-- SECTION 3: AXIOMS
-- ============================================================

-- REQ.CORE.AXIOMS
--   Domain assumptions Lean cannot verify.
--   These encode empirical claims about the modeled domain.
--   The main theorem holds only when these axioms hold in the domain.
--   Axiom validity is a domain question, not a logical question.

/-- AXIOM: Framework Relativity

    Causal and normative primitives are framework-dependent.
    For any non-neutral primitive, some admissible framework denies it.

    WHY: Causal and normative conclusions are inherently contested
    across interpretive frameworks. "A caused B" may be denied by
    frameworks using different causal models. "X was obligated" may
    be denied by frameworks in different jurisdictions.

    SCOPE: In domains where causal or normative consensus exists,
    this axiom fails and the theorem does not apply.

    NOTE: This axiom is sufficient for the lower bound
    (not_neutral_if_causal_or_normative). It does not establish
    the upper bound. -/
axiom framework_relativity :
    ∀ p : Primitive, p.kind ≠ PrimitiveKind.neutral →
    ∃ F : Framework, Admissible F ∧ F.denies p = true

/-- AXIOM: Neutral Primitives Undisputed

    Neutral primitives are not denied by any admissible framework.
    Pure existence and identity claims are framework-invariant.

    WHY: While frameworks disagree about causation and obligation,
    they do not disagree about whether entities exist, given fixed
    identity criteria.

    SCOPE: In domains where identity itself is contested, this axiom
    fails and the theorem does not apply.

    WARNING: This axiom establishes the upper bound of the main theorem.
    The lower bound (not_neutral_if_causal_or_normative) does not
    require this axiom and holds from framework_relativity alone.
    The biconditional (ontological_neutrality_theorem) holds only
    in domains where both axioms are satisfied.
    In domains where identity conditions are contested, only the
    lower bound applies. -/
axiom neutral_primitives_undisputed :
    ∀ p : Primitive, p.kind = PrimitiveKind.neutral →
    ∀ F : Framework, Admissible F → F.denies p = false

/-- AXIOM: Causal and Normative Primitives Are Affirmed

    For any non-neutral primitive, some admissible framework affirms it.

    WHY: This is the companion to framework_relativity. Together they
    establish that causal and normative primitives are genuinely
    framework-variant: some frameworks affirm them (this axiom) and
    some deny them (framework_relativity).

    Without this axiom, FrameworkVariant cannot be instantiated for
    any concrete primitive, and framework_contestability_lemma cannot
    be applied to specific cases. -/
axiom causal_normative_affirmed :
    ∀ p : Primitive, p.kind ≠ PrimitiveKind.neutral →
    ∃ F : Framework, Admissible F ∧ F.affirms p = true


-- ============================================================
-- SECTION 4: HELPER LEMMAS
-- ============================================================

-- REQ.CORE.HELPERS
--   Technical machinery connecting boolean List.any to Prop.
--   These are not part of the paper's argument.
--   They are needed because the main predicates use Bool computation.

/-- If `List.any` returns true, a witness exists satisfying the predicate. -/
theorem any_true_implies_exists {α : Type} (l : List α) (pred : α → Bool) :
    l.any pred = true → ∃ x, x ∈ l ∧ pred x = true := by
  intro h
  induction l with
  | nil => simp [List.any] at h
  | cons head tail ih =>
    simp only [List.any, Bool.or_eq_true] at h
    match h with
    | Or.inl h_head =>
      exact ⟨head, List.Mem.head tail, h_head⟩
    | Or.inr h_tail =>
      have ⟨x, hx_mem, hx_pred⟩ := ih h_tail
      exact ⟨x, List.Mem.tail head hx_mem, hx_pred⟩

/-- If `List.any` returns false, no element satisfies the predicate. -/
theorem any_false_implies_none {α : Type} (l : List α) (pred : α → Bool) :
    l.any pred = false → ∀ x, x ∈ l → pred x = false := by
  intro h x hx
  induction l with
  | nil => cases hx
  | cons head tail ih =>
    simp only [List.any, Bool.or_eq_false_iff] at h
    cases hx with
    | head => exact h.1
    | tail _ hx_tail => exact ih h.2 hx_tail


-- ============================================================
-- SECTION 5: THEOREMS
-- ============================================================

-- REQ.CORE.THEOREMS
--   The main results. Each theorem cites its proof strategy.

/-- THEOREM: Only-neutral substrate satisfies INC.

    If an ontology contains only neutral primitives, it satisfies
    interpretive non-commitment.

    WHY: Establishes that INC follows from neutral_primitives_undisputed
    alone, without requiring a new axiom. Used as a helper in the
    updated neutral_if_only_neutral proof.

    Proof strategy:
    1. Take any p ∈ S and assume FrameworkVariant p for contradiction
    2. Extract F2 from FrameworkVariant, the framework that denies p
    3. any_false_implies_none shows p.kind = neutral
    4. neutral_primitives_undisputed shows F2 cannot deny p
    5. Contradiction with F2.denies p = true -/
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

/-- THEOREM: If an ontology contains causal or normative primitives, it is not neutral.

    This is the lower bound of the main theorem.
    It follows from framework_relativity alone.
    It holds in any domain where causal and normative primitives
    are contested across admissible frameworks.

    Proof strategy:
    1. Assume neutrality (EXT ∧ INC) for contradiction
    2. Extract EXT conjunct from h_neutral
    3. Extract witness primitive p via any_true_implies_exists
    4. Show p.kind ≠ neutral from the boolean witness
    5. Apply framework_relativity to get F that denies p
    6. EXT of S says F cannot cause inconsistency
    7. But p ∈ S and F.denies p = true is exactly inconsistency
    8. Contradiction -/
theorem not_neutral_if_causal_or_normative :
    ∀ S : Ontology, containsCausalOrNormative S = true → ¬Neutral S := by
  intro S h_contains h_neutral
  have h_ext := h_neutral.1
  have h_exists := any_true_implies_exists S _ h_contains
  match h_exists with
  | ⟨p, hp_in_S, hp_kind⟩ =>
    have hp_not_neutral : p.kind ≠ PrimitiveKind.neutral := by
      intro h_eq
      simp [h_eq] at hp_kind
    have ⟨F, hF_adm, hF_denies⟩ := framework_relativity p hp_not_neutral
    have h_no_inconsist := h_ext F hF_adm
    apply h_no_inconsist
    exact ⟨p, hp_in_S, hF_denies⟩

/-- THEOREM: If an ontology contains only neutral primitives, it is neutral.

    This is the upper bound of the main theorem.
    It additionally requires neutral_primitives_undisputed.
    It holds only in domains where identity conditions are not
    themselves contested across admissible frameworks.

    Proof strategy:
    1. Split Neutral into EXT ∧ INC and prove each conjunct
    2. EXT: unfold and proceed as before using neutral_primitives_undisputed
    3. INC: apply only_neutral_primitives_implies_INC directly -/
theorem neutral_if_only_neutral :
    ∀ S : Ontology, containsCausalOrNormative S = false → Neutral S := by
  intro S h_only_neutral
  constructor
  · -- EXT: extension stability
    unfold ExtensionStable extensionInconsistent
    intro F hF_adm
    intro ⟨p, hp_in_S, hF_denies⟩
    have h_all_neutral := any_false_implies_none S _ h_only_neutral
    have hp_neutral_kind : (p.kind != PrimitiveKind.neutral) = false :=
      h_all_neutral p hp_in_S
    simp at hp_neutral_kind
    have h_not_denied := neutral_primitives_undisputed p hp_neutral_kind F hF_adm
    rw [h_not_denied] at hF_denies
    contradiction
  · -- INC: interpretive non-commitment
    exact only_neutral_primitives_implies_INC S h_only_neutral

/-- THEOREM: Ontological Neutrality (biconditional)

    An ontology is neutral if and only if it contains no causal or normative primitives.

    This is the main result from Case (2025).
    It holds given framework_relativity and neutral_primitives_undisputed.
    Neutrality is now the full EXT ∧ INC conjunction.

    NOTE: The two directions have different epistemic status.
    - Only-if (lower bound): follows from framework_relativity alone.
      Holds structurally in any domain where causal and normative
      primitives are contested.
    - If (upper bound): additionally requires neutral_primitives_undisputed.
      Holds only in domains where identity conditions are not contested.
    The biconditional is valid only in domains where both axioms hold.
    In domains where identity conditions are contested, only the
    lower bound applies.

    Proof strategy:
    1. Split iff into two directions
    2. Forward: assume Neutral S, case split on containsCausalOrNormative S
       - true  : contradiction via not_neutral_if_causal_or_normative
       - false : that is the goal
    3. Backward: apply neutral_if_only_neutral directly -/
theorem ontological_neutrality_theorem :
    ∀ S : Ontology, Neutral S ↔ containsCausalOrNormative S = false := by
  intro S
  constructor
  · intro h_neutral
    cases h_eq : containsCausalOrNormative S with
    | true  => exact absurd h_neutral (not_neutral_if_causal_or_normative S h_eq)
    | false => rfl
  · exact neutral_if_only_neutral S

/-- THEOREM: Framework-Contestability Lemma

    If a primitive is framework-variant, no substrate containing it is neutral.

    Formalizes the paper's Framework-Contestability Lemma (Case 2025, Section 4.2):
    a proposition whose truth conditions depend on interpretive framework
    conclusions cannot be a substrate commitment without violating
    either EXT or INC.

    Both violations are now formalized:
    (1) EXT violated: F2 denies p, but p ∈ S, producing inconsistency
    (2) INC violated: p is framework-variant, but S contains p

    Proof strategy:
    1. Assume Neutral S (EXT ∧ INC) for contradiction
    2. EXT violation: extract h_ext, apply framework_relativity pattern
       via F2 from FrameworkVariant, construct extensionInconsistent
    3. INC violation: extract h_inc, apply to p and hp_in_S,
       apply h_variant directly for contradiction
    Note: either violation suffices; we use INC as it is most direct. -/
theorem framework_contestability_lemma :
    ∀ p : Primitive, FrameworkVariant p →
    ∀ S : Ontology, p ∈ S → ¬Neutral S := by
  intro p h_variant S hp_in_S h_neutral
  have h_inc := h_neutral.2
  exact h_inc p hp_in_S h_variant

/-- THEOREM: Separate Stability

    A neutral substrate is separately consistent with each of two mutually
    contradicting frameworks.

    Formalizes the paper's key observation (Case 2025, Section 4.1) that a neutral
    substrate need not reconcile contradicting frameworks. It must only
    avoid assertions that either framework rejects. The substrate's role
    is common-ground provision, not arbitration.

    NOTE: FrameworksContradict is not used in the proof body.
    The EXT conjunct of Neutral implies stability under ALL admissible
    frameworks, which subsumes the two-framework case. The hypothesis
    is retained for fidelity to the paper's framing.

    Proof strategy:
    Extract EXT conjunct from Neutral S.
    Apply twice, once for F1 and once for F2. -/
theorem separate_stability :
    ∀ S : Ontology, Neutral S →
    ∀ F1 F2 : Framework, Admissible F1 → Admissible F2 →
    FrameworksContradict F1 F2 →
    ¬extensionInconsistent S F1 ∧ ¬extensionInconsistent S F2 := by
  intro S h_neutral F1 F2 hF1_adm hF2_adm _h_contradict
  exact ⟨h_neutral.1 F1 hF1_adm, h_neutral.1 F2 hF2_adm⟩


-- ============================================================
-- SECTION 6: VERIFICATION
-- ============================================================

-- REQ.CORE.VERIFICATION
--   Type checks and concrete examples.
--   These produce no runtime effect.
--   They catch regressions if definitions change.

#check @not_neutral_if_causal_or_normative
-- ∀ (S : Ontology), containsCausalOrNormative S = true → ¬Neutral S

#check @neutral_if_only_neutral
-- ∀ (S : Ontology), containsCausalOrNormative S = false → Neutral S

#check @ontological_neutrality_theorem
-- ∀ (S : Ontology), Neutral S ↔ containsCausalOrNormative S = false

#check @FrameworkVariant
-- Primitive → Prop

#check @InterpretivelyNonCommitted
-- Ontology → Prop

#check @FrameworksContradict
-- Framework → Framework → Prop

#check @only_neutral_primitives_implies_INC
-- ∀ (S : Ontology), containsCausalOrNormative S = false →
--   InterpretivelyNonCommitted S

#check @framework_contestability_lemma
-- ∀ (p : Primitive), FrameworkVariant p → ∀ (S : Ontology), p ∈ S → ¬Neutral S

#check @separate_stability
-- ∀ (S : Ontology), Neutral S → ∀ (F1 F2 : Framework),
--   Admissible F1 → Admissible F2 → FrameworksContradict F1 F2 →
--   ¬extensionInconsistent S F1 ∧ ¬extensionInconsistent S F2

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


end SE.NeutralSubstrate
