module

public import SE.NeutralSubstrate.Attribution.Basic
public import SE.Substrate.SubstrateSystem

/-!
**# Object-Level Interpretive Propositions**

This module formalizes:

- `se100.def.ObjectLevelInterpretiveProposition` - Object-Level Interpretive
  Proposition

An object-level interpretive proposition is an object-language proposition
whose subject matter concerns the referential domain governed by a
substrate's referential regime, rather than an attribution proposition
stating that some source asserts it.

The relationship between proposition content and a referential regime is
represented abstractly.
This module does not define a denotation relation from
proposition content or references to particular referent-carrier elements.

Being non-attributional is not sufficient.
An object-level interpretive proposition must also concern
the referential subject matter governed by the substrate's referential regime.

In particular, `aboutReferents` does not by itself establish:

- denotation of a particular carrier element;
- co-reference;
- same-unit identity;
- persistence;
- carrier equality; or
- referential fixing of the proposition.

No decidability, exhaustiveness, syntactic decomposition, denotation
procedure, or computational classification assumption is imposed.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.Interpretation

open SE.Logic.Language
open SE.NeutralSubstrate.Attribution
open SE.Referent
open SE.Substrate

universe u v w x

public section

-- RR.DEFINES: SE.NeutralSubstrate.Interpretation.ObjectLevelInterpretation
/--
An abstract account of whether an object-language proposition concerns the
referential subject matter governed by a referential regime.

Concrete realizations may determine this relation through a typed
object-language, declared proposition roles, semantic interpretation, or
another fixed accountability-context method.

This interface classifies proposition subject matter. It does not supply the
deferred denotation or co-reference lifting bridges and does not identify
aboutness with referential fixing.
-/
structure ObjectLevelInterpretation
    (L : PropositionalLanguage.{u})
    (R : ReferentCarriers.{v}) where

  /--
  Whether a proposition concerns the referential subject matter governed by
  a referential regime.
  -/
  aboutReferents :
    ReferentialRegime R →
    L.Proposition →
    Prop

-- RR.DEFINES: SE.NeutralSubstrate.Interpretation.ObjectLevelInterpretiveProposition
-- RR.IMPLEMENTS: se100.def.ObjectLevelInterpretiveProposition
/--
A proposition is object-level interpretive relative to a substrate when:

1. it concerns the referential subject matter governed by that substrate's
   referential regime; and
2. it is not an attribution proposition.

The definition classifies the proposition. It does not state that the
substrate commits to that proposition or that the proposition denotes any
particular referent-carrier element.
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

-- RR.DEFINES: SE.NeutralSubstrate.Interpretation.objectLevelInterpretiveProposition_iff
/--
A proposition is object-level interpretive exactly when it concerns the
referential subject matter governed by the substrate's referential regime
and is not an attribution proposition.
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

-- RR.DEFINES: SE.NeutralSubstrate.Interpretation.aboutReferents_of_objectLevelInterpretiveProposition
/--
Every object-level interpretive proposition concerns the referential subject
matter governed by the substrate's referential regime.
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

-- RR.DEFINES: SE.NeutralSubstrate.Interpretation.not_attributionProposition_of_objectLevelInterpretiveProposition
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
