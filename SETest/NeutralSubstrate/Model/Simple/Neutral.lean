/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SETest.NeutralSubstrate.Model.Simple.Model
public import SE.NeutralSubstrate.Neutrality.ByDesign
public import SE.NeutralSubstrate.Neutrality.ExtensionStability
public import SE.NeutralSubstrate.Neutrality.PropertyRelation

/-!
# Neutrality of the Simple Model

The simple substrate and framework have empty commitment theories.

The empty theory is semantically consistent because no valuation satisfies
the distinguished contradiction proposition.
The substrate therefore remains consistent when combined with its sole admissible framework.

Extension stability yields interpretive non-commitment, and the two properties
together establish neutrality.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Model.Simple

open SE.Logic
open SE.Logic.Theory
open SE.NeutralSubstrate.FrameworkRelative
open SE.NeutralSubstrate.Neutrality
open SETest.NeutralSubstrate.Model

public section

/--
The empty commitment theory is consistent in the concrete model-theoretic
consequence system.
-/
theorem emptyTheory_consistent :
    Consistent consequence
      (∅ : CommitmentTheory language.carrier) := by
  apply consistent_of_not_entailsBottom
  intro hbottom
  have hempty :
      Satisfies
        (fun _ : Atom => False)
        (∅ : CommitmentTheory language.carrier) := by
    intro q hq
    simp at hq
  have hfalse :=
    hbottom (fun _ : Atom => False) hempty
  simp at hfalse

/--
Helper theorem: Combining two empty commitment theories yields the empty commitment theory.
-/
theorem combine_empty_empty :
    combine
        (∅ : CommitmentTheory language.carrier)
        (∅ : CommitmentTheory language.carrier) =
      ∅ := by
  ext p
  rw [mem_combine_iff]
  simp

/--
The simple substrate remains consistent under its sole admissible framework.
-/
theorem extensionStability :
    ExtensionStability consequence substrates substrate frameworks := by
  rw [extensionStability_iff]
  intro currentFramework _
  change
    Consistent consequence
      (combine
        (∅ : CommitmentTheory language.carrier)
        (∅ : CommitmentTheory language.carrier))
  rw [combine_empty_empty]
  exact emptyTheory_consistent

/--
The simple substrate makes no commitment to either side of a
framework-variant proposition.
-/
theorem interpretiveNonCommitment :
    InterpretiveNonCommitment
      consequence substrates substrate frameworks :=
  interpretiveNonCommitment_of_extensionStability extensionStability

/--
The simple substrate is neutral.
-/
theorem neutral :
    Neutral consequence substrates substrate frameworks :=
  neutral_iff.mpr
    ⟨interpretiveNonCommitment, extensionStability⟩

/--
A concrete witness that the `Neutral` predicate is inhabited.
-/
theorem exists_neutral_substrate :
    ∃ s : substrates.Carrier,
      Neutral consequence substrates s frameworks :=
  ⟨substrate, neutral⟩

end

end SETest.NeutralSubstrate.Model.Simple
