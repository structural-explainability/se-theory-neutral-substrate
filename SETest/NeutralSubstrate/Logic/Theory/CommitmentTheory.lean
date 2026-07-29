/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.Logic.Theory.CommitmentTheory

/-!
# Commitment Theory Tests

Compile-time API and theorem-application tests for
`SE.Logic.Theory.CommitmentTheory`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Logic.Theory.CommitmentTheory

open SE.Logic.Language
open SE.Logic.Theory

universe u

#check CommitmentTheory

example {P : PropositionCarrier.{u}}
    (T : CommitmentTheory P) :
    Set P.Proposition :=
  T

end SETest.NeutralSubstrate.Logic.Theory.CommitmentTheory
