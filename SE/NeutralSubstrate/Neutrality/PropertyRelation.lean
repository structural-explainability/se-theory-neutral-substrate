/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.NeutralSubstrate.Neutrality.ExtensionStability
public import SE.NeutralSubstrate.Neutrality.InterpretiveNonCommitment

/-!
# Relation Between the Neutrality Properties

This module formalizes:

- `se100.remark.PropertyRelation` —
  Relation Between the Two Properties

Extension stability entails interpretive non-commitment.

Suppose that `p` is framework-variant.
One admissible framework supports `p`,
while another supports its object-language negation.

If the substrate committed to `p`, that commitment would remain available
when the substrate was combined with the framework supporting `¬p`.
The combined theory would then entail both `p` and `¬p`, and therefore entail
contradiction.

Similarly, if the substrate committed to `¬p`, combining it with the
framework supporting `p` would entail contradiction.

Extension stability rules out both cases.

Only this direction is established.
Interpretive non-commitment is not claimed to imply extension stability.
The properties retain separate names because they identify distinct design failures:
commitment to disputed content and failure of layerability.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.Neutrality

open SE.Framework
open SE.Logic
open SE.Logic.Language
open SE.NeutralSubstrate.FrameworkRelative
open SE.Referent
open SE.Substrate

universe u v w x

public section

/--
Extension stability entails interpretive non-commitment.

A substrate that remains consistent with every admissible framework cannot
commit to either side of a framework-variant proposition.
-/
theorem interpretiveNonCommitment_of_extensionStability
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    (hstability : ExtensionStability C S s M) :
    InterpretiveNonCommitment C S s M := by
  apply interpretiveNonCommitment_iff.mpr
  intro p hvariant
  constructor
  · intro hcommitment
    rcases
        exists_entailsNeg_of_frameworkVariantProposition hvariant with
      ⟨framework, hframework, hneg⟩
    have hp :
        C.entails
          (SubstrateFrameworkCommitments S s M framework)
          p :=
      entails_substrateFrameworkCommitments_of_substrateCommitment
        hcommitment
    have hbottom :
        C.entails
          (SubstrateFrameworkCommitments S s M framework)
          L.bottom :=
      C.contradiction hp hneg
    exact
      (not_entailsBottom_of_consistent
        (consistent_substrateFrameworkCommitments_of_extensionStability
          hstability
          hframework))
        hbottom
  · intro hcommitment
    rcases
        exists_entails_of_frameworkVariantProposition hvariant with
      ⟨framework, hframework, hp⟩
    have hneg :
        C.entails
          (SubstrateFrameworkCommitments S s M framework)
          (L.neg p) :=
      entails_substrateFrameworkCommitments_of_substrateCommitment
        hcommitment
    have hbottom :
        C.entails
          (SubstrateFrameworkCommitments S s M framework)
          L.bottom :=
      C.contradiction hp hneg
    exact
      (not_entailsBottom_of_consistent
        (consistent_substrateFrameworkCommitments_of_extensionStability
          hstability
          hframework))
        hbottom

end

end SE.NeutralSubstrate.Neutrality
