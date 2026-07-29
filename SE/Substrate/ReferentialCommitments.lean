/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Substrate.Commitment

/-!
# Referential Commitments

This module formalizes:

- `se100.def.ReferentialCommitments` — Referential Commitments

The referential commitments of a substrate are the substrate-layer
commitments fixed by its referential regime.

These commitments include the propositions needed to express identifiers;
the typing of entities, occurrences, and institutional artifacts; timestamps;
provenance; and referential relations among them.

The paper does not provide a formal decision procedure for determining which
propositions are fixed by a referential regime. This module therefore exposes
that determination as an abstract relation.

No finiteness, enumeration, decidability, or exhaustiveness assumption is
imposed.
-/

set_option autoImplicit false

namespace SE.Substrate

open SE.Logic
open SE.Logic.Language
open SE.Logic.Theory
open SE.Referent

universe u v w

public section

/--
An abstract account of which object-language propositions are fixed by a
referential regime.

Concrete realizations may derive this relation from identifiers, referent
typing, timestamps, provenance, and other referential records.
-/
structure ReferentialFixing
    (L : PropositionalLanguage.{u})
    (R : ReferentCarriers.{v}) where

  /--
  Whether an object-language proposition is fixed by a referential regime.
  -/
  fixedBy :
    ReferentialRegime R →
    L.Proposition →
    Prop

/--
The referential commitments of a substrate.

A proposition belongs to this theory exactly when:

1. the substrate commits to the proposition; and
2. the proposition is fixed by the substrate's referential regime.
-/
def ReferentialCommitments
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (S : SubstrateSystem.{u, v, w} L R)
    (F : ReferentialFixing L R)
    (s : S.Carrier) :
    CommitmentTheory L.carrier :=
  {p |
    SubstrateCommitment C S s p ∧
      F.fixedBy (S.referentialRegime s) p}

/--
A proposition belongs to a substrate's referential commitments exactly when
it is both a substrate-layer commitment and fixed by the substrate's
referential regime.
-/
@[simp]
theorem mem_referentialCommitments_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {s : S.Carrier}
    {p : L.Proposition} :
    p ∈ ReferentialCommitments C S F s ↔
      SubstrateCommitment C S s p ∧
        F.fixedBy (S.referentialRegime s) p :=
  Iff.rfl

/--
Every referential commitment is a substrate-layer commitment.
-/
theorem substrateCommitment_of_mem_referentialCommitments
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : p ∈ ReferentialCommitments C S F s) :
    SubstrateCommitment C S s p :=
  hp.1

/--
Every referential commitment is fixed by the substrate's referential regime.
-/
theorem fixedByReferentialRegime_of_mem_referentialCommitments
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : p ∈ ReferentialCommitments C S F s) :
    F.fixedBy (S.referentialRegime s) p :=
  hp.2

end

end SE.Substrate
