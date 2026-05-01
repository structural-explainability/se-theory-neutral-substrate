-- ============================================================
-- NeutralSubstrate/Spec.lean
-- ============================================================

-- REQ.FILE.SPEC
--   Canonical citation identifiers for the Neutral Substrate library.
--   These strings are stable across Core refactors.
--   Regime authors cite these IDs in documentation and trace matrices.
--   No Prop, no logic, no dependency on Core.

-- WHY: Decoupling IDs from math means a proof reorganization in Core
--   never invalidates a downstream citation. The ID is the contract;
--   the theorem is the implementation.

namespace SE.NeutralSubstrate.Spec


-- ============================================================
-- TYPES
-- ============================================================

-- REQ.SPEC.TYPES
--   Cite when depending on the shape of a Core type.

/-- Cite when a regime depends on the PrimitiveKind enumeration. -/
def NS_ID_TYPE_PRIMITIVE_KIND : String :=
  "NS.TYPE.PRIMITIVE_KIND"

/-- Cite when a regime depends on the Primitive structure. -/
def NS_ID_TYPE_PRIMITIVE : String :=
  "NS.TYPE.PRIMITIVE"

/-- Cite when a regime depends on Ontology as a list of primitives. -/
def NS_ID_TYPE_ONTOLOGY : String :=
  "NS.TYPE.ONTOLOGY"

/-- Cite when a regime depends on the Framework structure. -/
def NS_ID_TYPE_FRAMEWORK : String :=
  "NS.TYPE.FRAMEWORK"


-- ============================================================
-- PREDICATES
-- ============================================================

-- REQ.SPEC.PREDICATES
--   Cite when depending on the definition of a Core predicate.

/-- Cite when a regime depends on the definition of Admissible. -/
def NS_ID_DEF_ADMISSIBLE : String :=
  "NS.DEF.ADMISSIBLE"

/-- Cite when a regime depends on containsCausalOrNormative as a boolean test. -/
def NS_ID_DEF_CONTAINS_CAUSAL_OR_NORMATIVE : String :=
  "NS.DEF.CONTAINS_CAUSAL_OR_NORMATIVE"

/-- Cite when a regime depends on the definition of extensionInconsistent. -/
def NS_ID_DEF_EXTENSION_INCONSISTENT : String :=
  "NS.DEF.EXTENSION_INCONSISTENT"

/-- Cite when a regime depends on the definition of ExtensionStable. -/
def NS_ID_DEF_EXTENSION_STABLE : String :=
  "NS.DEF.EXTENSION_STABLE"

/-- Cite when a regime depends on the definition of Neutral. -/
def NS_ID_DEF_NEUTRAL : String :=
  "NS.DEF.NEUTRAL"

/-- Cite when a regime depends on the definition of FrameworkVariant. -/
def NS_ID_DEF_FRAMEWORK_VARIANT : String :=
  "NS.DEF.FRAMEWORK_VARIANT"

/-- Cite when a regime depends on the definition of FrameworksContradict. -/
def NS_ID_DEF_FRAMEWORKS_CONTRADICT : String :=
  "NS.DEF.FRAMEWORKS_CONTRADICT"


-- ============================================================
-- AXIOMS
-- ============================================================

-- REQ.SPEC.AXIOMS
--   Cite when a regime inherits or depends on a Core axiom.
--   Regime authors should document which axioms their proofs rest on.

/-- Cite when a regime proof depends on framework_relativity. -/
def NS_ID_AXIOM_FRAMEWORK_RELATIVITY : String :=
  "NS.AXIOM.FRAMEWORK_RELATIVITY"

/-- Cite when a regime proof depends on neutral_primitives_undisputed. -/
def NS_ID_AXIOM_NEUTRAL_PRIMITIVES_UNDISPUTED : String :=
  "NS.AXIOM.NEUTRAL_PRIMITIVES_UNDISPUTED"

/-- Cite when a regime proof depends on causal_normative_affirmed. -/
def NS_ID_AXIOM_CAUSAL_NORMATIVE_AFFIRMED : String :=
  "NS.AXIOM.CAUSAL_NORMATIVE_AFFIRMED"


-- ============================================================
-- THEOREMS
-- ============================================================

-- REQ.SPEC.THEOREMS
--   Cite when a regime proof applies or extends a Core theorem.

/-- Cite when a regime applies the only-if direction of the main theorem.
    This direction requires only framework_relativity (lower bound). -/
def NS_ID_THEOREM_NOT_NEUTRAL_IF_CAUSAL_OR_NORMATIVE : String :=
  "NS.THEOREM.NOT_NEUTRAL_IF_CAUSAL_OR_NORMATIVE"

/-- Cite when a regime applies the if direction of the main theorem.
    This direction additionally requires neutral_primitives_undisputed (upper bound). -/
def NS_ID_THEOREM_NEUTRAL_IF_ONLY_NEUTRAL : String :=
  "NS.THEOREM.NEUTRAL_IF_ONLY_NEUTRAL"

/-- Cite when a regime applies or extends the ontological neutrality biconditional.
    Valid only in domains where both axioms hold. -/
def NS_ID_THEOREM_ONTOLOGICAL_NEUTRALITY : String :=
  "NS.THEOREM.ONTOLOGICAL_NEUTRALITY"

/-- Cite when a regime can establish only the lower bound.
    Use when neutral_primitives_undisputed does not hold in the domain. -/
def NS_ID_THEOREM_LOWER_BOUND_ONLY : String :=
  "NS.THEOREM.LOWER_BOUND_ONLY"

/-- Cite when a regime applies the framework-contestability lemma. -/
def NS_ID_THEOREM_FRAMEWORK_CONTESTABILITY : String :=
  "NS.THEOREM.FRAMEWORK_CONTESTABILITY"

/-- Cite when a regime applies or instantiates separate stability. -/
def NS_ID_THEOREM_SEPARATE_STABILITY : String :=
  "NS.THEOREM.SEPARATE_STABILITY"


end SE.NeutralSubstrate.Spec
