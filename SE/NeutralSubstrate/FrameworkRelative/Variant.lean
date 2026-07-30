/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Framework.Class
public import SE.Logic.Theory.TheoryExtension
public import SE.Substrate.Basic
public import SE.Substrate.Commitment

/-!
# Framework-Variant Propositions

This module formalizes:

- `se100.def.FrameworkVariant` — Framework-Variant Proposition

A proposition is framework-variant with respect to a substrate and the
framework class when there exist two admissible frameworks such that the
substrate combined with one framework entails the proposition, while the
substrate combined with the other entails its object-language negation.

The two witnessing frameworks are not required to be distinct. No
decidability, finiteness, enumeration, or effective search procedure for the
framework class is assumed.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.FrameworkRelative

open SE.Framework
open SE.Logic
open SE.Logic.Language
open SE.Logic.Theory
open SE.Referent
open SE.Substrate

universe u v w x

public section

/--
The commitment theory obtained by combining a substrate's commitments with
an interpretive framework's commitments.

This formalizes the paper's notation `S ∪ F`.
-/
@[expose]
def SubstrateFrameworkCommitments
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (S : SubstrateSystem.{u, v, w} L R)
    (s : S.Carrier)
    (M : FrameworkSystem.{u, x} L.carrier)
    (framework : M.Carrier) :
    CommitmentTheory L.carrier :=
  combine (S.commitments s) (M.commitments framework)

/--
The substrate-framework commitment theory is
the union of the substrate's commitments
with the framework's commitments.
-/
@[simp]
theorem substrateFrameworkCommitments_eq
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    {framework : M.Carrier} :
    SubstrateFrameworkCommitments S s M framework
      = combine (S.commitments s) (M.commitments framework) :=
  rfl

/--
A substrate-layer commitment remains entailed after combining the substrate
with any framework.
-/
theorem entails_substrateFrameworkCommitments_of_substrateCommitment
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    {framework : M.Carrier}
    {p : L.Proposition}
    (hp : SubstrateCommitment C S s p) :
    C.entails
      (SubstrateFrameworkCommitments S s M framework)
      p :=
  C.entailsMono
    (subset_combine_left
      (S.commitments s)
      (M.commitments framework))
    (entails_of_substrateCommitment hp)

/--
A proposition is framework-variant with respect to a substrate and framework
class when there exist admissible frameworks such that one corresponding
substrate-framework theory entails the proposition and another entails its
object-language negation.
-/
def FrameworkVariantProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (S : SubstrateSystem.{u, v, w} L R)
    (s : S.Carrier)
    (M : FrameworkSystem.{u, x} L.carrier)
    (p : L.Proposition) :
    Prop :=
  ∃ frameworkOne frameworkTwo,
    frameworkOne ∈ FrameworkClass C M ∧
      frameworkTwo ∈ FrameworkClass C M ∧
        C.entails
          (SubstrateFrameworkCommitments S s M frameworkOne)
          p ∧
        C.entails
          (SubstrateFrameworkCommitments S s M frameworkTwo)
          (L.neg p)

/--
A proposition is framework-variant exactly when it has two admissible
framework witnesses giving the opposed entailments required by the
definition.
-/
@[simp]
theorem frameworkVariantProposition_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    {p : L.Proposition} :
    FrameworkVariantProposition C S s M p ↔
      ∃ frameworkOne frameworkTwo,
        frameworkOne ∈ FrameworkClass C M ∧
          frameworkTwo ∈ FrameworkClass C M ∧
            C.entails
              (SubstrateFrameworkCommitments S s M frameworkOne)
              p ∧
            C.entails
              (SubstrateFrameworkCommitments S s M frameworkTwo)
              (L.neg p) :=
  Iff.rfl

/--
A framework-variant proposition is entailed by the substrate combined with
some admissible framework.
-/
theorem exists_entails_of_frameworkVariantProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    {p : L.Proposition}
    (hp : FrameworkVariantProposition C S s M p) :
    ∃ framework,
      framework ∈ FrameworkClass C M ∧
        C.entails
          (SubstrateFrameworkCommitments S s M framework)
          p := by
  rcases hp with
    ⟨frameworkOne, frameworkTwo, hOne, hTwo, hp, hneg⟩
  exact ⟨frameworkOne, hOne, hp⟩

/--
The object-language negation of a framework-variant proposition is entailed
by the substrate combined with some admissible framework.
-/
theorem exists_entailsNeg_of_frameworkVariantProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    {p : L.Proposition}
    (hp : FrameworkVariantProposition C S s M p) :
    ∃ framework,
      framework ∈ FrameworkClass C M ∧
        C.entails
          (SubstrateFrameworkCommitments S s M framework)
          (L.neg p) := by
  rcases hp with
    ⟨frameworkOne, frameworkTwo, hOne, hTwo, hp, hneg⟩
  exact ⟨frameworkTwo, hTwo, hneg⟩

end

end SE.NeutralSubstrate.FrameworkRelative
