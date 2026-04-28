import NeutralSubstrate.Structure

/-!
File: NeutralSubstrate/Admissibility.lean

Purpose:
Admissibility predicates for applying identity-regime structure over
a neutral substrate.

This file does not define the regimes themselves.
-/

namespace NeutralSubstrate

/-- A substrate is admissible when it is well formed and suitable for
external regime application. -/
class Admissible (S : Substrate) : Prop extends WellFormed S where
  supports_external_regime_application : True

/-- A well-formed substrate may be treated as a candidate for admissibility. -/
def Candidate (S : Substrate) : Prop :=
  WellFormed S

end NeutralSubstrate
