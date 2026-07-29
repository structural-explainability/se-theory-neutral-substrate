/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.NeutralSubstrate.Assumptions.SubstrateConsistency

/-!
# Substrate Consistency Tests

Compile-time API and theorem-application tests for
`SE.NeutralSubstrate.Assumptions.SubstrateConsistency`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Assumptions.SubstrateConsistency

#check SE.NeutralSubstrate.Assumptions.SubstrateConsistency
#check SE.NeutralSubstrate.Assumptions.substrateConsistency_iff
#check SE.NeutralSubstrate.Assumptions.consistent_of_substrateConsistency
#check SE.NeutralSubstrate.Assumptions.substrateConsistency_of_consistent

end SETest.NeutralSubstrate.Assumptions.SubstrateConsistency
