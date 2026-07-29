/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Language.PropositionCarrier

/-!
# AUX-003. Contradiction / Bottom

This module defines the distinguished object-language contradiction
proposition over a proposition carrier.

The distinguished proposition is intentionally distinct from Lean's `False`.
No explosion principle is assumed here.
-/

set_option autoImplicit false

namespace SE.Logic.Language

universe u

public section

/--
A distinguished object-language proposition representing contradiction.

Whether a commitment theory entails this proposition will later determine
the paper's consistency predicate.
-/
structure Bottom (P : PropositionCarrier.{u}) where
  /-- The distinguished contradiction proposition. -/
  bottom : P.Proposition

end

end SE.Logic.Language
