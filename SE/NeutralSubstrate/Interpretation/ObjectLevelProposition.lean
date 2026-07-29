/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.NeutralSubstrate.Attribution.Basic
public import SE.Substrate.Basic

/-!
# Object-Level Interpretive Propositions

This module formalizes:

- `se100.def.ObjectLevelInterpretiveProposition` — Object-Level Interpretive
  Proposition

An object-level interpretive proposition is an asserted proposition itself,
about the referents fixed by a substrate, rather than an attribution
proposition stating that some source asserts it.

The paper does not reduce proposition aboutness to a formal decision
procedure.
This module represents the relationship between a
proposition and a referential regime abstractly.

Being non-attributional is not sufficient.
An object-level interpretive proposition must also concern
the referents fixed by the substrate's referential regime.

No decidability, exhaustiveness, syntactic decomposition, or computational
classification assumption is imposed.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.Interpretation

open SE.Logic.Language
open SE.NeutralSubstrate.Attribution
open SE.Referent
open SE.Substrate

universe u v w x

public section

/--
An abstract account of whether an object-language proposition concerns the
referents fixed by a referential regime.

Concrete realizations may determine this relation through a typed
object-language, declared proposition roles, semantic interpretation, or
another fixed accountability-context method.
-/
structure ObjectLevelInterpretation
    (L : PropositionalLanguage.{u})
    (R : ReferentCarriers.{v}) where

  /--
  Whether a proposition concerns the referents fixed by a referential regime.
  -/
  aboutReferents :
    ReferentialRegime R →
    L.Proposition →
    Prop

/--
A proposition is object-level interpretive relative to a substrate when:

1. it concerns the referents fixed by that substrate's referential regime;
   and
2. it is not an attribution proposition.

The definition classifies the proposition.
It does not state that the substrate commits to that proposition.
-/
def ObjectLevelInterpretiveProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (A : AttributionSystem.{u, x} L)
    (I : ObjectLevelInterpretation.{u, v} L R)
    (S : SubstrateSystem.{u, v, w} L R)
    (s : S.Carrier)
    (p : L.Proposition) :
    Prop :=
  I.aboutReferents (S.referentialRegime s) p ∧
    ¬ AttributionProposition A p

/--
A proposition is object-level interpretive exactly when it concerns the
substrate-fixed referents and is not an attribution proposition.
-/
@[simp]
theorem objectLevelInterpretiveProposition_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {A : AttributionSystem.{u, x} L}
    {I : ObjectLevelInterpretation.{u, v} L R}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {p : L.Proposition} :
    ObjectLevelInterpretiveProposition A I S s p ↔
      I.aboutReferents (S.referentialRegime s) p ∧
        ¬ AttributionProposition A p :=
  Iff.rfl

/--
Every object-level interpretive proposition concerns the referents fixed by
the substrate's referential regime.
-/
theorem aboutReferents_of_objectLevelInterpretiveProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {A : AttributionSystem.{u, x} L}
    {I : ObjectLevelInterpretation.{u, v} L R}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : ObjectLevelInterpretiveProposition A I S s p) :
    I.aboutReferents (S.referentialRegime s) p :=
  hp.1

/--
No object-level interpretive proposition is an attribution proposition under
the selected attribution system.
-/
theorem not_attributionProposition_of_objectLevelInterpretiveProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {A : AttributionSystem.{u, x} L}
    {I : ObjectLevelInterpretation.{u, v} L R}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : ObjectLevelInterpretiveProposition A I S s p) :
    ¬ AttributionProposition A p :=
  hp.2

end

end SE.NeutralSubstrate.Interpretation
