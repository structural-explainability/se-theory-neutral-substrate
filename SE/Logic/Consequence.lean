/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Language.Basic
public import SE.Logic.Theory.CommitmentTheory

/-!
# AUX-005. Entailment

This module defines the abstract consequence relation used by the Structural
Explainability theory.

The consequence relation is intentionally independent of any particular proof
calculus, model theory, decision procedure, or implementation.

The interface assumes:

- commitments entail their members;
- generalized cut;
- contradiction formation from a proposition and its object-language negation.

Generalized cut is a deliberate Tarskian consequence-system commitment. It
supports removal of arbitrary collections of propositions that are already
entailed by a theory, without assuming finiteness or enumeration.

Monotonicity is derived from generalized cut and entailment of theory members.

No explosion, excluded middle, negation introduction, completeness,
decidability, or compactness principle is assumed.
-/

set_option autoImplicit false

namespace SE.Logic

open Language
open Theory

universe u

public section

/--
An abstract consequence system over a propositional language.

`L` supplies the object-language proposition carrier, negation operation,
and distinguished contradiction proposition.
-/
structure ConsequenceSystem
    (L : PropositionalLanguage.{u}) where

  /--
  The consequence relation between a commitment theory and an
  object-language proposition.
  -/
  entails :
    CommitmentTheory L.carrier →
    L.Proposition →
    Prop

  /--
  Every proposition explicitly contained in a commitment theory is entailed
  by that theory.
  -/
  entailsOfMem :
    ∀ {T : CommitmentTheory L.carrier} {p : L.Proposition},
      p ∈ T →
      entails T p

  /--
  Generalized cut.

  If `T` entails every proposition in `U`, then every consequence of `U` is
  also a consequence of `T`.
  -/
  cut :
    ∀ {T U : CommitmentTheory L.carrier} {p : L.Proposition},
      (∀ q ∈ U, entails T q) →
      entails U p →
      entails T p

  /--
  Entailment of both a proposition and its object-language negation entails
  the distinguished contradiction proposition.
  -/
  contradiction :
    ∀ {T : CommitmentTheory L.carrier} {p : L.Proposition},
      entails T p →
      entails T (L.neg p) →
      entails T L.bottom

namespace ConsequenceSystem

variable
  {L : PropositionalLanguage.{u}}
  (C : ConsequenceSystem L)

/--
Entailment is monotone under extension of the commitment theory.
-/
theorem entailsMono
    {T U : CommitmentTheory L.carrier}
    {p : L.Proposition}
    (hTU : T ⊆ U)
    (hp : C.entails T p) :
    C.entails U p := by
  apply C.cut (T := U) (U := T)
  · intro q hq
    exact C.entailsOfMem (hTU hq)
  · exact hp

end ConsequenceSystem

end

end SE.Logic
