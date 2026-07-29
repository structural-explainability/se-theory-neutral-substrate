/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.Logic.Consequence

/-!
# Consequence System Tests

Compile-time API and theorem-application tests for
`SE.Logic.Consequence`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Logic.Consequence

open SE.Logic
open SE.Logic.Language
open SE.Logic.Theory

universe u

#check ConsequenceSystem
#check ConsequenceSystem.entailsMono

example {L : PropositionalLanguage.{u}}
    (C : ConsequenceSystem L)
    {T U : CommitmentTheory L.carrier}
    {p : L.Proposition}
    (hTU : T ⊆ U)
    (hp : C.entails T p) :
    C.entails U p :=
  C.entailsMono hTU hp

end SETest.NeutralSubstrate.Logic.Consequence
