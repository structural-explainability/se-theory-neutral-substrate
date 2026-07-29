/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.NeutralSubstrate.Attribution.Permitted

/-!
# Reification Fragment

Worked Lean examples for
`se100.example.ReificationFragment`.

The examples represent a decision record containing referential commitments
together with causal and normative claims attributed to a source.

The neutral form commits to the attribution propositions

`A.asserts source causalClaim`

and

`A.asserts source normativeClaim`

without thereby committing directly to `causalClaim` or `normativeClaim`.

This module introduces no additional public theory declarations.
-/

namespace SE.NeutralSubstrate.Examples

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

variable
  {subjectClaim : L.Proposition}
  {decisionClaim : L.Proposition}
  {instrumentClaim : L.Proposition}
  {policyClaim : L.Proposition}
  {occurredAtClaim : L.Proposition}
  {involvedClaim : L.Proposition}
  {usedInstrumentClaim : L.Proposition}
  {citesPolicyClaim : L.Proposition}

variable
  {causalClaim : L.Proposition}
  {normativeClaim : L.Proposition}

/--
A causal claim attributed to a source is an attribution proposition.
-/
example :
    AttributionProposition A (A.asserts source causalClaim) :=
  attributionProposition_asserts A source causalClaim

/--
A normative claim attributed to a source is an attribution proposition.
-/
example :
    AttributionProposition A (A.asserts source normativeClaim) :=
  attributionProposition_asserts A source normativeClaim

/--
The referential claims in the worked example are substrate commitments when
they belong to the substrate's referential commitments.
-/
example
    (hsubject :
      subjectClaim ∈ ReferentialCommitments C S F s)
    (hdecision :
      decisionClaim ∈ ReferentialCommitments C S F s)
    (hinstrument :
      instrumentClaim ∈ ReferentialCommitments C S F s)
    (hpolicy :
      policyClaim ∈ ReferentialCommitments C S F s)
    (hoccurredAt :
      occurredAtClaim ∈ ReferentialCommitments C S F s)
    (hinvolved :
      involvedClaim ∈ ReferentialCommitments C S F s)
    (husedInstrument :
      usedInstrumentClaim ∈ ReferentialCommitments C S F s)
    (hcitesPolicy :
      citesPolicyClaim ∈ ReferentialCommitments C S F s) :
    SubstrateCommitment C S s subjectClaim ∧
      SubstrateCommitment C S s decisionClaim ∧
      SubstrateCommitment C S s instrumentClaim ∧
      SubstrateCommitment C S s policyClaim ∧
      SubstrateCommitment C S s occurredAtClaim ∧
      SubstrateCommitment C S s involvedClaim ∧
      SubstrateCommitment C S s usedInstrumentClaim ∧
      SubstrateCommitment C S s citesPolicyClaim := by
  exact ⟨
    substrateCommitment_of_mem_referentialCommitments hsubject,
    substrateCommitment_of_mem_referentialCommitments hdecision,
    substrateCommitment_of_mem_referentialCommitments hinstrument,
    substrateCommitment_of_mem_referentialCommitments hpolicy,
    substrateCommitment_of_mem_referentialCommitments hoccurredAt,
    substrateCommitment_of_mem_referentialCommitments hinvolved,
    substrateCommitment_of_mem_referentialCommitments husedInstrument,
    substrateCommitment_of_mem_referentialCommitments hcitesPolicy
  ⟩

/--
Permitted attributed causal and normative claims are substrate commitments.
-/
example
    (hcausal :
      PermittedAttributionProposition
        C S F A B s (A.asserts source causalClaim))
    (hnormative :
      PermittedAttributionProposition
        C S F A B s (A.asserts source normativeClaim)) :
    SubstrateCommitment C S s (A.asserts source causalClaim) ∧
      SubstrateCommitment C S s (A.asserts source normativeClaim) := by
  exact ⟨
    substrateCommitment_of_permittedAttributionProposition B hcausal,
    substrateCommitment_of_permittedAttributionProposition B hnormative
  ⟩

/--
The reified form preserves attributed causal and normative content while the
corresponding object-level propositions remain outside the substrate's direct
commitments.
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

end SE.NeutralSubstrate.Examples
