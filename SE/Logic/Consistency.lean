/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Consequence

/-!
# AUX-006. Consistency

This module defines consistency for a commitment theory.

A commitment theory is consistent exactly when it does not entail the
distinguished object-language contradiction proposition.

Consistency is proposition-valued. No Boolean decision procedure,
decidability assumption, or consistency-by-construction restriction is
introduced.
-/

set_option autoImplicit false

namespace SE.Logic

open Language
open Theory

universe u

public section

/--
A commitment theory is consistent when it does not entail the distinguished
object-language contradiction proposition.
-/
def Consistent
    {L : PropositionalLanguage.{u}}
    (C : ConsequenceSystem L)
    (T : CommitmentTheory L.carrier) :
    Prop :=
  ¬ C.entails T L.bottom

/--
Consistency means that the commitment theory does not entail contradiction.
-/
theorem not_entailsBottom_of_consistent
    {L : PropositionalLanguage.{u}}
    {C : ConsequenceSystem L}
    {T : CommitmentTheory L.carrier}
    (hconsistent : Consistent C T) :
    ¬ C.entails T L.bottom :=
  hconsistent

/--
Failure to entail contradiction establishes consistency.
-/
theorem consistent_of_not_entailsBottom
    {L : PropositionalLanguage.{u}}
    {C : ConsequenceSystem L}
    {T : CommitmentTheory L.carrier}
    (hnotBottom : ¬ C.entails T L.bottom) :
    Consistent C T :=
  hnotBottom

end

end SE.Logic
