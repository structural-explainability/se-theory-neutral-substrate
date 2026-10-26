/-
Copyright (c) 2026 Denise M. Case. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
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
