/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.NeutralSubstrate.Assumptions.Contestability
public import SE.NeutralSubstrate.Assumptions.ReferentialCommonGround
public import SE.NeutralSubstrate.Interpretation.ObjectLevelCausalOrNormativeCommitment
public import SE.NeutralSubstrate.Neutrality.ByDesign
public import SE.NeutralSubstrate.FoundationalLayer

/-!
# Neutrality Constraint

This module formalizes:

- `se100.constraint.Neutrality` — Neutrality

For a substrate intended to remain usable by the complete intrinsic class of
admissible frameworks, and under Contestability and Referential Common
Ground, neutrality by design is equivalent to restricting the foundational
layer to:

- referential commitments; and
- permitted attribution propositions.

The constraint also records the resulting exclusion of object-level causal
or normative commitments.

The biconditional is represented as a constraint that a realization of the
abstract interfaces must satisfy. It is not asserted to follow from the
minimal consequence-system interfaces alone.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate

open SE.Framework
open SE.Logic
open SE.Logic.Language
open SE.NeutralSubstrate.Assumptions
open SE.NeutralSubstrate.Attribution
open SE.NeutralSubstrate.Classification
open SE.NeutralSubstrate.Interpretation
open SE.NeutralSubstrate.Neutrality
open SE.Referent
open SE.Substrate

universe u v w x y z t

public section

/--
A substrate makes no object-level causal or normative commitment when no
proposition satisfies the corresponding commitment predicate in the
selected accountability context.
-/
def NoObjectLevelCausalOrNormativeCommitment
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (K : CausalNormativeClassification.{u, x} L)
    (c : K.Context)
    (A : AttributionSystem.{u, y} L)
    (I : ObjectLevelInterpretation.{u, v} L R)
    (S : SubstrateSystem.{u, v, w} L R)
    (s : S.Carrier) :
    Prop :=
  ∀ p,
    ¬ ObjectLevelCausalOrNormativeCommitment
      C K c A I S s p

/--
The neutrality constraint states that, under Contestability and Referential
Common Ground:

1. neutrality by design is equivalent to restriction of the foundational
   layer to referential commitments and permitted attribution propositions;
   and
2. that restriction excludes every object-level causal or normative
   commitment.

The design-time guarantee ranges over the complete intrinsic framework class
through `NeutralByDesign`; it does not depend on framework enumeration.
-/
def NeutralityConstraint
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (K : CausalNormativeClassification.{u, x} L)
    (c : K.Context)
    (G : InterpretiveStatusFixing.{u, x} L K.Context)
    (S : SubstrateSystem.{u, v, w} L R)
    (F : ReferentialFixing L R)
    (A : AttributionSystem.{u, y} L)
    (B : AttributionalBasisFixing C A)
    (I : ObjectLevelInterpretation.{u, v} L R)
    (s : S.Carrier)
    (M : FrameworkSystem.{u, z} L.carrier)
    (D : DesignTimeGuaranteeSystem.{t}) :
    Prop :=
  Contestability C K c G S F s M D →
    ReferentialCommonGround C S F A B s M →
      (NeutralByDesign C S s M D ↔
        FoundationalLayerRestrictedToPermittedClasses
          C S F A B s) ∧
      (FoundationalLayerRestrictedToPermittedClasses
          C S F A B s →
        NoObjectLevelCausalOrNormativeCommitment
          C K c A I S s)

/--
Under the neutrality constraint, Contestability, and Referential Common
Ground, neutrality by design is equivalent to restriction of the
foundational layer to the permitted classes.
-/
theorem neutralByDesign_iff_foundationalLayerRestricted
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {K : CausalNormativeClassification.{u, x} L}
    {c : K.Context}
    {G : InterpretiveStatusFixing.{u, x} L K.Context}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, y} L}
    {B : AttributionalBasisFixing C A}
    {I : ObjectLevelInterpretation.{u, v} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, z} L.carrier}
    {D : DesignTimeGuaranteeSystem.{t}}
    (hconstraint :
      NeutralityConstraint C K c G S F A B I s M D)
    (hcontestability :
      Contestability C K c G S F s M D)
    (hcommonGround :
      ReferentialCommonGround C S F A B s M) :
    NeutralByDesign C S s M D ↔
      FoundationalLayerRestrictedToPermittedClasses
        C S F A B s :=
  (hconstraint hcontestability hcommonGround).1

/--
Under the neutrality constraint, restriction to the permitted foundational
classes excludes object-level causal or normative commitments.
-/
theorem noObjectLevelCommitment_of_foundationalLayerRestricted
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {K : CausalNormativeClassification.{u, x} L}
    {c : K.Context}
    {G : InterpretiveStatusFixing.{u, x} L K.Context}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, y} L}
    {B : AttributionalBasisFixing C A}
    {I : ObjectLevelInterpretation.{u, v} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, z} L.carrier}
    {D : DesignTimeGuaranteeSystem.{t}}
    (hconstraint :
      NeutralityConstraint C K c G S F A B I s M D)
    (hcontestability :
      Contestability C K c G S F s M D)
    (hcommonGround :
      ReferentialCommonGround C S F A B s M)
    (hrestricted :
      FoundationalLayerRestrictedToPermittedClasses
        C S F A B s) :
    NoObjectLevelCausalOrNormativeCommitment
      C K c A I S s :=
  (hconstraint hcontestability hcommonGround).2
    hrestricted

/--
Under the neutrality constraint, a substrate that is neutral by design makes
no object-level causal or normative commitment.
-/
theorem noObjectLevelCommitment_of_neutralByDesign
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {K : CausalNormativeClassification.{u, x} L}
    {c : K.Context}
    {G : InterpretiveStatusFixing.{u, x} L K.Context}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, y} L}
    {B : AttributionalBasisFixing C A}
    {I : ObjectLevelInterpretation.{u, v} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, z} L.carrier}
    {D : DesignTimeGuaranteeSystem.{t}}
    (hconstraint :
      NeutralityConstraint C K c G S F A B I s M D)
    (hcontestability :
      Contestability C K c G S F s M D)
    (hcommonGround :
      ReferentialCommonGround C S F A B s M)
    (hdesign :
      NeutralByDesign C S s M D) :
    NoObjectLevelCausalOrNormativeCommitment
      C K c A I S s := by
  have hrestricted :
      FoundationalLayerRestrictedToPermittedClasses
        C S F A B s :=
    (neutralByDesign_iff_foundationalLayerRestricted
      hconstraint
      hcontestability
      hcommonGround).mp hdesign
  exact
    noObjectLevelCommitment_of_foundationalLayerRestricted
      hconstraint
      hcontestability
      hcommonGround
      hrestricted

end

end SE.NeutralSubstrate
