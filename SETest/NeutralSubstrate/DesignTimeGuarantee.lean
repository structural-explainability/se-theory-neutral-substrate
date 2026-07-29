/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.NeutralSubstrate.DesignTimeGuarantee

/-!
# Design-Time Guarantee Tests

Compile-time API and theorem-application tests for
`SE.NeutralSubstrate.DesignTimeGuarantee`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.DesignTimeGuarantee

#check SE.NeutralSubstrate.DesignTimeGuaranteeSystem
#check SE.NeutralSubstrate.GuaranteedAtDesignTime
#check SE.NeutralSubstrate.guaranteedAtDesignTime_iff
#check SE.NeutralSubstrate.holds_of_guaranteedAtDesignTime
#check SE.NeutralSubstrate.guaranteedAtDesignTime_of_establishes
#check SE.NeutralSubstrate.exists_permittedBasis_of_guaranteedAtDesignTime

end SETest.NeutralSubstrate.DesignTimeGuarantee
