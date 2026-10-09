module

public import SE.NeutralSubstrate.Attribution.Basic
public import SE.Substrate.ReferentialCommitments

/-!
**# Permitted Attribution Propositions**

This module formalizes:

- `se100.def.PermittedAttributionProposition` —
  Permitted Attribution Proposition

An attribution proposition `asserts x φ` is permitted at the foundational
layer when the attributional basis for `x`'s assertion of `φ` is semantically
fixed by the substrate's referential commitments.

An attributional basis may involve the source, assertion occurrence,
provenance, content reference, and other information needed to identify what
was asserted, by whom, and under what record basis. The presence of such
records does not by itself establish that the attributional basis is fixed.
That determination remains an explicit semantic judgment.

A fixed attributional basis must support entailment of the corresponding
attribution proposition. This commits the substrate to the attribution
`asserts x φ`, not to the asserted proposition `φ`.

In particular, attribution does not by itself establish or endorse:

- the truth of `φ`;
- substrate commitment to `φ`;
- framework commitment to `φ`;
- denotation or co-reference of expressions occurring in `φ`; or
- the authority, correctness, or evidentiary adequacy of the source's claim.

The structure of an attributional basis remains abstract.
No finiteness, enumeration, decidability, or computational representation is
assumed.
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

-- RR.DEFINES: SE.NeutralSubstrate.Attribution.AttributionalBasisFixing
/--
An abstract account of when an attributional basis is semantically fixed by
a commitment theory.

`fixedBy T x φ` states that `T` fixes the attributional basis required to
identify `x`'s assertion of `φ`.

Concrete realizations may use source identifiers, assertion records,
provenance, content references, or other records in determining this
judgment. Their presence alone does not establish `fixedBy`.

The second field explicitly requires a fixed attributional basis to support
entailment of the corresponding attribution proposition. It does not entail
or endorse the asserted proposition `φ`.
-/
structure AttributionalBasisFixing
    {L : PropositionalLanguage.{u}}
    (C : ConsequenceSystem L)
    (A : AttributionSystem.{u, x} L) where

  /--
  Whether a commitment theory semantically fixes the attributional basis for
  a source's assertion of a proposition.
  -/
  fixedBy :
    CommitmentTheory L.carrier →
    A.Source →
    L.Proposition →
    Prop

  /--
  A commitment theory that fixes an attributional basis entails the
  corresponding attribution proposition.

  This conclusion concerns `A.asserts source φ`, not `φ`.
  -/
  entailsAssertsOfFixedBy :
    ∀ {T : CommitmentTheory L.carrier}
      {source : A.Source}
      {φ : L.Proposition},
      fixedBy T source φ →
      C.entails T (A.asserts source φ)

-- RR.DEFINES: SE.NeutralSubstrate.Attribution.PermittedAttributionProposition
-- RR.IMPLEMENTS: se100.def.PermittedAttributionProposition
/--
An attribution proposition is permitted at the foundational layer when its
attributional basis is semantically fixed by the substrate's referential
commitments.

Permission applies to the attribution proposition itself and introduces no
commitment to the asserted proposition.
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

-- RR.DEFINES: SE.NeutralSubstrate.Attribution.permittedAttributionProposition_iff
/--
A proposition is permitted exactly when it is an attribution proposition
whose attributional basis is semantically fixed by the substrate's
referential commitments.
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

-- RR.DEFINES: SE.NeutralSubstrate.Attribution.attributionProposition_of_permittedAttributionProposition
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

-- RR.DEFINES: SE.NeutralSubstrate.Attribution.referentialCommitments_entails_of_permittedAttributionProposition
/--
The substrate's referential commitments entail every permitted attribution
proposition.

The entailed proposition is the attribution itself, not its asserted
content.
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

-- RR.DEFINES: SE.NeutralSubstrate.Attribution.substrateCommitment_of_permittedAttributionProposition
/--
Every permitted attribution proposition is a substrate-layer commitment.

This follows by generalized cut: the substrate entails every member of its
referential commitments, and those referential commitments entail the
permitted attribution proposition.

The resulting substrate commitment remains a commitment to the attribution,
not to the proposition attributed to the source.
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
