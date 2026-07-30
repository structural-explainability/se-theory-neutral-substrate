/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

/-!
# AUX-001. Proposition Carrier (the object language's propositions)

The starting point of the logical layer: a bare type, `Proposition`,
whose inhabitants are the propositions the theory reasons *about*.
A type, with nothing else attached.

Later modules add:

- a negation on it (AUX-002),
- a distinguished contradiction `⊥` (AUX-003), and
- a consequence relation (AUX-005).

This module just says "there is a type of propositions".

## Object language vs metalanguage

Two logics are in play, and keeping them apart is key.

- The **metalanguage** is Lean itself, the logic we reason *in*.
  Its propositions live in `Prop`;
  its truth, negation (`¬`), and falsity (`False`) are Lean's own.
- The **object language** is the logic we reason *about*,
  the system of claims that a shared record (a "substrate")
  and its interpretive frameworks commit to.
  Its propositions are the inhabitants of this `Proposition` type.

Analogy: it is like the difference between the language a program
is *written in* and the language a program *manipulates as data*.
An interpreter for a small language is written in the host language but represents
the guest language's expressions as data structures.
Here Lean is the host and `Proposition` is the type of the guest language's sentences.
A value `p : L.Proposition` is a piece of syntax that can be put into a theory.
We can ask whether it is entailed; it is not a claim in Lean's own logic.
The two logics meet only through the consequence relation (AUX-005),
never by definitional equality, so a fact about the object language
is never silently imported from Lean, and vice versa.
This separation is what enables modeling a record's internal logic faithfully,
including where it disagrees with classical logic,
without Lean's logical laws leaking in.

## This Type is Featureless

`PropositionCarrier` wraps *only* a type.
It withholds every convenience a programmer might expect:

- **No decidable equality:** we cannot, in general, test two propositions for
  equality by computation.
- **No finiteness or enumeration:** the propositions are not assumed to be a
  finite or listable collection; a record's language can be open-ended.
- **No computational structure:** propositions are opaque; there is no
  recursion, no case-analysis on their shape, no evaluator.

Each omission is a commitment to generality.
The paper's results must hold for *any* language a shared record might use,
so we assume just a type and add structure only where a definition needs it.
Anything assumed here would narrow the theorems to languages with that feature.

## Wrapping a Type in a Structure

Wrapping a single field `Proposition : Type u` in a `structure`,
rather than passing a bare `Type u` around,
gives the language a stable *identity* to hang the later pieces on:
AUX-002's negation and AUX-003's `⊥` are defined
*relative to a given carrier*, and `PropositionalLanguage` (AUX-Basic)
bundles a carrier with its negation and contradiction into one object.
The wrapper is the seam that lets those pieces refer to "the same language."
-/

set_option autoImplicit false

namespace SE.Logic.Language

universe u

public section

/--
The object language's propositions, as a bare type.
The foundation of the logical layer.

`Proposition` is the type of claims the theory reasons *about* (the object
language), kept distinct from Lean's own `Prop` (the metalanguage we reason
*in*).
It is deliberately featureless: no decidable equality, finiteness,
enumeration, or computational structure is assumed,
so the theory stays general over any record's language.
-/
structure PropositionCarrier where
  /-- The type of object-language propositions carried by the language. -/
  Proposition : Type u

end

end SE.Logic.Language
