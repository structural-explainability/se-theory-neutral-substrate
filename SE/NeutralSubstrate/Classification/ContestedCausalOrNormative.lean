/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.NeutralSubstrate.Classification.CausalNormative
public import SE.Substrate.ReferentialCommitments

/-!
# Contested Causal or Normative Propositions

This module formalizes:

- `se100.def.ContestedCausalNormative` —
  Contested Causal or Normative Proposition

A causal or normative proposition is contested in an accountability context
when its acceptance, rejection, interpretation, or application is not fixed
by the substrate's referential commitments.

The paper does not reduce this determination to entailment, syntax, or a
formal decision procedure. This module therefore represents the fixing of a
proposition's interpretive status as an abstract, context-relative relation.

A contested proposition may vary across admissible frameworks. The
definition does not require evidence of actual variation between two
frameworks. Actual opposed entailments are represented separately by
`FrameworkVariantProposition`.

No decidability, finiteness, enumeration, or computational classification
assumption is imposed.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.Classification

open SE.Logic
open SE.Logic.Language
open SE.Logic.Theory
open SE.Referent
open SE.Substrate

universe u v w x

public section

/--
An abstract account of whether the interpretive status of a proposition is
fixed by a commitment theory in an accountability context.

`fixedBy c T p` states that the acceptance, rejection, interpretation, or
application relevant to proposition `p` is fixed by commitment theory `T`
in context `c`.
-/
structure InterpretiveStatusFixing
    (L : PropositionalLanguage.{u})
    (Context : Type x) where

  /--
  Whether a commitment theory fixes the relevant interpretive status of a
  proposition in an accountability context.
  -/
  fixedBy :
    Context →
    CommitmentTheory L.carrier →
    L.Proposition →
    Prop

/--
A proposition is contested causal or normative when:

1. it is classified as causal or normative in the selected accountability
   context; and
2. its relevant interpretive status is not fixed by the substrate's
   referential commitments.

The definition does not assert that two admissible frameworks actually
produce opposed entailments.
-/
def ContestedCausalOrNormativeProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (K : CausalNormativeClassification.{u, x} L)
    (c : K.Context)
    (G : InterpretiveStatusFixing.{u, x} L K.Context)
    (S : SubstrateSystem.{u, v, w} L R)
    (F : ReferentialFixing L R)
    (s : S.Carrier)
    (p : L.Proposition) :
    Prop :=
  CausalOrNormativeProposition K c p ∧
    ¬ G.fixedBy
      c
      (ReferentialCommitments C S F s)
      p

/--
The class `C_cn` of contested causal or normative propositions for the
selected substrate and accountability context.
-/
def ContestedCausalOrNormativeClass
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (K : CausalNormativeClassification.{u, x} L)
    (c : K.Context)
    (G : InterpretiveStatusFixing.{u, x} L K.Context)
    (S : SubstrateSystem.{u, v, w} L R)
    (F : ReferentialFixing L R)
    (s : S.Carrier) :
    Set L.Proposition :=
  {p |
    ContestedCausalOrNormativeProposition
      C K c G S F s p}

/--
A proposition is contested causal or normative exactly when it is causal or
normative and its interpretive status is not fixed by the referential
commitments.
-/
@[simp]
theorem contestedCausalOrNormativeProposition_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {K : CausalNormativeClassification.{u, x} L}
    {c : K.Context}
    {G : InterpretiveStatusFixing.{u, x} L K.Context}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {s : S.Carrier}
    {p : L.Proposition} :
    ContestedCausalOrNormativeProposition C K c G S F s p ↔
      CausalOrNormativeProposition K c p ∧
        ¬ G.fixedBy
          c
          (ReferentialCommitments C S F s)
          p :=
  Iff.rfl

/--
Membership in `C_cn` is equivalent to being a contested causal or normative
proposition.
-/
@[simp]
theorem mem_contestedCausalOrNormativeClass_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {K : CausalNormativeClassification.{u, x} L}
    {c : K.Context}
    {G : InterpretiveStatusFixing.{u, x} L K.Context}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {s : S.Carrier}
    {p : L.Proposition} :
    p ∈ ContestedCausalOrNormativeClass C K c G S F s ↔
      ContestedCausalOrNormativeProposition C K c G S F s p :=
  Iff.rfl

/--
Every contested causal or normative proposition is classified as causal or
normative in the selected accountability context.
-/
theorem causalOrNormativeProposition_of_contestedCausalOrNormativeProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {K : CausalNormativeClassification.{u, x} L}
    {c : K.Context}
    {G : InterpretiveStatusFixing.{u, x} L K.Context}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : ContestedCausalOrNormativeProposition C K c G S F s p) :
    CausalOrNormativeProposition K c p :=
  hp.1

/--
The interpretive status of a contested causal or normative proposition is
not fixed by the substrate's referential commitments.
-/
theorem not_fixedBy_of_contestedCausalOrNormativeProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {K : CausalNormativeClassification.{u, x} L}
    {c : K.Context}
    {G : InterpretiveStatusFixing.{u, x} L K.Context}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : ContestedCausalOrNormativeProposition C K c G S F s p) :
    ¬ G.fixedBy
      c
      (ReferentialCommitments C S F s)
      p :=
  hp.2

end

end SE.NeutralSubstrate.Classification
