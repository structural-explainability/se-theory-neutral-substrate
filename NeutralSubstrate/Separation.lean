import NeutralSubstrate.Admissibility

/-!
File: NeutralSubstrate/Separation.lean

Purpose:
Separation constraints showing that the neutral substrate does not encode
identity-regime behavior internally.
-/

namespace NeutralSubstrate

/-- Marker predicate: the substrate does not itself encode regime behavior. -/
class Separated (S : Substrate) : Prop where
  does_not_encode_regime_behavior : True

/-- A separated admissible substrate remains neutral with respect to regimes. -/
class Neutral (S : Substrate) : Prop extends Admissible S, Separated S

end NeutralSubstrate
