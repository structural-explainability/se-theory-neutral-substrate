/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.Substrate.Commitment

/-!
# Substrate Commitment Tests

Compile-time API and theorem-application tests for
`SE.Substrate.Commitment`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Substrate.Commitment

open SE.Logic
open SE.Logic.Language
open SE.Referent
open SE.Substrate

universe u v w

#check SubstrateCommitment
#check entails_of_substrateCommitment
#check substrateCommitment_of_entails

example {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : SubstrateCommitment C S s p) :
    C.entails (S.commitments s) p :=
  entails_of_substrateCommitment hp

example {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {p : L.Proposition}
    (hp : C.entails (S.commitments s) p) :
    SubstrateCommitment C S s p :=
  substrateCommitment_of_entails hp

end SETest.NeutralSubstrate.Substrate.Commitment
