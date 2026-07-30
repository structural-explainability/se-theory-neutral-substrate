/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Language.PropositionCarrier

/-!
# AUX-003. Bottom (the object language's contradiction)

This module defines a single distinguished proposition,
written `⊥` and read "bottom," that plays the role of
*contradiction* in the object language.
A theory is *inconsistent* exactly when it entails `⊥`;
consistency is defined as *not* entailing it.
So `⊥` is the target that consistency is defined against.

In logic, we order propositions by implication:
`p ≤ q` when `p` implies `q`.
In that order there is a least element that implies everything
and is implied only by contradictions, that is
the "bottom" of the order, or `⊥`.
Its mirror image is `⊤` ("top"), a canonical truth.

"Bottom" is the object; "contradiction" is what happens when you derive it.
Both words point at the same proposition;
we name the structure for the object (`Bottom`) and
describe its use (contradiction) in prose.

**`⊥` is not Lean's `False`.**
Lean's `False` is a proposition in the *metalanguage*, the logic we reason *in*.
`⊥` here is a term of the *object language*, the logic we are reasoning *about*
and the one whose propositions a substrate and its frameworks commit to.
Keeping them separate allows us to model a record's internal logic
without smuggling in Lean's own logical laws.
The two only ever connect through the consequence relation,
never by definitional equality.

**No explosion.**
In classical logic, from a contradiction everything follows
(`⊥ → p` for all `p`); this is *ex falso quodlibet*, "explosion."
We do **not** assume it.
Entailing `⊥` marks a theory as inconsistent,
but does not license deriving arbitrary propositions from it.
This matters for the paper.
A neutral substrate must stay usable by frameworks that disagree,
and we do not want one framework's inconsistency to
trivially entail everything on the shared base.
Declining explosion keeps inconsistency *local* rather than catastrophic.

`PropositionCarrier` supplies the bare type of object-language propositions.
This module adds one designated proposition to that type.
It adds no laws, no negation, and no notion of proof.
Only the marker that later modules use to state "consistent."
-/

set_option autoImplicit false

namespace SE.Logic.Language

universe u

public section

/--
A choice of one distinguished proposition, `⊥` ("bottom"),
in a proposition carrier.
The object-language contradiction that consistency is defined against.

This is data, not a law:
it names *which* proposition is `⊥` and asserts nothing about it.
It is deliberately **not** Lean's `False`, and no explosion
principle (`⊥` entails everything) is assumed.
-/
structure Bottom (P : PropositionCarrier.{u}) where
  /-- Returns the distinguished contradiction proposition, `⊥`. -/
  bottom : P.Proposition

end

end SE.Logic.Language
