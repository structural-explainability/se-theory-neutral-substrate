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
# Propositional Language (assembling the object language)

This module composes the proposition carrier, object-language negation,
and distinguished contradiction proposition into one propositional-language
interface.

It combines:

- its propositions (`carrier`, AUX-001),
- a negation on them (`negation`, AUX-002),
- a distinguished contradiction `⊥` (`contradiction`, AUX-003).

The component interfaces remain independently defined in their own modules.

## Composition Introduces No New Laws

This is the "assembly" module, the `Basic` file of the `Language/` folder.
Downstream code imports *this* to get a language;
the AUX files are its parts.
It introduces **no new logical laws**.
It only packages parts already defined,
so every non-assumption from the AUX files still holds
(no involution, excluded middle, explosion, decidability, finiteness, or enumeration).

## Bundles and Wrappers

The three components are defined *relative to a carrier*,
e.g.,  `Negation carrier`, `Bottom carrier`,
so on their own they float free.
Bundling them gives the language one identity,
so later modules can say "the negation *of this language*" and
"the `⊥` *of this language*" and know they refer to the same carrier.

`Proposition`, `neg`, and `bottom` below are convenience projections.
Without them, we would write
`L.carrier.Proposition`, `L.negation.neg p`, and `L.contradiction.bottom` everywhere;
with them we write `L.Proposition`, `L.neg p`, `L.bottom` using the notation
the whole development (and the paper) uses.
They add nothing logically; they are shorthand.

## Use `@[expose]` (a Lean-mechanics note)

`neg` and `bottom` are wrapped in `@[expose] section`,
and `Proposition` is an `abbrev`,
so all three *reduce to their definitions* across module boundaries.
This matters when a *concrete* language
(a real type with a real negation, e.g. the model tests) and
needs `L.neg p` to compute to the actual underlying operation.
In the abstract development `L.neg`/`L.bottom`
are passed around as opaque atoms and exposure is irrelevant;
the annotation is there so instantiations aren't blocked.

## This Project
In this work, a projection that a concrete model must compute through is exposed;
a theory concept guarded by an `_iff`/`_eq` lemma stays opaque.
-/

set_option autoImplicit false

namespace SE.Logic.Language

universe u

public section

/--
The object language, bundled.
A proposition carrier together with a negation
on it and a distinguished contradiction `⊥`.

This packages AUX-001/002/003 into one object and adds no new laws.
None of these are assumed: not involution, excluded middle,
explosion, decidability, finiteness, or enumeration.
It is the type most of this development means by "a language `L`."
-/
structure PropositionalLanguage where
  /-- The propositions of the language (AUX-001). -/
  carrier : PropositionCarrier.{u}

  /-- The negation operation on those propositions (AUX-002). -/
  negation : Negation carrier

  /-- The distinguished contradiction `⊥` of the object language (AUX-003). -/
  contradiction : Bottom carrier

namespace PropositionalLanguage

@[expose] section

/--
The type of propositions of a language `L`.

Shorthand for `L.carrier.Proposition`.
`abbrev` so it unfolds transparently.
`L.Proposition` and `L.carrier.Proposition` are interchangeable.
-/
abbrev Proposition (L : PropositionalLanguage.{u}) : Type u :=
  L.carrier.Proposition

/--
The negation `¬p` of a proposition, in a language `L`.

Shorthand for `L.negation.neg p`.
Exposed so concrete languages compute through it.
-/
def neg
    (L : PropositionalLanguage.{u})
    (p : L.Proposition) :
    L.Proposition :=
  L.negation.neg p

/--
The distinguished contradiction `⊥` of a language `L`.

Shorthand for `L.contradiction.bottom`.
Exposed so concrete languages compute through it.
-/
def bottom
    (L : PropositionalLanguage.{u}) :
    L.Proposition :=
  L.contradiction.bottom

end

end PropositionalLanguage

end

end SE.Logic.Language
