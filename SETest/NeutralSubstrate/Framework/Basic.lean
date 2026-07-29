/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.Framework.Basic

/-!
# Framework System Tests

Compile-time API and theorem-application tests for
`SE.Framework.Basic`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Framework.Basic

open SE.Framework
open SE.Logic.Language
open SE.Logic.Theory

universe u v

#check FrameworkSystem

example {P : PropositionCarrier.{u}}
    (M : FrameworkSystem.{u, v} P)
    (framework : M.Carrier) :
    CommitmentTheory P :=
  M.commitments framework

end SETest.NeutralSubstrate.Framework.Basic
