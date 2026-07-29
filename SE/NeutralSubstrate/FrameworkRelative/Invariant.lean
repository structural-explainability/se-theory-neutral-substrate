/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Consistency
public import SE.Logic.Theory.TheoryExtension
public import SE.NeutralSubstrate.FrameworkRelative.Variant

/-!
# Framework-Invariant Propositions

This module formalizes:

- `se100.def.FrameworkInvariant` — Framework-Invariant Proposition

A proposition is framework-invariant with respect to a substrate and the
framework class when it can be adjoined to the substrate together with every
admissible framework without producing contradiction.

The canonical formal condition is consistency after adjoining the
proposition:

`S ∪ F ∪ {p} ⊬ ⊥`

for every admissible framework `F`.

The paper informally describes this as saying that no admissible framework
refutes `p` on the shared base. This module does not identify that gloss with
non-entailment of `¬p`, because the abstract consequence system does not
assume a negation-introduction principle.

No decidability, finiteness, enumeration, or effective search procedure for
the framework class is assumed.
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
A proposition is framework-invariant with respect to a substrate and
framework class when adjoining it to every admissible substrate-framework
commitment theory remains consistent.
-/
def FrameworkInvariantProposition
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (S : SubstrateSystem.{u, v, w} L R)
    (s : S.Carrier)
    (M : FrameworkSystem.{u, x} L.carrier)
    (p : L.Proposition) :
    Prop :=
  ∀ framework,
    framework ∈ FrameworkClass C M →
      Consistent C
        (adjoin
          (SubstrateFrameworkCommitments S s M framework)
          p)

/--
A proposition is framework-invariant exactly when adjoining it to every
admissible substrate-framework commitment theory remains consistent.
-/
@[simp]
theorem frameworkInvariantProposition_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    {p : L.Proposition} :
    FrameworkInvariantProposition C S s M p ↔
      ∀ framework,
        framework ∈ FrameworkClass C M →
          Consistent C
            (adjoin
              (SubstrateFrameworkCommitments S s M framework)
              p) :=
  Iff.rfl

/--
Adjoining a framework-invariant proposition to the substrate together with
any admissible framework produces a consistent commitment theory.
-/
theorem consistent_adjoin_of_frameworkInvariantProposition
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
    Consistent C
      (adjoin
        (SubstrateFrameworkCommitments S s M framework)
        p) :=
  hp framework hframework

end

end SE.NeutralSubstrate.FrameworkRelative
