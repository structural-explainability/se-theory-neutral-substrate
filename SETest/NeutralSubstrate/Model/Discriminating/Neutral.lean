/-
Copyright (c) 2026 Denise M. Case. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SETest.NeutralSubstrate.Model.Discriminating.Substrates
public import SE.NeutralSubstrate.FrameworkRelative.Variant
public import SE.NeutralSubstrate.Neutrality.ByDesign
public import SE.NeutralSubstrate.Neutrality.ExtensionStability
public import SE.NeutralSubstrate.Neutrality.PropertyRelation

/-!
# Discriminating Model: the Neutral Substrate

The neutral substrate commits only to the stable referential proposition.
Two admissible frameworks disagree about the contested proposition:
the affirming framework commits to it and the denying framework commits to
its object-language negation.

This module proves that:

- both frameworks are admissible;
- the contested proposition is framework-variant with respect to the
  neutral substrate;
- the neutral substrate is extension-stable, satisfies interpretive
  non-commitment, and is therefore neutral.

Together with `NonNeutral.lean`, this shows that the framework-variance
condition is not vacuous: there are admissible frameworks that disagree, a
substrate that abstains from the disputed proposition, and a substrate that
does not.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Model.Discriminating.Neutral

open SE.Framework
open SE.Logic
open SE.Logic.Theory
open SE.NeutralSubstrate.FrameworkRelative
open SE.NeutralSubstrate.Neutrality
open SETest.NeutralSubstrate.Model

@[expose] public section

/--
The valuation that makes every atom true.
-/
def allTrue : Atom → Prop :=
  fun _ => True

/--
The valuation that makes only the reference atom true.
-/
def referenceOnly : Atom → Prop :=
  fun a => a = Atom.reference

/--
A valuation satisfying two theories satisfies their combination.
-/
theorem satisfies_combine
    {v : Atom → Prop}
    {A B : CommitmentTheory language.carrier}
    (hA : Satisfies v A)
    (hB : Satisfies v B) :
    Satisfies v (combine A B) := by
  intro q hq
  rcases mem_combine_iff.mp hq with hqA | hqB
  · exact hA q hqA
  · exact hB q hqB

/--
A commitment theory with a model is consistent in the model-theoretic
consequence system.
-/
theorem consistent_of_satisfies
    {T : CommitmentTheory language.carrier}
    {v : Atom → Prop}
    (hv : Satisfies v T) :
    Consistent consequence T := by
  apply consistent_of_not_entailsBottom
  intro hbottom
  have hfalse := hbottom v hv
  simp at hfalse

/--
The affirming framework's commitments are satisfied by the valuation that
makes every atom true.
-/
theorem allTrue_satisfies_affirming :
    Satisfies allTrue (frameworks.commitments affirmingFramework) := by
  intro q hq
  rw [affirmingFramework_commitments] at hq
  have hq' : q = contestedProposition := hq
  subst hq'
  simp [allTrue, contestedProposition]

/--
The denying framework's commitments are satisfied by the valuation that
makes only the reference atom true.
-/
theorem referenceOnly_satisfies_denying :
    Satisfies referenceOnly (frameworks.commitments denyingFramework) := by
  intro q hq
  rw [denyingFramework_commitments] at hq
  have hq' : q = negatedContestedProposition := hq
  subst hq'
  simp [referenceOnly, negatedContestedProposition, contestedProposition]

/--
The neutral substrate's commitments are satisfied by the valuation that
makes every atom true.
-/
theorem allTrue_satisfies_neutralSubstrate :
    Satisfies allTrue (substrates.commitments neutralSubstrate) := by
  intro q hq
  rw [neutralSubstrate_commitments] at hq
  have hq' : q = referenceProposition := hq
  subst hq'
  simp [allTrue, referenceProposition]

/--
The neutral substrate's commitments are satisfied by the valuation that
makes only the reference atom true.
-/
theorem referenceOnly_satisfies_neutralSubstrate :
    Satisfies referenceOnly (substrates.commitments neutralSubstrate) := by
  intro q hq
  rw [neutralSubstrate_commitments] at hq
  have hq' : q = referenceProposition := hq
  subst hq'
  simp [referenceOnly, referenceProposition]

/--
The affirming framework is admissible.
-/
theorem affirmingFramework_admissible :
    affirmingFramework ∈ FrameworkClass consequence frameworks := by
  rw [mem_frameworkClass_iff, admissibleFramework_iff,
    documentedInterpretiveFunction_iff]
  exact
    ⟨consistent_of_satisfies allTrue_satisfies_affirming,
      trivial, trivial, trivial, trivial, trivial⟩

/--
The denying framework is admissible.
-/
theorem denyingFramework_admissible :
    denyingFramework ∈ FrameworkClass consequence frameworks := by
  rw [mem_frameworkClass_iff, admissibleFramework_iff,
    documentedInterpretiveFunction_iff]
  exact
    ⟨consistent_of_satisfies referenceOnly_satisfies_denying,
      trivial, trivial, trivial, trivial, trivial⟩

/--
The neutral substrate remains consistent when combined with any admissible
framework of the discriminating model.
-/
theorem extensionStability :
    ExtensionStability consequence substrates neutralSubstrate frameworks := by
  rw [extensionStability_iff]
  intro framework _
  rw [substrateFrameworkCommitments_eq]
  cases framework with
  | affirming =>
      exact
        consistent_of_satisfies
          (satisfies_combine
            allTrue_satisfies_neutralSubstrate
            allTrue_satisfies_affirming)
  | denying =>
      exact
        consistent_of_satisfies
          (satisfies_combine
            referenceOnly_satisfies_neutralSubstrate
            referenceOnly_satisfies_denying)

/--
The neutral substrate makes no commitment to either side of a
framework-variant proposition.
-/
theorem interpretiveNonCommitment :
    InterpretiveNonCommitment
      consequence substrates neutralSubstrate frameworks :=
  interpretiveNonCommitment_of_extensionStability extensionStability

/--
The neutral substrate of the discriminating model is neutral.
-/
theorem neutral :
    Neutral consequence substrates neutralSubstrate frameworks :=
  neutral_iff.mpr
    ⟨interpretiveNonCommitment, extensionStability⟩

/--
The contested proposition is framework-variant with respect to the neutral
substrate: the affirming framework yields it and the denying framework
yields its object-language negation.
-/
theorem contested_frameworkVariant :
    FrameworkVariantProposition
      consequence substrates neutralSubstrate frameworks
      contestedProposition := by
  rw [frameworkVariantProposition_iff]
  refine
    ⟨affirmingFramework, denyingFramework,
      affirmingFramework_admissible, denyingFramework_admissible, ?_, ?_⟩
  · rw [substrateFrameworkCommitments_eq]
    apply consequence.entailsOfMem
    rw [mem_combine_iff]
    right
    rw [affirmingFramework_commitments]
    exact rfl
  · rw [substrateFrameworkCommitments_eq]
    apply consequence.entailsOfMem
    rw [mem_combine_iff]
    right
    rw [denyingFramework_commitments]
    exact rfl

/--
The neutral substrate commits neither to the contested proposition nor to
its negation.
-/
theorem neutral_abstains_on_contested :
    ¬ SE.Substrate.SubstrateCommitment
        consequence substrates neutralSubstrate contestedProposition ∧
      ¬ SE.Substrate.SubstrateCommitment
        consequence substrates neutralSubstrate negatedContestedProposition :=
  no_commitment_pair_of_interpretiveNonCommitment
    interpretiveNonCommitment contested_frameworkVariant

end

end SETest.NeutralSubstrate.Model.Discriminating.Neutral
