/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.NeutralSubstrate.Examples.ReificationFragment

/-!
# Reification Fragment Tests

Tests the public attribution and substrate-commitment machinery used by the
reification fragment example.
-/

namespace SETest.NeutralSubstrate.Examples.ReificationFragment

open SE.NeutralSubstrate.Attribution
open SE.Substrate

universe u v w x

section ReificationFragment

variable {L : SE.Logic.Language.PropositionalLanguage}
variable {R : SE.Referent.ReferentCarriers}
variable {C : SE.Logic.ConsequenceSystem L}
variable {S : SubstrateSystem L R}
variable {F : ReferentialFixing L R}
variable {A : AttributionSystem L}
variable {B : AttributionalBasisFixing C A}
variable {s : S.Carrier}

variable {source : A.Source}
variable {causalClaim normativeClaim : L.Proposition}

/--
A permitted attributed causal claim is a substrate commitment.
-/
example
    (hcausal :
      PermittedAttributionProposition
        C S F A B s (A.asserts source causalClaim)) :
    SubstrateCommitment C S s (A.asserts source causalClaim) := by
  exact substrateCommitment_of_permittedAttributionProposition B hcausal

/--
A permitted attributed normative claim is a substrate commitment.
-/
example
    (hnormative :
      PermittedAttributionProposition
        C S F A B s (A.asserts source normativeClaim)) :
    SubstrateCommitment C S s (A.asserts source normativeClaim) := by
  exact substrateCommitment_of_permittedAttributionProposition B hnormative

/--
Reification permits commitment to an attributed proposition without requiring
commitment to the corresponding object-level proposition.
-/
example
    (hnoDirect :
      ¬SubstrateCommitment C S s causalClaim)
    (hattributed :
      PermittedAttributionProposition
        C S F A B s (A.asserts source causalClaim)) :
    ¬SubstrateCommitment C S s causalClaim ∧
      SubstrateCommitment C S s (A.asserts source causalClaim) := by
  exact ⟨
    hnoDirect,
    substrateCommitment_of_permittedAttributionProposition B hattributed
  ⟩

/--
Causal and normative attributed propositions may both be carried without
direct commitment to either object-level proposition.
-/
example
    (hnoCausal :
      ¬SubstrateCommitment C S s causalClaim)
    (hnoNormative :
      ¬SubstrateCommitment C S s normativeClaim)
    (hcausal :
      PermittedAttributionProposition
        C S F A B s (A.asserts source causalClaim))
    (hnormative :
      PermittedAttributionProposition
        C S F A B s (A.asserts source normativeClaim)) :
    (¬SubstrateCommitment C S s causalClaim ∧
      ¬SubstrateCommitment C S s normativeClaim) ∧
    (SubstrateCommitment C S s (A.asserts source causalClaim) ∧
      SubstrateCommitment C S s (A.asserts source normativeClaim)) := by
  exact ⟨
    ⟨hnoCausal, hnoNormative⟩,
    ⟨
      substrateCommitment_of_permittedAttributionProposition B hcausal,
      substrateCommitment_of_permittedAttributionProposition B hnormative
    ⟩
  ⟩

end ReificationFragment

end SETest.NeutralSubstrate.Examples.ReificationFragment
