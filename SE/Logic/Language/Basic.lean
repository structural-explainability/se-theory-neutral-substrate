/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Language.PropositionCarrier
public import SE.Logic.Language.Negation
public import SE.Logic.Language.Bottom

/-!
# Propositional Language

This module composes the proposition carrier, object-language negation,
and distinguished contradiction proposition into one propositional-language
interface.

It combines:

- AUX-001 — Proposition Carrier
- AUX-002 — Negation
- AUX-003 — Contradiction / Bottom

The component interfaces remain independently defined in their own modules.
This composition introduces no additional logical laws.
-/

set_option autoImplicit false

namespace SE.Logic.Language

universe u

public section

/--
An object-language proposition carrier together with object-language
negation and a distinguished contradiction proposition.

No involution, excluded middle, explosion, decidability, finiteness, or
enumeration assumption is imposed.
-/
structure PropositionalLanguage where
  /--
  The carrier of object-language propositions.
  -/
  carrier : PropositionCarrier.{u}

  /--
  The object-language negation operation.
  -/
  negation : Negation carrier

  /--
  The distinguished object-language contradiction proposition.
  -/
  contradiction : Bottom carrier

namespace PropositionalLanguage

/--
The type of object-language propositions in a propositional language.
-/
abbrev Proposition (L : PropositionalLanguage.{u}) : Type u :=
  L.carrier.Proposition

/--
The object-language negation operation of a propositional language.
-/
def neg
    (L : PropositionalLanguage.{u})
    (p : L.Proposition) :
    L.Proposition :=
  L.negation.neg p

/--
The distinguished object-language contradiction proposition of a
propositional language.
-/
def bottom
    (L : PropositionalLanguage.{u}) :
    L.Proposition :=
  L.contradiction.bottom

end PropositionalLanguage

end

end SE.Logic.Language
