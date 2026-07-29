/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.NeutralSubstrate.Neutrality.InterpretiveNonCommitment

/-!
# Interpretive Non-Commitment Tests

Compile-time API and theorem-application tests for
`SE.NeutralSubstrate.Neutrality.InterpretiveNonCommitment`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Neutrality.InterpretiveNonCommitment

#check SE.NeutralSubstrate.Neutrality.InterpretiveNonCommitment
#check SE.NeutralSubstrate.Neutrality.interpretiveNonCommitment_iff
#check SE.NeutralSubstrate.Neutrality.not_substrateCommitment_of_interpretiveNonCommitment
#check SE.NeutralSubstrate.Neutrality.not_negSubstrateCommitment_of_interpretiveNonCommitment
#check SE.NeutralSubstrate.Neutrality.no_commitment_pair_of_interpretiveNonCommitment

end SETest.NeutralSubstrate.Neutrality.InterpretiveNonCommitment
