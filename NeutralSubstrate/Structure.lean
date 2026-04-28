import NeutralSubstrate.Basic

/-!
File: NeutralSubstrate/Structure.lean

Purpose:
Structural well-formedness predicates for neutral substrates.
-/

namespace NeutralSubstrate

/-- Predicate asserting that a substrate is structurally well formed. -/
class WellFormed (S : Substrate) : Prop where
  nonempty_carrier : Nonempty S.carrier

/-- A substrate together with evidence of structural well-formedness. -/
structure WellFormedSubstrate where
  substrate : Substrate
  is_well_formed : WellFormed substrate

end NeutralSubstrate
