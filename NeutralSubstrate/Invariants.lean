import NeutralSubstrate.Separation

/-!
File: NeutralSubstrate/Invariants.lean

Purpose:
Substrate-level invariants preserved independently of identity regimes.
-/

namespace NeutralSubstrate

/-- A substrate-level invariant. -/
def Invariant (S : Substrate) : Prop :=
  Neutral S

/-- Neutrality implies the substrate invariant. -/
theorem invariant_of_neutral (S : Substrate) [Neutral S] : Invariant S :=
  show Neutral S from inferInstance

end NeutralSubstrate
