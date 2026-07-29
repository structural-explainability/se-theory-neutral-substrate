/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Language.PropositionCarrier

/-!
# AUX-002. Negation

This module defines object-language negation over a proposition carrier.

Object-language negation is intentionally distinct from Lean's metalevel
negation `Not`.
No involution, excluded-middle, or decidability law is assumed.
-/

set_option autoImplicit false

namespace SE.Logic.Language

universe u

public section

/--
An object-language negation operation over a proposition carrier.

For `p : P.Proposition`, `neg p` is another object-language proposition.
It is not the Lean proposition `¬p`.
-/
structure Negation (P : PropositionCarrier.{u}) where
  /-- Returns the negation of a proposition. -/
  neg : P.Proposition → P.Proposition

end

end SE.Logic.Language
