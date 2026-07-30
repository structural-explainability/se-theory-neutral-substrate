/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Language.PropositionCarrier

/-!
# AUX-002. Negation (in the object language)

This module defines one operation, `neg`,
that sends each object-language proposition `p`
to another object-language proposition `neg p`,
its negation, written `¬p` in prose.
It is a function on propositions.
It carries no rules about how negation behaves.

**`neg` is not Lean's `¬` (`Not`).**
Lean's `¬` operates in the *metalanguage*, the logic we reason *in*.
`neg` operates in the *object language*, the logic we reason *about*,
whose propositions a substrate and its frameworks commit to
(see also Bottom or `⊥` vs Lean's `False`).

Concretely: `neg p` is a *term of type* `P.Proposition`,
a proposition that can be put in a theory;
`¬P` is a Lean `Prop`, a claim in our own reasoning.
They meet only through the **consequence relation**,
for instance, entailing both `p` and `neg p` is what yields `⊥`.

A programmer's intuition for negation comes from classical logic,
where all three of these hold.
Modeling records under disagreement, we do not want them in the shared language.

- **No involution:** we do not assume `neg (neg p) = p`.
  Double negation need not collapse.
  (This is why, e.g., "interpretive non-commitment" has to rule
  out committing to `p` *and* separately to `neg p`,
  rather than treating them as two views of one thing.
  See the two-sided condition in that definition.)
- **No excluded middle:** we do not assume `p ∨ neg p` always holds.
  A framework may take a stance on neither `p` nor its negation,
  which is exactly the non-commitment a neutral substrate must permit.
- **No decidability:** there is no procedure deciding `p` versus `neg p`.
  Propositions are an abstract type with no computational structure.

Assuming any of these would let one interpretive framework
force conclusions on the shared base that another framework rejects.
Withholding them keeps the object language weak enough to stay neutral.
The language commits to *having* a negation,
and commits to nothing about how it resolves.

`PropositionCarrier` supplies the bare type of object-language propositions.
This module adds the negation *operation* on that type;
`Bottom` adds the distinguished contradiction `⊥`;
AUX-005 adds the consequence relation that ties `neg` and `⊥` together.
No module in this layer adds negation's *laws* and those never enter
the theory.
-/

set_option autoImplicit false

namespace SE.Logic.Language

universe u

public section

/--
A choice of negation operation on a proposition carrier:
for each object-language proposition `p`,
a proposition `neg p` read `¬p`.

This is data, not a law:
it says *how to form* `¬p` and asserts nothing about its behaviour.
It is deliberately **not** Lean's `¬` (`Not`), and no
involution (`¬¬p = p`), excluded middle (`p ∨ ¬p`),
or decidability is assumed.
-/
structure Negation (P : PropositionCarrier.{u}) where
  /-- Returns the negation `¬p` of an object-language proposition `p`. -/
  neg : P.Proposition → P.Proposition

end

end SE.Logic.Language
