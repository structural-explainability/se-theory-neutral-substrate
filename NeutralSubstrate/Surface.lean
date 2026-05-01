-- ============================================================
-- NeutralSubstrate/Surface.lean
-- ============================================================

-- REQ.FILE.SURFACE
--   Curated stable surface for downstream regime authors.
--   This file defines what "import NeutralSubstrate" provides.
--   Core internals not listed here are not part of the public contract.

-- WHY: Explicit export means Core can be refactored without
--   breaking regime code, as long as the names listed here
--   remain provable and their types remain stable.

-- WHY Surface not Exports: this file IS the surface boundary.
--   "Exports" implies a mechanism; "Surface" names what it is.

-- USAGE: Regime authors write:
--   import NeutralSubstrate
--   open SE.NeutralSubstrate        -- types, predicates, axioms, theorems
--   open SE.NeutralSubstrate.Spec   -- citation IDs (optional)

import NeutralSubstrate.Core
import NeutralSubstrate.Spec


-- ============================================================
-- TYPES
-- ============================================================

-- REQ.SURFACE.TYPES
--   The structural vocabulary regimes build on.
--   Cite IDs: NS.TYPE.*

export SE.NeutralSubstrate (PrimitiveKind)
export SE.NeutralSubstrate (Primitive)
export SE.NeutralSubstrate (Ontology)
export SE.NeutralSubstrate (Framework)


-- ============================================================
-- PREDICATES
-- ============================================================

-- REQ.SURFACE.PREDICATES
--   The properties regime proofs quantify over or discharge.
--   Cite IDs: NS.DEF.*

export SE.NeutralSubstrate (Admissible)
export SE.NeutralSubstrate (containsCausalOrNormative)
export SE.NeutralSubstrate (extensionInconsistent)
export SE.NeutralSubstrate (ExtensionStable)
export SE.NeutralSubstrate (Neutral)
export SE.NeutralSubstrate (FrameworkVariant)
export SE.NeutralSubstrate (FrameworksContradict)


-- ============================================================
-- AXIOMS
-- ============================================================

-- REQ.SURFACE.AXIOMS
--   Domain assumptions the main theorem rests on.
--   Regime authors must document which axioms their proofs inherit.
--   Cite IDs: NS.AXIOM.*

export SE.NeutralSubstrate (framework_relativity)
export SE.NeutralSubstrate (neutral_primitives_undisputed)
export SE.NeutralSubstrate (causal_normative_affirmed)


-- ============================================================
-- THEOREMS
-- ============================================================

-- REQ.SURFACE.THEOREMS
--   The results regime proofs may apply or extend.
--   Cite IDs: NS.THEOREM.*

export SE.NeutralSubstrate (not_neutral_if_causal_or_normative)
export SE.NeutralSubstrate (neutral_if_only_neutral)
export SE.NeutralSubstrate (ontological_neutrality_theorem)
export SE.NeutralSubstrate (framework_contestability_lemma)
export SE.NeutralSubstrate (separate_stability)
