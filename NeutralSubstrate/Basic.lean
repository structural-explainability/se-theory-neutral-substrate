/-!
File: NeutralSubstrate/Basic.lean

Purpose:
Basic vocabulary for the neutral substrate.

This file should contain only substrate-neutral primitives.
It must not define identity regimes, regime profiles, persistence behavior,
domain semantics, or operational validation.
-/

namespace NeutralSubstrate

/-- A neutral structural substrate. -/
structure Substrate where
  carrier : Type

/-- A named structural position within a substrate. -/
structure Locus (S : Substrate) where
  value : S.carrier

end NeutralSubstrate
