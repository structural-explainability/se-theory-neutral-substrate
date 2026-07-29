/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

/-!
# AUX-001. Proposition Carrier
-/

set_option autoImplicit false

namespace SE.Logic.Language

universe u

public section

/--
An arbitrary carrier of object-language propositions.

Object-language propositions are distinct from Lean propositions in `Prop`.
No finiteness, decidable equality, enumeration, or computational structure
is assumed.
-/
structure PropositionCarrier where
  /-- The type of propositions carried by the language. -/
  Proposition : Type u

end

end SE.Logic.Language
