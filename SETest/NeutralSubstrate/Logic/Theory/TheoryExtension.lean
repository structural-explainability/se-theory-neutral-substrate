/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.Logic.Theory.TheoryExtension

/-!
# Theory Extension Tests

Compile-time API and theorem-application tests for
`SE.Logic.Theory.TheoryExtension`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Logic.Theory.TheoryExtension

open SE.Logic.Language
open SE.Logic.Theory

universe u

#check combine
#check adjoin
#check mem_combine_iff
#check mem_adjoin_iff
#check subset_combine_left
#check subset_combine_right
#check subset_adjoin

example {P : PropositionCarrier.{u}}
    {T U : CommitmentTheory P}
    {p : P.Proposition}
    (hp : p ∈ T) :
    p ∈ combine T U :=
  subset_combine_left T U hp

example {P : PropositionCarrier.{u}}
    {T U : CommitmentTheory P}
    {p : P.Proposition}
    (hp : p ∈ U) :
    p ∈ combine T U :=
  subset_combine_right T U hp

example {P : PropositionCarrier.{u}}
    {T : CommitmentTheory P}
    {p q : P.Proposition}
    (hp : p ∈ T) :
    p ∈ adjoin T q :=
  subset_adjoin T q hp

end SETest.NeutralSubstrate.Logic.Theory.TheoryExtension
