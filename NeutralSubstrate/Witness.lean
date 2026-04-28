import NeutralSubstrate.Theorems

/-!
File: NeutralSubstrate/Witness.lean

Purpose:
Export-facing witness definitions for the neutral substrate layer.

Canonical witness: the unit type yields a neutral substrate.
-/

namespace NeutralSubstrate

def unitSubstrate : Substrate := { carrier := Unit }

instance : WellFormed unitSubstrate := { nonempty_carrier := ⟨()⟩ }
instance : Admissible unitSubstrate := { supports_external_regime_application := trivial }
instance : Separated unitSubstrate := { does_not_encode_regime_behavior := trivial }
instance : Neutral unitSubstrate := {}

end NeutralSubstrate
