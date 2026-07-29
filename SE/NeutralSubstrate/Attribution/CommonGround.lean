/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.NeutralSubstrate.Assumptions.ReferentialCommonGround

/-!
# Attribution and Common Ground

This module formalizes:

- `se100.remark.AttributionCommonGround` —
  Attribution and Common Ground

A permitted attribution proposition `asserts x φ` commits the substrate to
the attribution by `x`, not to the asserted proposition `φ`.

Because a permitted attribution proposition is already entailed by the
substrate's referential commitments, adjoining it adds no independent
commitment. For every framework, the extended theory entails contradiction
exactly when the unextended theory entails contradiction.

Referential Common Ground therefore ensures that the referential commitments,
a permitted attribution proposition, and every admissible framework remain
jointly consistent.

An admissible framework may reject `φ` without rejecting that `x` asserted
`φ`. This module does not infer `φ` from `asserts x φ`.

No decidability, finiteness, enumeration, or effective search procedure is
assumed.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.Attribution

open SE.Framework
open SE.Logic
open SE.Logic.Language
open SE.Logic.Theory
open SE.NeutralSubstrate.Assumptions
open SE.Referent
open SE.Substrate

universe u v w x y

public section

/--
Adjoining a proposition already entailed by a commitment theory does not
change whether its combination with another theory entails contradiction.

The forward direction uses generalized cut. The reverse direction follows
from monotonicity.
-/
theorem entailsBottom_combine_adjoin_iff_of_entails
    {L : PropositionalLanguage.{u}}
    (C : ConsequenceSystem L)
    {T U : CommitmentTheory L.carrier}
    {p : L.Proposition}
    (hp : C.entails T p) :
    C.entails
        (combine (adjoin T p) U)
        L.bottom ↔
      C.entails
        (combine T U)
        L.bottom := by
  constructor
  · intro hcontradiction
    apply C.cut
      (T := combine T U)
      (U := combine (adjoin T p) U)
    · intro q hq
      rcases mem_combine_iff.mp hq with hq | hq
      · rcases mem_adjoin_iff.mp hq with hq | hq
        · exact
            C.entailsOfMem
              (mem_combine_iff.mpr (Or.inl hq))
        · subst q
          exact
            C.entailsMono
              (subset_combine_left T U)
              hp
      · exact
          C.entailsOfMem
            (mem_combine_iff.mpr (Or.inr hq))
    · exact hcontradiction
  · intro hcontradiction
    apply C.entailsMono
      (T := combine T U)
      (U := combine (adjoin T p) U)
    · intro q hq
      rcases mem_combine_iff.mp hq with hq | hq
      · exact
          mem_combine_iff.mpr
            (Or.inl
              (mem_adjoin_iff.mpr
                (Or.inl hq)))
      · exact
          mem_combine_iff.mpr
            (Or.inr hq)
    · exact hcontradiction

/--
Adjoining a permitted attribution proposition to the referential commitments
does not change whether the resulting theory combined with a framework
entails contradiction.

This theorem does not require the selected framework to be admissible; the
consequence equivalence follows solely from the permitted attribution
proposition already being entailed by the referential commitments.
-/
theorem entailsBottom_permittedAttribution_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, x} L}
    (B : AttributionalBasisFixing C A)
    {s : S.Carrier}
    {M : FrameworkSystem.{u, y} L.carrier}
    {p : L.Proposition}
    (hp : PermittedAttributionProposition C S F A B s p)
    (framework : M.Carrier) :
    C.entails
        (combine
          (adjoin
            (ReferentialCommitments C S F s)
            p)
          (M.commitments framework))
        L.bottom ↔
      C.entails
        (combine
          (ReferentialCommitments C S F s)
          (M.commitments framework))
        L.bottom := by
  apply entailsBottom_combine_adjoin_iff_of_entails
  exact
    referentialCommitments_entails_of_permittedAttributionProposition
      B
      hp

/--
Under Referential Common Ground, adjoining a permitted attribution
proposition to the referential commitments remains consistent with every
admissible framework.
-/
theorem consistent_permittedAttribution_of_commonGround
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {F : ReferentialFixing L R}
    {A : AttributionSystem.{u, x} L}
    {B : AttributionalBasisFixing C A}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, y} L.carrier}
    (hcommonGround : ReferentialCommonGround C S F A B s M)
    {p : L.Proposition}
    (hp : PermittedAttributionProposition C S F A B s p)
    {framework : M.Carrier}
    (hframework : framework ∈ FrameworkClass C M) :
    Consistent C
      (combine
        (adjoin
          (ReferentialCommitments C S F s)
          p)
        (M.commitments framework)) :=
  consistent_permittedAttribution_of_referentialCommonGround
    hcommonGround
    hp
    hframework

end

end SE.NeutralSubstrate.Attribution
