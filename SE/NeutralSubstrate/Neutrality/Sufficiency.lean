/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.NeutralSubstrate.Assumptions.ReferentialCommonGround
public import SE.NeutralSubstrate.FoundationalLayer
public import SE.NeutralSubstrate.Neutrality.ByDesign
public import SE.NeutralSubstrate.Neutrality.PropertyRelation

/-!
# Sufficiency of the Foundational-Layer Restriction

The semantic sufficiency direction of `se100.constraint.Neutrality`:
under Referential Common Ground, restricting the foundational layer
to referential commitments and permitted attribution propositions
makes the substrate neutral.

Extension stability follows by generalized cut: every member of the
substrate's commitment theory is, by the restriction, entailed by the
referential commitments, which Referential Common Ground keeps consistent
with every admissible framework.
Interpretive non-commitment then follows from `se100.remark.PropertyRelation`.

This does not establish neutrality *by design*.
`NeutralByDesign` ranges over an arbitrary `DesignTimeGuaranteeSystem`
and requires a permitted basis.
Discharging that wrapper is left to a canonical design-time-guarantee
realization.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.Neutrality

open SE.Framework
open SE.Logic
open SE.Logic.Language
open SE.Logic.Theory
open SE.NeutralSubstrate.Assumptions
open SE.NeutralSubstrate.Attribution
open SE.NeutralSubstrate.FrameworkRelative
open SE.Referent
open SE.Substrate

universe u v w x y

public section

/--
Under Referential Common Ground, a foundational layer restricted to the
permitted classes yields extension stability.
-/
theorem extensionStability_of_restricted_of_commonGround
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, x} L}
    {B : AttributionalBasisFixing C A}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, y} L.carrier}
    (hrestricted :
      FoundationalLayerRestrictedToPermittedClasses C S F A B s)
    (hcommonGround :
      ReferentialCommonGround C S F A B s M) :
    ExtensionStability C S s M := by
  rw [extensionStability_iff]
  intro framework hframework
  have hRef :
      Consistent C
        (combine
          (ReferentialCommitments C S F s)
          (M.commitments framework)) :=
    consistent_referentialCommitments_of_referentialCommonGround
      hcommonGround hframework
  apply consistent_of_not_entailsBottom
  intro hbot
  apply not_entailsBottom_of_consistent hRef
  rw [substrateFrameworkCommitments_eq] at hbot
  refine C.cut
      (T := combine (ReferentialCommitments C S F s) (M.commitments framework))
      (U := combine (S.commitments s) (M.commitments framework))
      ?_ hbot
  intro q hq
  rcases mem_combine_iff.mp hq with hqS | hqF
  · have hcommit : SubstrateCommitment C S s q :=
      substrateCommitment_of_entails (C.entailsOfMem hqS)
    have hqref : C.entails (ReferentialCommitments C S F s) q := by
      rcases (foundationalLayerRestrictedToPermittedClasses_iff.mp hrestricted)
        q hcommit
        with hmem | hperm
      · exact C.entailsOfMem hmem
      · exact referentialCommitments_entails_of_permittedAttributionProposition B hperm
    exact C.entailsMono (subset_combine_left _ _) hqref
  · exact C.entailsOfMem (mem_combine_iff.mpr (Or.inr hqF))

/--
Under Referential Common Ground, a foundational layer restricted to the
permitted classes is neutral.
-/
theorem neutral_of_restricted_of_commonGround
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, x} L}
    {B : AttributionalBasisFixing C A}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, y} L.carrier}
    (hrestricted :
      FoundationalLayerRestrictedToPermittedClasses C S F A B s)
    (hcommonGround :
      ReferentialCommonGround C S F A B s M) :
    Neutral C S s M :=
  let hES :=
    extensionStability_of_restricted_of_commonGround
      hrestricted hcommonGround
  neutral_iff.mpr ⟨interpretiveNonCommitment_of_extensionStability hES, hES⟩

end

end SE.NeutralSubstrate.Neutrality
