/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.NeutralSubstrate.Attribution.Permitted

/-!
# Permitted Attribution Tests

Compile-time API and theorem-application tests for
`SE.NeutralSubstrate.Attribution.Permitted`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Attribution.Permitted

#check SE.NeutralSubstrate.Attribution.AttributionalBasisFixing
#check SE.NeutralSubstrate.Attribution.PermittedAttributionProposition
#check SE.NeutralSubstrate.Attribution.attributionProposition_of_permittedAttributionProposition
#check
  SE.NeutralSubstrate.Attribution.referentialCommitments_entails_of_permittedAttributionProposition
#check SE.NeutralSubstrate.Attribution.substrateCommitment_of_permittedAttributionProposition

end SETest.NeutralSubstrate.Attribution.Permitted
