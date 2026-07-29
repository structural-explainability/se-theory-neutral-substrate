/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.NeutralSubstrate.Neutrality.ByDesign

/-!
# Neutrality-by-Design Tests

Compile-time API and theorem-application tests for
`SE.NeutralSubstrate.Neutrality.ByDesign`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Neutrality.ByDesign

#check SE.NeutralSubstrate.Neutrality.Neutral
#check SE.NeutralSubstrate.Neutrality.neutral_iff
#check SE.NeutralSubstrate.Neutrality.interpretiveNonCommitment_of_neutral
#check SE.NeutralSubstrate.Neutrality.extensionStability_of_neutral
#check SE.NeutralSubstrate.Neutrality.NeutralByDesign
#check SE.NeutralSubstrate.Neutrality.neutralByDesign_iff
#check SE.NeutralSubstrate.Neutrality.neutral_of_neutralByDesign
#check SE.NeutralSubstrate.Neutrality.interpretiveNonCommitment_of_neutralByDesign
#check SE.NeutralSubstrate.Neutrality.extensionStability_of_neutralByDesign

end SETest.NeutralSubstrate.Neutrality.ByDesign
