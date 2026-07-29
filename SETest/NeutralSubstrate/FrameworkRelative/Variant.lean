/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.NeutralSubstrate.FrameworkRelative.Variant

/-!
# Framework-Variant Proposition Tests

Compile-time API and theorem-application tests for
`SE.NeutralSubstrate.FrameworkRelative.Variant`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.FrameworkRelative.Variant

#check SE.NeutralSubstrate.FrameworkRelative.SubstrateFrameworkCommitments
#check SE.NeutralSubstrate.FrameworkRelative.FrameworkVariantProposition
#check SE.NeutralSubstrate.FrameworkRelative.entails_substrateFrameworkCommitments_of_substrateCommitment
#check SE.NeutralSubstrate.FrameworkRelative.exists_entails_of_frameworkVariantProposition
#check SE.NeutralSubstrate.FrameworkRelative.exists_entailsNeg_of_frameworkVariantProposition

end SETest.NeutralSubstrate.FrameworkRelative.Variant
