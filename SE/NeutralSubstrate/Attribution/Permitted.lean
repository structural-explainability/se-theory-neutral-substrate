/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.NeutralSubstrate.Attribution.Basic
public import SE.Substrate.ReferentialCommitments

/-!
# Permitted Attribution Propositions

This module formalizes:

- `se100.def.PermittedAttributionProposition` —
  Permitted Attribution Proposition

An attribution proposition `asserts x φ` is permitted at the foundational
layer when the attributional basis for `x`'s assertion of `φ` is fixed by the
substrate's referential commitments.

The attributional basis includes the source, assertion occurrence,
provenance, and content reference needed to identify what was asserted, by
whom, and under what record basis.

Because the attributional basis is fixed by the referential commitments, the
referential commitments entail the attribution proposition. This commits the
substrate to the attribution, not to the asserted proposition `φ`.

The structure of an attributional basis remains abstract.
No finiteness, enumeration, decidability, or computational representation is assumed.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.Attribution

open SE.Logic
open SE.Logic.Language
open SE.Logic.Theory
open SE.Referent
open SE.Substrate

universe u v w x

public section

/--
An abstract account of when an attributional basis is fixed by a commitment
theory.

`fixedBy T x φ` states that `T` fixes the source, assertion occurrence,
provenance, and content reference needed to identify `x`'s assertion of `φ`.

Fixing the attributional basis is required to determine the corresponding
attribution proposition.
-/
structure AttributionalBasisFixing
    {L : PropositionalLanguage.{u}}
    (C : ConsequenceSystem L)
    (A : AttributionSystem.{u, x} L) where

  /--
  Whether a commitment theory fixes the attributional basis for a source's
  assertion of a proposition.
  -/
  fixedBy :
    CommitmentTheory L.carrier →
    A.Source →
    L.Proposition →
    Prop

  /--
  A commitment theory that fixes an attributional basis entails the
  corresponding attribution proposition.
  -/
  entailsAssertsOfFixedBy :
    ∀ {T : CommitmentTheory L.carrier}
      {source : A.Source}
      {φ : L.Proposition},
      fixedBy T source φ →
      C.entails T (A.asserts source φ)

/--
An attribution proposition is permitted at the foundational layer when its
attributional basis is fixed by the substrate's referential commitments.
-/
def PermittedAttributionProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (S : SubstrateSystem.{u, v, w} L R)
    (F : ReferentialFixing L R)
    (A : AttributionSystem.{u, x} L)
    (B : AttributionalBasisFixing C A)
    (s : S.Carrier)
    (p : L.Proposition) :
    Prop :=
  ∃ source φ,
    p = A.asserts source φ ∧
      B.fixedBy (ReferentialCommitments C S F s) source φ

/--
A proposition is permitted exactly when it is an attribution proposition
whose attributional basis is fixed by the substrate's referential
commitments.
-/
@[simp]
theorem permittedAttributionProposition_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, x} L}
    {B : AttributionalBasisFixing C A}
    {s : S.Carrier}
    {p : L.Proposition} :
    PermittedAttributionProposition C S F A B s p ↔
      ∃ source φ,
        p = A.asserts source φ ∧
          B.fixedBy
            (ReferentialCommitments C S F s)
            source
            φ :=
  Iff.rfl

/--
Every permitted attribution proposition is an attribution proposition.
-/
theorem attributionProposition_of_permittedAttributionProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, x} L}
    {B : AttributionalBasisFixing C A}
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : PermittedAttributionProposition C S F A B s p) :
    AttributionProposition A p := by
  rcases hp with ⟨source, φ, hp, _⟩
  subst p
  exact attributionProposition_asserts A source φ

/--
The substrate's referential commitments entail every permitted attribution
proposition.
-/
theorem referentialCommitments_entails_of_permittedAttributionProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, x} L}
    (B : AttributionalBasisFixing C A)
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : PermittedAttributionProposition C S F A B s p) :
    C.entails (ReferentialCommitments C S F s) p := by
  rcases hp with ⟨source, φ, rfl, hfixed⟩
  exact B.entailsAssertsOfFixedBy hfixed

/--
Every permitted attribution proposition is a substrate-layer commitment.

This follows by generalized cut: the substrate entails every member of its
referential commitments, and those referential commitments entail the
permitted attribution proposition.
-/
theorem substrateCommitment_of_permittedAttributionProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, x} L}
    (B : AttributionalBasisFixing C A)
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : PermittedAttributionProposition C S F A B s p) :
    SubstrateCommitment C S s p := by
  apply substrateCommitment_of_entails
  apply C.cut
    (T := S.commitments s)
    (U := ReferentialCommitments C S F s)
  · intro q hq
    exact entails_of_substrateCommitment
      (substrateCommitment_of_mem_referentialCommitments hq)
  · exact
      referentialCommitments_entails_of_permittedAttributionProposition
        B
        hp

end

end SE.NeutralSubstrate.Attribution
