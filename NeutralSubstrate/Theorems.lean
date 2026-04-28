import NeutralSubstrate.Invariants

/-!
File: NeutralSubstrate/Theorems.lean

Purpose:
Export-facing theorem statements for the neutral substrate layer.

Keep this file focused on stable results intended for downstream imports.
-/

namespace NeutralSubstrate

/-- Any neutral substrate is admissible. -/
theorem admissible_of_neutral (S : Substrate) [Neutral S] : Admissible S :=
  inferInstance

/-- Any neutral substrate is separated from regime behavior. -/
theorem separated_of_neutral (S : Substrate) [Neutral S] : Separated S :=
  inferInstance

/-- Any neutral substrate satisfies the substrate invariant. -/
theorem invariant_holds_of_neutral (S : Substrate) [Neutral S] : Invariant S :=
  invariant_of_neutral S

end NeutralSubstrate
