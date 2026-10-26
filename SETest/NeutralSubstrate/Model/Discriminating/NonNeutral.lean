/-
Copyright (c) 2026 Denise M. Case. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SETest.NeutralSubstrate.Model.Discriminating.Neutral

/-!
# Discriminating Model: the Non-Neutral Substrate

The non-neutral substrate commits to the stable referential proposition and
also directly to the contested proposition.

This module proves that:

- the non-neutral substrate commits to the contested proposition;
- it is not extension-stable, because it becomes inconsistent when combined
  with the denying framework;
- the contested proposition is framework-variant, so the non-neutral
  substrate violates interpretive non-commitment;
- the non-neutral substrate is therefore not neutral.

Combined with `Neutral.lean`, the discriminating model contains a neutral
substrate and a non-neutral substrate over the same language, referent
carriers, referential regime, and admissible frameworks.
They differ only in whether the contested proposition is embedded in the
substrate commitment theory.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Model.Discriminating.NonNeutral

open SE.Framework
open SE.Logic
open SE.Logic.Theory
open SE.NeutralSubstrate.FrameworkRelative
open SE.Substrate
open SETest.NeutralSubstrate.Model

@[expose] public section

/--
The non-neutral substrate commits to the contested proposition.
-/
theorem commitsToContested :
    SubstrateCommitment
      consequence substrates nonNeutralSubstrate contestedProposition := by
  apply substrateCommitment_of_entails
  apply consequence.entailsOfMem
  rw [nonNeutralSubstrate_commitments]
  exact Or.inr rfl

/--
The non-neutral substrate is inconsistent when combined with the denying
framework, which is admissible.
-/
theorem not_extensionStability :
    ¬ SE.NeutralSubstrate.Neutrality.ExtensionStability
        consequence substrates nonNeutralSubstrate frameworks := by
  intro hstability
  have hconsistent :=
    SE.NeutralSubstrate.Neutrality.extensionStability_iff.mp
      hstability denyingFramework Neutral.denyingFramework_admissible
  apply not_entailsBottom_of_consistent hconsistent
  rw [substrateFrameworkCommitments_eq]
  apply consequence.contradiction (p := contestedProposition)
  · apply consequence.entailsOfMem
    rw [mem_combine_iff]
    left
    rw [nonNeutralSubstrate_commitments]
    exact Or.inr rfl
  · apply consequence.entailsOfMem
    rw [mem_combine_iff]
    right
    rw [denyingFramework_commitments]
    exact rfl

/--
The contested proposition is framework-variant with respect to the
non-neutral substrate.
-/
theorem contested_frameworkVariant :
    FrameworkVariantProposition
      consequence substrates nonNeutralSubstrate frameworks
      contestedProposition := by
  rw [frameworkVariantProposition_iff]
  refine
    ⟨affirmingFramework, denyingFramework,
      Neutral.affirmingFramework_admissible,
      Neutral.denyingFramework_admissible, ?_, ?_⟩
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
The non-neutral substrate violates interpretive non-commitment: it commits
to a framework-variant proposition.
-/
theorem not_interpretiveNonCommitment :
    ¬ SE.NeutralSubstrate.Neutrality.InterpretiveNonCommitment
        consequence substrates nonNeutralSubstrate frameworks := by
  intro hnonCommitment
  exact
    (SE.NeutralSubstrate.Neutrality.no_commitment_pair_of_interpretiveNonCommitment
        hnonCommitment contested_frameworkVariant).1
      commitsToContested

/--
The non-neutral substrate is not neutral.
-/
theorem not_neutral :
    ¬ SE.NeutralSubstrate.Neutrality.Neutral
        consequence substrates nonNeutralSubstrate frameworks :=
  fun hneutral =>
    not_extensionStability
      (SE.NeutralSubstrate.Neutrality.neutral_iff.mp hneutral).2

/--
The discriminating model separates the two notions: the neutral substrate is
neutral and the non-neutral substrate is not.
-/
theorem neutral_discriminates :
    SE.NeutralSubstrate.Neutrality.Neutral
        consequence substrates neutralSubstrate frameworks ∧
      ¬ SE.NeutralSubstrate.Neutrality.Neutral
        consequence substrates nonNeutralSubstrate frameworks :=
  ⟨Neutral.neutral, not_neutral⟩

end

end SETest.NeutralSubstrate.Model.Discriminating.NonNeutral
