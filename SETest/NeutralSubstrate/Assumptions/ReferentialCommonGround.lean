/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.NeutralSubstrate.Assumptions.ReferentialCommonGround

/-!
# Referential Common-Ground Tests

Compile-time API and theorem-application tests for
`SE.NeutralSubstrate.Assumptions.ReferentialCommonGround`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Assumptions.ReferentialCommonGround

#check SE.NeutralSubstrate.Assumptions.ReferentialCommonGround
#check SE.NeutralSubstrate.Assumptions.referentialCommonGround_iff
#check SE.NeutralSubstrate.Assumptions.referentialCommitments_compatible_of_referentialCommonGround
#check SE.NeutralSubstrate.Assumptions.permittedAttribution_compatible_of_referentialCommonGround
#check SE.NeutralSubstrate.Assumptions.consistent_referentialCommitments_of_referentialCommonGround
#check SE.NeutralSubstrate.Assumptions.consistent_permittedAttribution_of_referentialCommonGround

end SETest.NeutralSubstrate.Assumptions.ReferentialCommonGround
