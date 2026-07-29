/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.Substrate.Basic

/-!
# Substrate System Tests

Compile-time API and theorem-application tests for
`SE.Substrate.Basic`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Substrate.Basic

open SE.Logic.Language
open SE.Logic.Theory
open SE.Referent
open SE.Substrate

universe u v w

#check SubstrateSystem

example {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (S : SubstrateSystem.{u, v, w} L R)
    (s : S.Carrier) :
    CommitmentTheory L.carrier :=
  S.commitments s

end SETest.NeutralSubstrate.Substrate.Basic
