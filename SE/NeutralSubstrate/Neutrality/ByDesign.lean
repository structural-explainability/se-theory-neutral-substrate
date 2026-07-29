/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.NeutralSubstrate.DesignTimeGuarantee
public import SE.NeutralSubstrate.Neutrality.ExtensionStability
public import SE.NeutralSubstrate.Neutrality.InterpretiveNonCommitment

/-!
# Neutrality by Design

This module formalizes:

- `se100.def.NeutralityByDesign` — Neutrality by Design

A substrate is neutral when it satisfies both:

- interpretive non-commitment; and
- extension stability.

A substrate is neutral by design when its neutrality is guaranteed at design
time. The guarantee ranges over the complete intrinsic framework class
through the quantified definitions of interpretive non-commitment and
extension stability.

The design-time guarantee must arise from a permitted design-time basis. It
must not rest on enumerating only the admissible frameworks known when the
substrate is designed.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.Neutrality

open SE.Framework
open SE.Logic
open SE.Logic.Language
open SE.Referent
open SE.Substrate

universe u v w x y

public section

/--
A substrate is neutral when it satisfies interpretive non-commitment and
extension stability.
-/
def Neutral
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (S : SubstrateSystem.{u, v, w} L R)
    (s : S.Carrier)
    (M : FrameworkSystem.{u, x} L.carrier) :
    Prop :=
  InterpretiveNonCommitment C S s M ∧
    ExtensionStability C S s M

/--
A substrate is neutral exactly when it satisfies interpretive
non-commitment and extension stability.
-/
@[simp]
theorem neutral_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier} :
    Neutral C S s M ↔
      InterpretiveNonCommitment C S s M ∧
        ExtensionStability C S s M :=
  Iff.rfl

/--
A neutral substrate satisfies interpretive non-commitment.
-/
theorem interpretiveNonCommitment_of_neutral
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    (hneutral : Neutral C S s M) :
    InterpretiveNonCommitment C S s M :=
  hneutral.1

/--
A neutral substrate satisfies extension stability.
-/
theorem extensionStability_of_neutral
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    (hneutral : Neutral C S s M) :
    ExtensionStability C S s M :=
  hneutral.2

/--
A substrate is neutral by design when its neutrality is guaranteed by a
permitted design-time basis.
-/
def NeutralByDesign
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (S : SubstrateSystem.{u, v, w} L R)
    (s : S.Carrier)
    (M : FrameworkSystem.{u, x} L.carrier)
    (D : DesignTimeGuaranteeSystem.{y}) :
    Prop :=
  GuaranteedAtDesignTime D
    (Neutral C S s M)

/--
A substrate is neutral by design exactly when a permitted design-time basis
establishes its neutrality.
-/
@[simp]
theorem neutralByDesign_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    {D : DesignTimeGuaranteeSystem.{y}} :
    NeutralByDesign C S s M D ↔
      GuaranteedAtDesignTime D
        (Neutral C S s M) :=
  Iff.rfl

/--
Every substrate that is neutral by design is neutral.
-/
theorem neutral_of_neutralByDesign
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    {D : DesignTimeGuaranteeSystem.{y}}
    (hdesign : NeutralByDesign C S s M D) :
    Neutral C S s M :=
  holds_of_guaranteedAtDesignTime hdesign

/--
Neutrality by design entails interpretive non-commitment.
-/
theorem interpretiveNonCommitment_of_neutralByDesign
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    {D : DesignTimeGuaranteeSystem.{y}}
    (hdesign : NeutralByDesign C S s M D) :
    InterpretiveNonCommitment C S s M :=
  interpretiveNonCommitment_of_neutral
    (neutral_of_neutralByDesign hdesign)

/--
Neutrality by design entails extension stability.
-/
theorem extensionStability_of_neutralByDesign
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    {D : DesignTimeGuaranteeSystem.{y}}
    (hdesign : NeutralByDesign C S s M D) :
    ExtensionStability C S s M :=
  extensionStability_of_neutral
    (neutral_of_neutralByDesign hdesign)

end

end SE.NeutralSubstrate.Neutrality
