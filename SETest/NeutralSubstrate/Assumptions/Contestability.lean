/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.NeutralSubstrate.Assumptions.Contestability

/-!
# Contestability Tests

Compile-time API and theorem-application tests for
`SE.NeutralSubstrate.Assumptions.Contestability`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Assumptions.Contestability

#check SE.NeutralSubstrate.Assumptions.Contestability
#check SE.NeutralSubstrate.Assumptions.contestability_iff
#check SE.NeutralSubstrate.Assumptions.not_guaranteedFrameworkInvariant_of_contestability

end SETest.NeutralSubstrate.Assumptions.Contestability
