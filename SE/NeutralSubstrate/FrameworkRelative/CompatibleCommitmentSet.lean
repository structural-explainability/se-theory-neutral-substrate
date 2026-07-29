/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Framework.Class
public import SE.Logic.Consistency
public import SE.Logic.Theory.TheoryExtension

/-!
# Framework-Compatible Commitment Sets

This module formalizes:

- `se100.def.FrameworkCompatibleCommitmentSet` —
  Framework-Compatible Commitment Set

A commitment set is framework-compatible when its union with the commitment
theory of every admissible framework remains consistent.

Compatibility is required for the commitment set as a whole, not merely for
each of its members considered separately. Individually compatible
propositions may therefore fail to form a jointly compatible commitment set.

No decidability, finiteness, enumeration, or effective search procedure for
the framework class is assumed.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.FrameworkRelative

open SE.Framework
open SE.Logic
open SE.Logic.Language
open SE.Logic.Theory

universe u v

public section

/--
A commitment set is framework-compatible when combining it with every
admissible framework's commitment theory produces a consistent theory.

This formalizes the paper's condition:

`T ∪ F ⊬ ⊥`

for every admissible framework `F`.
-/
def FrameworkCompatibleCommitmentSet
    {L : PropositionalLanguage.{u}}
    (C : ConsequenceSystem L)
    (M : FrameworkSystem.{u, v} L.carrier)
    (T : CommitmentTheory L.carrier) :
    Prop :=
  ∀ framework,
    framework ∈ FrameworkClass C M →
      Consistent C
        (combine T (M.commitments framework))

/--
A commitment set is framework-compatible exactly when its union with every
admissible framework's commitment theory remains consistent.
-/
@[simp]
theorem frameworkCompatibleCommitmentSet_iff
    {L : PropositionalLanguage.{u}}
    {C : ConsequenceSystem L}
    {M : FrameworkSystem.{u, v} L.carrier}
    {T : CommitmentTheory L.carrier} :
    FrameworkCompatibleCommitmentSet C M T ↔
      ∀ framework,
        framework ∈ FrameworkClass C M →
          Consistent C
            (combine T (M.commitments framework)) :=
  Iff.rfl

/--
A framework-compatible commitment set remains consistent when combined with
the commitments of any selected admissible framework.
-/
theorem consistent_combine_of_frameworkCompatibleCommitmentSet
    {L : PropositionalLanguage.{u}}
    {C : ConsequenceSystem L}
    {M : FrameworkSystem.{u, v} L.carrier}
    {T : CommitmentTheory L.carrier}
    (hT : FrameworkCompatibleCommitmentSet C M T)
    {framework : M.Carrier}
    (hframework : framework ∈ FrameworkClass C M) :
    Consistent C
      (combine T (M.commitments framework)) :=
  hT framework hframework


/-
theorem consistent_combine_of_frameworkCompatibleCommitmentSet
    {L : PropositionalLanguage.{u}}
    {C : ConsequenceSystem L}
    {M : FrameworkSystem.{u, v} L.carrier}
    {T : CommitmentTheory L.carrier}
    {framework : M.Carrier}
    (hcompatible : FrameworkCompatibleCommitmentSet C M T)
    (hframework : framework ∈ FrameworkClass C M) :
    Consistent C
      (combine T (M.commitments framework)) :=
  hcompatible framework hframework
-/


end

end SE.NeutralSubstrate.FrameworkRelative
