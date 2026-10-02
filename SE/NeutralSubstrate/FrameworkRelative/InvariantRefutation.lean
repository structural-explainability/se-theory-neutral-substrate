/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.NeutralSubstrate.FrameworkRelative.Invariant

/-!
# Framework Invariance and Refutation

This module formalizes:

- `se100.def.FrameworkInvariant` - Framework-Invariant Proposition
- `se100.remark.FrameworkInvariantRefutation` - Framework Invariance and Refutation

The remark relates framework invariance to the refutation gloss
"no admissible framework refutes `p` on the shared base".

Refutation is read as entailment of the object-language negation `neg p`.

- Framework invariance implies non-refutation using the existing consequence
  interface: `entailsOfMem`, monotonicity, and contradiction formation.
- Non-refutation implies invariance only under negation introduction:
  if `adjoin T q` entails `bottom`, then `T` entails `neg q`.
- `ConsequenceSystem` does not assume this principle, so it is supplied as a
  hypothesis rather than added as a structure field.
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

-- RR.DEFINES: SE.NeutralSubstrate.FrameworkRelative.not_entails_neg_of_frameworkInvariantProposition
/--
A framework-invariant proposition is not refuted on any admissible
substrate-framework base: no such base entails `neg p`.

Proof idea: if the base entailed `neg p`, adjoining `p` would produce a theory
entailing both `p` and `neg p`, hence `bottom`, contradicting framework
invariance.
-/
theorem not_entails_neg_of_frameworkInvariantProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    {p : L.Proposition}
    (hp : FrameworkInvariantProposition C S s M p)
    {framework : M.Carrier}
    (hframework : framework ∈ FrameworkClass C M) :
    ¬ C.entails
        (SubstrateFrameworkCommitments S s M framework)
        (L.neg p) := by
  intro hneg
  have hpMem :
      C.entails
        (adjoin (SubstrateFrameworkCommitments S s M framework) p)
        p :=
    C.entailsOfMem (mem_adjoin_iff.mpr (Or.inr rfl))
  have hnegMono :
      C.entails
        (adjoin (SubstrateFrameworkCommitments S s M framework) p)
        (L.neg p) :=
    C.entailsMono (subset_adjoin _ p) hneg
  exact
    not_entailsBottom_of_consistent
      (consistent_adjoin_of_frameworkInvariantProposition hp hframework)
      (C.contradiction hpMem hnegMono)

-- RR.DEFINES: SE.NeutralSubstrate.FrameworkRelative.frameworkInvariantProposition_iff_not_entails_neg
/--
Under the stated negation-introduction principle, framework invariance is
equivalent to non-refutation: no admissible substrate-framework base entails
`neg p`.

Negation introduction is a hypothesis of this theorem, not part of
`ConsequenceSystem`.
-/
theorem frameworkInvariantProposition_iff_not_entails_neg
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    {p : L.Proposition}
    (hni :
      ∀ {T : CommitmentTheory L.carrier} {q : L.Proposition},
        C.entails (adjoin T q) L.bottom →
        C.entails T (L.neg q)) :
    FrameworkInvariantProposition C S s M p ↔
      ∀ framework,
        framework ∈ FrameworkClass C M →
          ¬ C.entails
              (SubstrateFrameworkCommitments S s M framework)
              (L.neg p) := by
  rw [frameworkInvariantProposition_iff]
  constructor
  · intro hp framework hframework
    exact
      not_entails_neg_of_frameworkInvariantProposition
        (frameworkInvariantProposition_iff.mpr hp) hframework
  · intro h framework hframework
    exact
      consistent_of_not_entailsBottom
        (fun hbot => h framework hframework (hni hbot))

end

end SE.NeutralSubstrate.FrameworkRelative
