/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.NeutralSubstrate.Attribution.Permitted
public import SE.NeutralSubstrate.FrameworkRelative.CompatibleCommitmentSet

/-!
# Referential Common Ground

This module formalizes:

- `se100.assump.ReferentialCommonGround` —
  Referential Common Ground

Referential common ground requires the substrate's referential commitments
to remain compatible with every admissible framework.

It also requires that adjoining any permitted attribution proposition to the
referential commitments remains compatible with every admissible framework.

The quantification ranges over the complete framework class, not merely over
frameworks known when the substrate is designed. No enumeration of that class
is assumed.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.Assumptions

open SE.Framework
open SE.Logic
open SE.Logic.Language
open SE.Logic.Theory
open SE.NeutralSubstrate.Attribution
open SE.NeutralSubstrate.FrameworkRelative
open SE.Referent
open SE.Substrate

universe u v w x y

public section

/--
Referential common ground holds when:

1. the substrate's referential commitments are compatible with every
   admissible framework; and
2. adjoining any permitted attribution proposition to those referential
   commitments remains compatible with every admissible framework.

The second condition formalizes:

`Sref ∪ {asserts x φ} ∪ F ⊬ ⊥`.
-/
def ReferentialCommonGround
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (S : SubstrateSystem.{u, v, w} L R)
    (F : ReferentialFixing L R)
    (A : AttributionSystem.{u, x} L)
    (B : AttributionalBasisFixing C A)
    (s : S.Carrier)
    (M : FrameworkSystem.{u, y} L.carrier) :
    Prop :=
  FrameworkCompatibleCommitmentSet
      C
      M
      (ReferentialCommitments C S F s) ∧
    ∀ p,
      PermittedAttributionProposition C S F A B s p →
        FrameworkCompatibleCommitmentSet
          C
          M
          (adjoin
            (ReferentialCommitments C S F s)
            p)

/--
Referential common ground holds exactly when the referential commitments and
each permitted-attribution extension are framework-compatible.
-/
@[simp]
theorem referentialCommonGround_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, x} L}
    {B : AttributionalBasisFixing C A}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, y} L.carrier} :
    ReferentialCommonGround C S F A B s M ↔
      FrameworkCompatibleCommitmentSet
          C
          M
          (ReferentialCommitments C S F s) ∧
        ∀ p,
          PermittedAttributionProposition C S F A B s p →
            FrameworkCompatibleCommitmentSet
              C
              M
              (adjoin
                (ReferentialCommitments C S F s)
                p) :=
  Iff.rfl

/--
The substrate's referential commitments are compatible with every admissible
framework.
-/
theorem referentialCommitments_compatible_of_referentialCommonGround
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, x} L}
    {B : AttributionalBasisFixing C A}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, y} L.carrier}
    (hcommonGround : ReferentialCommonGround C S F A B s M) :
    FrameworkCompatibleCommitmentSet
      C
      M
      (ReferentialCommitments C S F s) :=
  hcommonGround.1

/--
Adjoining a permitted attribution proposition to the referential
commitments produces a framework-compatible commitment set.
-/
theorem permittedAttribution_compatible_of_referentialCommonGround
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, x} L}
    {B : AttributionalBasisFixing C A}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, y} L.carrier}
    (hcommonGround : ReferentialCommonGround C S F A B s M)
    {p : L.Proposition}
    (hp : PermittedAttributionProposition C S F A B s p) :
    FrameworkCompatibleCommitmentSet
      C
      M
      (adjoin
        (ReferentialCommitments C S F s)
        p) :=
  hcommonGround.2 p hp

/--
The referential commitments remain consistent with the commitments of any
admissible framework.
-/
theorem consistent_referentialCommitments_of_referentialCommonGround
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, x} L}
    {B : AttributionalBasisFixing C A}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, y} L.carrier}
    (hcommonGround : ReferentialCommonGround C S F A B s M)
    {framework : M.Carrier}
    (hframework : framework ∈ FrameworkClass C M) :
    Consistent C
      (combine
        (ReferentialCommitments C S F s)
        (M.commitments framework)) :=
  consistent_combine_of_frameworkCompatibleCommitmentSet
    (referentialCommitments_compatible_of_referentialCommonGround
      hcommonGround)
    hframework

/--
The referential commitments together with any permitted attribution
proposition remain consistent with the commitments of any admissible
framework.
-/
theorem consistent_permittedAttribution_of_referentialCommonGround
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, x} L}
    {B : AttributionalBasisFixing C A}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, y} L.carrier}
    (hcommonGround : ReferentialCommonGround C S F A B s M)
    {p : L.Proposition}
    (hp : PermittedAttributionProposition C S F A B s p)
    {framework : M.Carrier}
    (hframework : framework ∈ FrameworkClass C M) :
    Consistent C
      (combine
        (adjoin
          (ReferentialCommitments C S F s)
          p)
        (M.commitments framework)) :=
  consistent_combine_of_frameworkCompatibleCommitmentSet
    (permittedAttribution_compatible_of_referentialCommonGround
      hcommonGround
      hp)
    hframework

end

end SE.NeutralSubstrate.Assumptions
