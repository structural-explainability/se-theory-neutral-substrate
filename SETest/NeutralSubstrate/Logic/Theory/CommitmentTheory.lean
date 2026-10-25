module

import SE.Logic.Theory.CommitmentTheory

/-!
# Commitment Theory Tests

Compile-time API and theorem-application tests for
`SE.Logic.Theory.CommitmentTheory`.

NOTE: Uses MathlibMini.Set instead of Mathlib.Data.Set.Basic.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Logic.Theory.CommitmentTheory

open SE.Logic.Language
open SE.Logic.Theory

universe u

#check CommitmentTheory

example {P : PropositionCarrier.{u}}
    (T : CommitmentTheory P) :
    MathlibMini.Set P.Proposition :=
  T

end SETest.NeutralSubstrate.Logic.Theory.CommitmentTheory
