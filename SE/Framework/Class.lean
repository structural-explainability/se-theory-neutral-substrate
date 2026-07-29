/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Framework.Admissible

/-!
# Framework Class

This module formalizes:

- `se100.note.FrameworkClass` — The Framework Class

The framework class is the class of all intrinsically admissible interpretive
frameworks.

It is represented intensionally as a set defined by the admissibility
predicate.
It is not represented as a finite collection, enumeration,
registry, or design-time list of known frameworks.

A framework becoming known does not change the intrinsic framework class.
-/

set_option autoImplicit false

namespace SE.Framework

open SE.Logic
open SE.Logic.Language

universe u v

public section

/--
The class of all admissible interpretive frameworks.

Membership is determined only by intrinsic admissibility.
The class does not depend on designer knowledge and
is not assumed to be finite, enumerable, or decidable.
-/
def FrameworkClass
    {L : PropositionalLanguage.{u}}
    (C : ConsequenceSystem L)
    (M : FrameworkSystem.{u, v} L.carrier) :
    Set M.Carrier :=
  {F | AdmissibleFramework C M F}

/--
A candidate framework belongs to the framework class
exactly when it is admissible.
-/
@[simp]
theorem mem_frameworkClass_iff
    {L : PropositionalLanguage.{u}}
    {C : ConsequenceSystem L}
    {M : FrameworkSystem.{u, v} L.carrier}
    {F : M.Carrier} :
    F ∈ FrameworkClass C M ↔
      AdmissibleFramework C M F :=
  Iff.rfl

end

end SE.Framework
