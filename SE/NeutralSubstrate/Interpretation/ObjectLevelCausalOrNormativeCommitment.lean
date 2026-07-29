/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.NeutralSubstrate.Classification.CausalNormative
public import SE.NeutralSubstrate.Interpretation.ObjectLevelProposition
public import SE.Substrate.Commitment

/-!
# Object-Level Causal or Normative Commitment

This module formalizes:

- `se100.def.ObjectLevelCausalNormativeCommitment` —
  Object-Level Causal or Normative Commitment

An object-level causal or normative proposition is an object-level
interpretive proposition whose content is classified as causal or normative
in the relevant accountability context.

An object-level causal or normative commitment is a substrate-layer
commitment to such a proposition, rather than a commitment to an attribution
proposition about it.

No decidability, exhaustiveness, or computational classification assumption
is imposed.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.Interpretation

open SE.Logic
open SE.Logic.Language
open SE.NeutralSubstrate.Attribution
open SE.NeutralSubstrate.Classification
open SE.Referent
open SE.Substrate

universe u v w x y

public section

/--
An object-level causal or normative proposition is an object-level
interpretive proposition whose content is classified as causal or normative
in the selected accountability context.
-/
def ObjectLevelCausalOrNormativeProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (K : CausalNormativeClassification.{u, y} L)
    (c : K.Context)
    (A : AttributionSystem.{u, x} L)
    (I : ObjectLevelInterpretation.{u, v} L R)
    (S : SubstrateSystem.{u, v, w} L R)
    (s : S.Carrier)
    (p : L.Proposition) :
    Prop :=
  ObjectLevelInterpretiveProposition A I S s p ∧
    CausalOrNormativeProposition K c p

/--
An object-level causal or normative commitment is a substrate-layer
commitment to an object-level causal or normative proposition.
-/
def ObjectLevelCausalOrNormativeCommitment
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (K : CausalNormativeClassification.{u, y} L)
    (c : K.Context)
    (A : AttributionSystem.{u, x} L)
    (I : ObjectLevelInterpretation.{u, v} L R)
    (S : SubstrateSystem.{u, v, w} L R)
    (s : S.Carrier)
    (p : L.Proposition) :
    Prop :=
  SubstrateCommitment C S s p ∧
    ObjectLevelCausalOrNormativeProposition K c A I S s p

/--
A proposition is an object-level causal or normative commitment exactly when
the substrate commits to it and it is an object-level causal or normative
proposition.
-/
@[simp]
theorem objectLevelCausalOrNormativeCommitment_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {K : CausalNormativeClassification.{u, y} L}
    {c : K.Context}
    {A : AttributionSystem.{u, x} L}
    {I : ObjectLevelInterpretation.{u, v} L R}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {p : L.Proposition} :
    ObjectLevelCausalOrNormativeCommitment C K c A I S s p ↔
      SubstrateCommitment C S s p ∧
        ObjectLevelCausalOrNormativeProposition K c A I S s p :=
  Iff.rfl

/--
Every object-level causal or normative commitment is a substrate-layer
commitment.
-/
theorem substrateCommitment_of_objectLevelCausalOrNormativeCommitment
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {K : CausalNormativeClassification.{u, y} L}
    {c : K.Context}
    {A : AttributionSystem.{u, x} L}
    {I : ObjectLevelInterpretation.{u, v} L R}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : ObjectLevelCausalOrNormativeCommitment C K c A I S s p) :
    SubstrateCommitment C S s p :=
  hp.1

/--
Every object-level causal or normative commitment concerns the referents
fixed by the substrate.
-/
theorem objectLevelInterpretiveProposition_of_objectLevelCausalOrNormativeCommitment
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {K : CausalNormativeClassification.{u, y} L}
    {c : K.Context}
    {A : AttributionSystem.{u, x} L}
    {I : ObjectLevelInterpretation.{u, v} L R}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : ObjectLevelCausalOrNormativeCommitment C K c A I S s p) :
    ObjectLevelInterpretiveProposition A I S s p :=
  hp.2.1

/--
Every object-level causal or normative commitment has causal or normative
content in the selected accountability context.
-/
theorem causalOrNormativeProposition_of_objectLevelCausalOrNormativeCommitment
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {K : CausalNormativeClassification.{u, y} L}
    {c : K.Context}
    {A : AttributionSystem.{u, x} L}
    {I : ObjectLevelInterpretation.{u, v} L R}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : ObjectLevelCausalOrNormativeCommitment C K c A I S s p) :
    CausalOrNormativeProposition K c p :=
  hp.2.2

end

end SE.NeutralSubstrate.Interpretation
