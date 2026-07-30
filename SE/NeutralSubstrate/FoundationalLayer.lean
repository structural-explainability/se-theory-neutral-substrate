/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.NeutralSubstrate.Attribution.Permitted

/-!
# Foundational-Layer Restriction

The structural predicate shared by the neutrality constraint and the
sufficiency direction: the foundational layer is restricted to the permitted
classes when every substrate-layer commitment is either a referential
commitment or a permitted attribution proposition.

It depends only on referential commitments and permitted attribution
propositions, so stated below the constraint and the sufficiency
argument that use it.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate

open SE.Logic
open SE.Logic.Language
open SE.NeutralSubstrate.Attribution
open SE.Referent
open SE.Substrate

universe u v w x

public section

/--
The foundational layer is restricted to the permitted classes when every
substrate-layer commitment is either a referential commitment or a permitted
attribution proposition.
The restriction applies to semantic substrate-layer commitments.
This is a theory concept, so we expose the associated _iff theorem rather
than use `@expose`.
-/
def FoundationalLayerRestrictedToPermittedClasses
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (S : SubstrateSystem.{u, v, w} L R)
    (F : ReferentialFixing L R)
    (A : AttributionSystem.{u, x} L)
    (B : AttributionalBasisFixing C A)
    (s : S.Carrier) :
    Prop :=
  ∀ p,
    SubstrateCommitment C S s p →
      p ∈ ReferentialCommitments C S F s ∨
        PermittedAttributionProposition C S F A B s p

@[simp]
theorem foundationalLayerRestrictedToPermittedClasses_iff
    {L : PropositionalLanguage.{u}} {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L} {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R} {A : AttributionSystem.{u, x} L}
    {B : AttributionalBasisFixing C A} {s : S.Carrier} :
    FoundationalLayerRestrictedToPermittedClasses C S F A B s ↔
      ∀ p, SubstrateCommitment C S s p →
        p ∈ ReferentialCommitments C S F s ∨
          PermittedAttributionProposition C S F A B s p :=
  Iff.rfl

end

end SE.NeutralSubstrate
