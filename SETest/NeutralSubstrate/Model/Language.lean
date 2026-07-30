/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Language.Basic

/-!
# Concrete Object Language for Model Tests

A small, fully concrete propositional language
used to witness that the Neutral Substrate interfaces
are jointly inhabited (non-vacuity).

`Formula α` is the free language over an atom type `α`,
closed under a dedicated negation constructor and
a distinguished contradiction constant.
`Sat` is classical satisfaction under a valuation `v : α → Prop`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Model

open SE.Logic.Language

@[expose] public section

/-- The free object language over an atom type `α`. -/
inductive Formula (α : Type) where
  | atom : α → Formula α
  | bot : Formula α
  | neg : Formula α → Formula α
  deriving DecidableEq

/-- Classical satisfaction of a formula under a valuation. -/
def Sat {α : Type} (v : α → Prop) : Formula α → Prop
  | .atom a => v a
  | .bot => False
  | .neg p => ¬ Sat v p

@[simp] theorem Sat_atom {α} (v : α → Prop) (a : α) :
    Sat v (Formula.atom a) = v a := rfl

@[simp] theorem Sat_bot {α} (v : α → Prop) :
    Sat v (Formula.bot : Formula α) = False := rfl

@[simp] theorem Sat_neg {α} (v : α → Prop) (p : Formula α) :
    Sat v (Formula.neg p) = ¬ Sat v p := rfl

/--
The concrete propositional language on `Formula α`: object-language negation
is the `neg` constructor, contradiction is `bot`.

`abbrev` (not `def`) so `formulaLanguage α` unfolds to its literal across
`SETest` modules, letting the language's projections reduce to the `Formula`
constructors.
-/
abbrev formulaLanguage (α : Type) : PropositionalLanguage where
  carrier := { Proposition := Formula α }
  negation := { neg := Formula.neg }
  contradiction := { bottom := (Formula.bot : Formula α) }

/-!
The three bridge lemmas below connect the language's projections
to the raw constructors.
Each is `rfl`.
-/

@[simp] theorem language_proposition (α : Type) :
    (formulaLanguage α).Proposition = Formula α := rfl

@[simp] theorem language_neg {α : Type} (p : Formula α) :
    (formulaLanguage α).neg p = Formula.neg p := rfl

@[simp] theorem language_bottom (α : Type) :
    (formulaLanguage α).bottom = (Formula.bot : Formula α) := rfl

end

end SETest.NeutralSubstrate.Model
