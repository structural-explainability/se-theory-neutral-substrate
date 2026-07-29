/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.NeutralSubstrate.Attribution.Basic

/-!
# Attribution Tests

Compile-time API and theorem-application tests for
`SE.NeutralSubstrate.Attribution.Basic`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Attribution.Basic

open SE.Logic.Language
open SE.NeutralSubstrate.Attribution

universe u v

#check AttributionSystem
#check AttributionProposition
#check attributionProposition_asserts

example {L : PropositionalLanguage.{u}}
    (A : AttributionSystem.{u, v} L)
    (source : A.Source)
    (p : L.Proposition) :
    AttributionProposition A (A.asserts source p) :=
  attributionProposition_asserts A source p

end SETest.NeutralSubstrate.Attribution.Basic
