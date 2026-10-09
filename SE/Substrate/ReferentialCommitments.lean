module

public import SE.Substrate.Commitment

/-!
**# Referential Commitments**

This module formalizes:

- `se100.def.ReferentialCommitments` - Referential Commitments

The referential commitments of a substrate are the substrate-layer
commitments whose object-language content is fixed by the substrate's
referential regime.

Referential fixing is represented separately from the individuation,
co-reference, and persistence accounts contained in a referential regime.
It is the semantic bridge identifying which object-language propositions
are fixed by those referential semantics.

The bridge remains abstract here. In particular, this module does not infer
referential fixing merely from the presence of identifiers, typing records,
timestamps, provenance records, or other representational artifacts.
Such material may participate in a concrete account of referential fixing,
but its presence alone does not establish the semantic judgment.

Referential fixing is also not identified with:

- carrier equality;
- singular unity or same-unit identity;
- co-reference;
- persistence;
- provenance;
- denotation; or
- evidentiary support.

No closed-world assumption is imposed. Failure to establish that a
proposition is fixed does not by itself establish its negation,
non-applicability, semantic indeterminacy, or any other substantive status.

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

-- RR.DEFINES: SE.Substrate.ReferentialFixing
/--
An abstract semantic bridge identifying which object-language propositions
are fixed by a referential regime.

`fixedBy regime p` states that the referential semantics supplied by
`regime` are sufficient to fix proposition `p` as referential content.

Concrete realizations may use identifiers, typing information, timestamps,
provenance, or other records when determining this relation, but those
records do not by themselves constitute referential fixing.

This interface does not define the deferred denotation or co-reference
lifting bridges.
-/
structure ReferentialFixing
    (L : PropositionalLanguage.{u})
    (R : ReferentCarriers.{v}) where

  /--
  Whether an object-language proposition is semantically fixed by a
  referential regime.
  -/
  fixedBy :
    ReferentialRegime R →
    L.Proposition →
    Prop

-- RR.DEFINES: SE.Substrate.ReferentialCommitments
-- RR.IMPLEMENTS: se100.def.ReferentialCommitments
/--
The referential commitments of a substrate.

A proposition belongs to this theory exactly when:

1. the substrate commits to the proposition; and
2. the proposition is semantically fixed by the substrate's referential
   regime.

Membership therefore requires both substrate-layer commitment and
referential fixing. Neither condition is inferred from the other.
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

-- RR.DEFINES: SE.Substrate.mem_referentialCommitments_iff
/--
A proposition belongs to a substrate's referential commitments exactly when
it is both a substrate-layer commitment and semantically fixed by the
substrate's referential regime.
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

-- RR.DEFINES: SE.Substrate.substrateCommitment_of_mem_referentialCommitments
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

-- RR.DEFINES: SE.Substrate.fixedByReferentialRegime_of_mem_referentialCommitments
/--
Every referential commitment is semantically fixed by the substrate's
referential regime.
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
