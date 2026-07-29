/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Consistency
public import SE.Substrate.Basic

/-!
# Substrate Consistency

This module formalizes:

- `se100.assump.SubstrateConsistency` — Substrate Consistency

Every substrate considered by the theory is internally consistent. Its
commitment theory does not entail contradiction:

`S ⊬ ⊥`.

Substrate consistency concerns the substrate in isolation. It is distinct
from extension stability, which requires consistency after combining the
substrate with every admissible framework.

No decidability or effective consistency-checking procedure is assumed.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.Assumptions

open SE.Logic
open SE.Logic.Language
open SE.Referent
open SE.Substrate

universe u v w

public section

/--
A substrate is internally consistent when its commitment theory does not
entail the object-language contradiction.

This formalizes the paper's condition:

`S ⊬ ⊥`.
-/
def SubstrateConsistency
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (S : SubstrateSystem.{u, v, w} L R)
    (s : S.Carrier) :
    Prop :=
  Consistent C (S.commitments s)

/--
A substrate is consistent exactly when its commitment theory is consistent.
-/
@[simp]
theorem substrateConsistency_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier} :
    SubstrateConsistency C S s ↔
      Consistent C (S.commitments s) :=
  Iff.rfl

/--
Substrate consistency supplies consistency of the substrate's commitment
theory.
-/
theorem consistent_of_substrateConsistency
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    (hconsistency : SubstrateConsistency C S s) :
    Consistent C (S.commitments s) :=
  hconsistency

/--
Consistency of the substrate's commitment theory establishes substrate
consistency.
-/
theorem substrateConsistency_of_consistent
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    (hconsistency : Consistent C (S.commitments s)) :
    SubstrateConsistency C S s :=
  hconsistency

end

end SE.NeutralSubstrate.Assumptions
