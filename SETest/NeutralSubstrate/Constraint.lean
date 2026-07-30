/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.NeutralSubstrate.Constraint

/-!
# Neutrality Constraint Tests

Compile-time API and theorem-application tests for
`SE.NeutralSubstrate.Constraint`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Constraint

#check SE.NeutralSubstrate.NoObjectLevelCausalOrNormativeCommitment
#check SE.NeutralSubstrate.NeutralityConstraint
#check SE.NeutralSubstrate.neutralByDesign_iff_foundationalLayerRestricted
#check SE.NeutralSubstrate.noObjectLevelCommitment_of_foundationalLayerRestricted
#check SE.NeutralSubstrate.noObjectLevelCommitment_of_neutralByDesign

end SETest.NeutralSubstrate.Constraint
