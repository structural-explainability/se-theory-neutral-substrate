import NeutralSubstrate


/-!
File: test/TestRegime.lean

Notes:

- Smoke test: exercises NS exactly as a downstream regime library would.
- Imports only `NeutralSubstrate`. Never imports Core, Spec, or Surface directly.
- Defines a minimal toy regime and proves it grounds in NS.
- Instantiates the incident example from Case (2025) §4.3.
- If the public surface breaks, this file breaks first.
-/

open SE.NeutralSubstrate
open SE.NeutralSubstrate.Spec


-- ============================================================
-- SECTION 1: TOY REGIME SUBSTRATE
-- ============================================================

-- REQ.TEST.REGIME.SUBSTRATE
--   A minimal concrete ontology a downstream regime might define.
--   Contains only neutral primitives: should be provably neutral.

def toySubstrate : Ontology :=
  [ ⟨.neutral, "agent_A"⟩
  , ⟨.neutral, "agent_B"⟩
  , ⟨.neutral, "event_E"⟩
  ]


-- ============================================================
-- SECTION 2: REGIME CONFORMANCE PROOF
-- ============================================================

-- REQ.TEST.REGIME.CONFORMANCE
--   The toy regime proves its substrate satisfies NS neutrality.
--   This is the pattern downstream Conformance.lean files follow.
--   Cite: NS.THEOREM.NEUTRAL_IF_ONLY_NEUTRAL

theorem toySubstrate_is_neutral : Neutral toySubstrate := by
  apply neutral_if_only_neutral
  native_decide


-- ============================================================
-- SECTION 3: APPLYING THE MAIN THEOREM
-- ============================================================

-- REQ.TEST.REGIME.MAIN_THEOREM
--   A regime may apply ontological_neutrality_theorem to extract
--   the boolean characterization from a neutrality proof.
--   Cite: NS.THEOREM.ONTOLOGICAL_NEUTRALITY

theorem toySubstrate_contains_no_causal_or_normative :
    containsCausalOrNormative toySubstrate = false :=
  (ontological_neutrality_theorem toySubstrate).mp toySubstrate_is_neutral


-- ============================================================
-- SECTION 4: NEGATIVE CASE
-- ============================================================

-- REQ.TEST.REGIME.NEGATIVE
--   A regime substrate that embeds a causal commitment is not neutral.
--   Regimes must not embed causal or normative primitives in their
--   substrate layer if they depend on NS stability guarantees.
--   Cite: NS.THEOREM.NOT_NEUTRAL_IF_CAUSAL_OR_NORMATIVE

def nonNeutralSubstrate : Ontology :=
  [ ⟨.neutral, "agent_A"⟩
  , ⟨.causal,  "agent_A_caused_event_E"⟩
  ]

theorem nonNeutralSubstrate_is_not_neutral : ¬Neutral nonNeutralSubstrate := by
  apply not_neutral_if_causal_or_normative
  native_decide


-- ============================================================
-- SECTION 5: INCIDENT SUBSTRATE (Case 2025, §4.3)
-- ============================================================

-- REQ.TEST.REGIME.INCIDENT
--   Formalizes the incident investigation example from the paper.
--   The substrate asserts only framework-invariant referential structure:
--   Agent, Occurrence, Participant, Before.
--   Two admissible frameworks extend it with contradicting conclusions.
--   The substrate remains neutral under both.
--   Cite: NS.THEOREM.SEPARATE_STABILITY

/-- The incident substrate.
    Asserts only framework-invariant referential structure.
    No causal or normative primitives at the substrate layer. -/
def incidentSubstrate : Ontology :=
  [ ⟨.neutral, "Agent_a"⟩
  , ⟨.neutral, "Occurrence_e1"⟩
  , ⟨.neutral, "Occurrence_e2"⟩
  , ⟨.neutral, "Participant_a_e1"⟩
  , ⟨.neutral, "Before_e1_e2"⟩
  ]

/-- The incident substrate is neutral.
    All primitives are neutral; no framework can deny any of them. -/
theorem incidentSubstrate_is_neutral : Neutral incidentSubstrate := by
  apply neutral_if_only_neutral
  native_decide

/-- Violation case: embedding a causal commitment destroys neutrality.
    If the substrate asserts Caused(e1, e2) at the foundational layer,
    any framework that denies that causal relation cannot be layered
    atop the substrate without contradiction.
    Cite: NS.THEOREM.NOT_NEUTRAL_IF_CAUSAL_OR_NORMATIVE -/
def incidentSubstrateWithCausal : Ontology :=
  [ ⟨.neutral, "Agent_a"⟩
  , ⟨.neutral, "Occurrence_e1"⟩
  , ⟨.neutral, "Occurrence_e2"⟩
  , ⟨.neutral, "Participant_a_e1"⟩
  , ⟨.neutral, "Before_e1_e2"⟩
  , ⟨.causal,  "Caused_e1_e2"⟩
  ]

theorem incidentSubstrateWithCausal_is_not_neutral :
    ¬Neutral incidentSubstrateWithCausal := by
  apply not_neutral_if_causal_or_normative
  native_decide


-- ============================================================
-- SECTION 6: SEPARATE STABILITY ON THE INCIDENT SUBSTRATE
-- ============================================================

-- REQ.TEST.REGIME.SEPARATE_STABILITY
--   Instantiates separate_stability for the incident example.
--   F1 (engineering) and F2 (legal) contradict each other over
--   Responsible(a, e2) but each is separately consistent with
--   the neutral incident substrate.
--   Cite: NS.THEOREM.SEPARATE_STABILITY

/-- Engineering framework: affirms Caused(e1,e2) and Responsible(a,e2). -/
def engineeringFramework : Framework where
  affirms p := p.id == "Caused_e1_e2" || p.id == "Responsible_a_e2"
  denies  _ := false
  consistent := by intro p; simp

/-- Legal framework: denies Responsible(a,e2) under contributory negligence. -/
def legalFramework : Framework where
  affirms _ := false
  denies  p := p.id == "Responsible_a_e2"
  consistent := by intro p; simp

/-- The two frameworks contradict each other over Responsible(a,e2). -/
theorem incident_frameworks_contradict :
    FrameworksContradict engineeringFramework legalFramework :=
  ⟨⟨.neutral, "Responsible_a_e2"⟩, by simp [engineeringFramework],
                                     by simp [legalFramework]⟩

/-- The incident substrate is separately consistent with both frameworks.
    F1 and F2 contradict each other but neither contradicts the substrate. -/
theorem incident_separate_stability :
    ¬extensionInconsistent incidentSubstrate engineeringFramework ∧
    ¬extensionInconsistent incidentSubstrate legalFramework :=
  separate_stability
    incidentSubstrate
    incidentSubstrate_is_neutral
    engineeringFramework
    legalFramework
    trivial
    trivial
    incident_frameworks_contradict


-- ============================================================
-- SECTION 7: CITATION ID USAGE
-- ============================================================

-- REQ.TEST.REGIME.CITATION
--   Demonstrates how a regime records which NS results it depends on.
--   In practice these appear in Conformance.lean doc blocks.

/-- This regime proof depends on the following NS results. -/
def incidentRegimeCitations : List String :=
  [ NS_ID_THEOREM_NEUTRAL_IF_ONLY_NEUTRAL
  , NS_ID_THEOREM_NOT_NEUTRAL_IF_CAUSAL_OR_NORMATIVE
  , NS_ID_THEOREM_SEPARATE_STABILITY
  , NS_ID_AXIOM_NEUTRAL_PRIMITIVES_UNDISPUTED
  , NS_ID_AXIOM_FRAMEWORK_RELATIVITY
  ]

#eval incidentRegimeCitations
-- ["NS.THEOREM.NEUTRAL_IF_ONLY_NEUTRAL",
--  "NS.THEOREM.NOT_NEUTRAL_IF_CAUSAL_OR_NORMATIVE",
--  "NS.THEOREM.SEPARATE_STABILITY",
--  "NS.AXIOM.NEUTRAL_PRIMITIVES_UNDISPUTED",
--  "NS.AXIOM.FRAMEWORK_RELATIVITY"]
