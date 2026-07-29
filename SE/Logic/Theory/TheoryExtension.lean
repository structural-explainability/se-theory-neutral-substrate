/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Theory.CommitmentTheory
public import SE.Logic.Language.PropositionCarrier

/-!
# AUX-007. Theory Extension

This module defines the ordinary operations used to combine commitment
theories and to adjoin one object-language proposition.

Theory extension introduces no additional logical semantics. It is ordinary
set union and singleton insertion.
-/

set_option autoImplicit false

namespace SE.Logic.Theory

open SE.Logic.Language

universe u

public section

variable {P : SE.Logic.Language.PropositionCarrier.{u}}

/--
Combines two commitment theories by set union.
-/
def combine
    (T U : CommitmentTheory P) :
    CommitmentTheory P :=
  T ∪ U

/--
Adjoins one object-language proposition to a commitment theory.
-/
def adjoin
    (T : CommitmentTheory P)
    (p : P.Proposition) :
    CommitmentTheory P :=
  T ∪ {p}


/--
Membership in a combined commitment theory is membership in either component.
-/
@[simp]
theorem mem_combine_iff
    {P : PropositionCarrier.{u}}
    {T U : CommitmentTheory P}
    {p : P.Proposition} :
    p ∈ combine T U ↔
      p ∈ T ∨ p ∈ U :=
  Iff.rfl

/--
Membership after adjoining a proposition is membership in the original
theory or equality with the adjoined proposition.
-/
@[simp]
theorem mem_adjoin_iff
    {P : PropositionCarrier.{u}}
    {T : CommitmentTheory P}
    {p q : P.Proposition} :
    p ∈ adjoin T q ↔
      p ∈ T ∨ p = q :=
  Iff.rfl

/--
The left component is contained in the combined commitment theory.
-/
theorem subset_combine_left
    {P : PropositionCarrier.{u}}
    (T U : CommitmentTheory P) :
    T ⊆ combine T U := by
  intro p hp
  exact mem_combine_iff.mpr (Or.inl hp)

/--
The right component is contained in the combined commitment theory.
-/
theorem subset_combine_right
    {P : PropositionCarrier.{u}}
    (T U : CommitmentTheory P) :
    U ⊆ combine T U := by
  intro p hp
  exact mem_combine_iff.mpr (Or.inr hp)

/--
A commitment theory is contained in the theory obtained by adjoining a
proposition.
-/
theorem subset_adjoin
    {P : PropositionCarrier.{u}}
    (T : CommitmentTheory P)
    (p : P.Proposition) :
    T ⊆ adjoin T p := by
  intro q hq
  exact mem_adjoin_iff.mpr (Or.inl hq)

end

end SE.Logic.Theory
