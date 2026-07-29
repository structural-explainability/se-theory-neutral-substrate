/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Consequence
public import SE.Substrate.Basic

/-!
# Substrate-Layer Commitment

This module formalizes:

- `se100.def.SubstrateCommitment` — Substrate-Layer Commitment

A substrate commits to an object-language proposition when that proposition
is entailed by the substrate's commitment theory independently of any
interpretive framework.

This definition does not classify the proposition as referential,
attributional, interpretive, causal, or normative. Those classifications are
defined separately.
-/

set_option autoImplicit false

namespace SE.Substrate

open SE.Logic
open SE.Logic.Language
open SE.Referent

universe u v w

public section

/--
A substrate-layer commitment to `p` holds exactly when the substrate's
commitment theory entails `p`.
-/
def SubstrateCommitment
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (S : SubstrateSystem.{u, v, w} L R)
    (s : S.Carrier)
    (p : L.Proposition) :
    Prop :=
  C.entails (S.commitments s) p

/--
A substrate-layer commitment entails the committed proposition from the
substrate's commitment theory.
-/
theorem entails_of_substrateCommitment
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : SubstrateCommitment C S s p) :
    C.entails (S.commitments s) p :=
  hp

/--
Entailment from a substrate's commitment theory establishes a substrate-layer
commitment.
-/
theorem substrateCommitment_of_entails
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : C.entails (S.commitments s) p) :
    SubstrateCommitment C S s p :=
  hp

end

end SE.Substrate
