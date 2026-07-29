/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.NeutralSubstrate.Classification.ContestedCausalOrNormative
public import SE.NeutralSubstrate.DesignTimeGuarantee
public import SE.NeutralSubstrate.FrameworkRelative.Invariant

/-!
# Contestability

This module formalizes:

- `se100.assump.Contestability` — Contestability

Contestability states that no contested causal or normative proposition is
guaranteed framework-invariant at design time.

The assumption does not state that every contested proposition is actually
framework-variant. It states that framework invariance for such a proposition
cannot be established from a permitted design-time basis.

No decidability, finiteness, enumeration, or effective search procedure is
assumed.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.Assumptions

open SE.Framework
open SE.Logic
open SE.Logic.Language
open SE.NeutralSubstrate.Classification
open SE.NeutralSubstrate.FrameworkRelative
open SE.Referent
open SE.Substrate

universe u v w x y z

public section

/--
No contested causal or normative proposition is guaranteed
framework-invariant at design time.

This formalizes the paper's condition that no `p ∈ C_cn` is guaranteed
framework-invariant at design time.
-/
def Contestability
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (K : CausalNormativeClassification.{u, x} L)
    (c : K.Context)
    (G : InterpretiveStatusFixing.{u, x} L K.Context)
    (S : SubstrateSystem.{u, v, w} L R)
    (F : ReferentialFixing L R)
    (s : S.Carrier)
    (M : FrameworkSystem.{u, y} L.carrier)
    (D : DesignTimeGuaranteeSystem.{z}) :
    Prop :=
  ∀ p,
    p ∈ ContestedCausalOrNormativeClass C K c G S F s →
      ¬ GuaranteedAtDesignTime D
        (FrameworkInvariantProposition C S s M p)

/--
Contestability holds exactly when no member of the contested causal or
normative class is guaranteed framework-invariant at design time.
-/
@[simp]
theorem contestability_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {K : CausalNormativeClassification.{u, x} L}
    {c : K.Context}
    {G : InterpretiveStatusFixing.{u, x} L K.Context}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, y} L.carrier}
    {D : DesignTimeGuaranteeSystem.{z}} :
    Contestability C K c G S F s M D ↔
      ∀ p,
        p ∈ ContestedCausalOrNormativeClass C K c G S F s →
          ¬ GuaranteedAtDesignTime D
            (FrameworkInvariantProposition C S s M p) :=
  Iff.rfl

/--
A contested causal or normative proposition is not guaranteed
framework-invariant at design time.
-/
theorem not_guaranteedFrameworkInvariant_of_contestability
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {K : CausalNormativeClassification.{u, x} L}
    {c : K.Context}
    {G : InterpretiveStatusFixing.{u, x} L K.Context}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, y} L.carrier}
    {D : DesignTimeGuaranteeSystem.{z}}
    (hcontestability : Contestability C K c G S F s M D)
    {p : L.Proposition}
    (hp : p ∈ ContestedCausalOrNormativeClass C K c G S F s) :
    ¬ GuaranteedAtDesignTime D
      (FrameworkInvariantProposition C S s M p) :=
  hcontestability p hp

end

end SE.NeutralSubstrate.Assumptions
