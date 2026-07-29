/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.NeutralSubstrate.Neutrality.ExtensionStability

/-!
# Extension Stability Tests

Compile-time API and theorem-application tests for
`SE.NeutralSubstrate.Neutrality.ExtensionStability`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Neutrality.ExtensionStability

#check SE.NeutralSubstrate.Neutrality.ExtensionStability
#check SE.NeutralSubstrate.Neutrality.extensionStability_iff
#check SE.NeutralSubstrate.Neutrality.consistent_substrateFrameworkCommitments_of_extensionStability

end SETest.NeutralSubstrate.Neutrality.ExtensionStability
