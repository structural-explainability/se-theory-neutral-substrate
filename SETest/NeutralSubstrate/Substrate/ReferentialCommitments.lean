/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.Substrate.ReferentialCommitments

/-!
# Referential Commitment Tests

Compile-time API and theorem-application tests for
`SE.Substrate.ReferentialCommitments`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Substrate.ReferentialCommitments

#check SE.Substrate.ReferentialFixing
#check SE.Substrate.ReferentialCommitments
#check SE.Substrate.substrateCommitment_of_mem_referentialCommitments
#check SE.Substrate.fixedByReferentialRegime_of_mem_referentialCommitments

end SETest.NeutralSubstrate.Substrate.ReferentialCommitments
