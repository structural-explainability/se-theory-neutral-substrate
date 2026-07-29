/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.Logic.Consistency

/-!
# Consistency Tests

Compile-time API and theorem-application tests for
`SE.Logic.Consistency`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Logic.Consistency

open SE.Logic
open SE.Logic.Language
open SE.Logic.Theory

universe u

#check Consistent
#check not_entailsBottom_of_consistent
#check consistent_of_not_entailsBottom

example {L : PropositionalLanguage.{u}}
    {C : ConsequenceSystem L}
    {T : CommitmentTheory L.carrier}
    (hT : Consistent C T) :
    ¬ C.entails T L.bottom :=
  not_entailsBottom_of_consistent hT

example {L : PropositionalLanguage.{u}}
    {C : ConsequenceSystem L}
    {T : CommitmentTheory L.carrier}
    (hT : ¬ C.entails T L.bottom) :
    Consistent C T :=
  consistent_of_not_entailsBottom hT

end SETest.NeutralSubstrate.Logic.Consistency
