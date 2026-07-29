/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.NeutralSubstrate.Attribution.CommonGround

/-!
# Attribution Common-Ground Tests

Compile-time API and theorem-application tests for
`SE.NeutralSubstrate.Attribution.CommonGround`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Attribution.CommonGround

#check SE.NeutralSubstrate.Attribution.entailsBottom_combine_adjoin_iff_of_entails
#check SE.NeutralSubstrate.Attribution.entailsBottom_permittedAttribution_iff
#check SE.NeutralSubstrate.Attribution.consistent_permittedAttribution_of_commonGround

end SETest.NeutralSubstrate.Attribution.CommonGround
