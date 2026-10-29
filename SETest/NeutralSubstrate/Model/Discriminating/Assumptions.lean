/-
Copyright (c) 2026 Denise M. Case. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SETest.NeutralSubstrate.Model.Discriminating.NonNeutral
public import SE.NeutralSubstrate.Assumptions.Contestability
public import SE.NeutralSubstrate.Assumptions.ReferentialCommonGround
public import SE.NeutralSubstrate.Constraint
public import SE.NeutralSubstrate.Neutrality.Sufficiency

/-!
# Discriminating Model: Joint Satisfiability of the Assumptions

This module witnesses that `Contestability`, `ReferentialCommonGround`, and
`CharacterizationHypothesis` hold together in one concrete realization built
on the discriminating model, so the theorems that take all three as
hypotheses are not vacuous.

The realization adds, to the language, frameworks, substrates, and consequence
system of the discriminating model:

- a referential fixing closed under consequence of the reference proposition;
- an attribution system with no sources;
- a classification in which only the contested proposition is normative;
- an interpretive-status fixing by entailment of the proposition or its
  negation;
- an object-level interpretation under which every proposition concerns the
  referents; and
- a design-time guarantee system whose permitted bases are the substrates with
  a restricted foundational layer, and whose establishment relation is the
  sufficiency theorem `neutral_of_restricted_of_commonGround`.

Limits of this witness:

- The attribution layer is exercised vacuously, because there are no sources.
- The framework carrier has two members, so quantification over the
  framework class is discharged by case analysis. This bounds the
  realization. It does not address an open framework class.
- Every restricted substrate in the model is neutral, so the model does not
  separate neutrality from possession of a permitted basis.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Model.Discriminating.Assumptions

open SE.Framework
open SE.Logic
open SE.Logic.Theory
open SE.NeutralSubstrate
open SE.NeutralSubstrate.Assumptions
open SE.NeutralSubstrate.Attribution
open SE.NeutralSubstrate.Classification
open SE.NeutralSubstrate.FrameworkRelative
open SE.NeutralSubstrate.Interpretation
open SE.NeutralSubstrate.Neutrality
open SE.Referent
open SE.Substrate
open SETest.NeutralSubstrate.Model

@[expose] public section

/--
A referential fixing closed under consequence of the reference proposition.

A proposition is fixed when the reference proposition entails it.
-/
def closureFixing : ReferentialFixing language referents where
  fixedBy := fun _ p => consequence.entails {referenceProposition} p

/--
An attribution system with no sources.
-/
def attribution : AttributionSystem language where
  Source := Empty
  asserts := fun source _ => nomatch source

/--
The attributional basis fixing for the empty attribution system.
-/
def attributionBasis : AttributionalBasisFixing consequence attribution where
  fixedBy := fun _ _ _ => False
  entailsAssertsOfFixedBy := fun h => nomatch h

/--
A classification in which only the contested proposition is normative.
-/
def classification : CausalNormativeClassification language where
  Context := Unit
  causal := fun _ _ => False
  normative := fun _ p => p = contestedProposition

/--
The accountability context of the classification.
-/
def context : classification.Context :=
  ()

/--
The interpretive status of a proposition is fixed by a theory that entails the
proposition or its negation.
-/
def statusFixing : InterpretiveStatusFixing language classification.Context where
  fixedBy := fun _ T p =>
    consequence.entails T p ∨ consequence.entails T (language.neg p)

/--
Every proposition concerns the referents.
-/
def interpretation : ObjectLevelInterpretation language referents where
  aboutReferents := fun _ _ => True

/-! ## Valuations -/

theorem allTrue_satisfies_reference :
    Satisfies Neutral.allTrue
      ({referenceProposition} : CommitmentTheory language.carrier) := by
  intro q hq
  have hq' : q = referenceProposition := hq
  subst hq'
  simp [Neutral.allTrue, referenceProposition]

theorem referenceOnly_satisfies_reference :
    Satisfies Neutral.referenceOnly
      ({referenceProposition} : CommitmentTheory language.carrier) := by
  intro q hq
  have hq' : q = referenceProposition := hq
  subst hq'
  simp [Neutral.referenceOnly, referenceProposition]

/--
A valuation satisfying the reference proposition satisfies the referential
commitments of every substrate in the model.
-/
theorem satisfies_referentialCommitments
    {s : substrates.Carrier}
    {v : Atom → Prop}
    (hv : Satisfies v
      ({referenceProposition} : CommitmentTheory language.carrier)) :
    Satisfies v (ReferentialCommitments consequence substrates closureFixing s) := by
  intro q hq
  exact (mem_referentialCommitments_iff.mp hq).2 v hv

/-! ## Referential Common Ground -/

/--
Referential common ground holds in the realization for every substrate of the
model.

The framework class has two members, so the quantification over admissible
frameworks is discharged by case analysis.
-/
theorem referentialCommonGround (s : substrates.Carrier) :
    ReferentialCommonGround
      consequence substrates closureFixing attribution attributionBasis
      s frameworks := by
  rw [referentialCommonGround_iff, frameworkCompatibleCommitmentSet_iff]
  refine ⟨?_, ?_⟩
  · intro framework _
    cases framework with
    | affirming =>
        exact
          Neutral.consistent_of_satisfies
            (Neutral.satisfies_combine
              (satisfies_referentialCommitments allTrue_satisfies_reference)
              Neutral.allTrue_satisfies_affirming)
    | denying =>
        exact
          Neutral.consistent_of_satisfies
            (Neutral.satisfies_combine
              (satisfies_referentialCommitments referenceOnly_satisfies_reference)
              Neutral.referenceOnly_satisfies_denying)
  · intro p hp
    rw [permittedAttributionProposition_iff] at hp
    rcases hp with ⟨source, _⟩
    exact nomatch source

/-! ## Foundational-layer restriction -/

/--
The neutral substrate's foundational layer is restricted to the permitted
classes.
-/
theorem restricted_neutral :
    FoundationalLayerRestrictedToPermittedClasses
      consequence substrates closureFixing attribution attributionBasis
      neutralSubstrate := by
  rw [foundationalLayerRestrictedToPermittedClasses_iff]
  intro p hp
  left
  exact mem_referentialCommitments_iff.mpr
    ⟨hp, entails_of_substrateCommitment hp⟩

/--
Why the realization uses `closureFixing` rather than the model's
`referentialFixing`.

Substrate commitments are closed under consequence, but `referentialFixing`
fixes only the reference proposition itself. The double negation of the
reference proposition is then a substrate commitment of the neutral substrate
that is neither fixed nor a permitted attribution, so the foundational layer
is not restricted.
-/
theorem not_restricted_neutral_of_literalFixing :
    ¬ FoundationalLayerRestrictedToPermittedClasses
        consequence substrates referentialFixing attribution attributionBasis
        neutralSubstrate := by
  intro hrestricted
  rw [foundationalLayerRestrictedToPermittedClasses_iff] at hrestricted
  have hcommit :
      SubstrateCommitment consequence substrates neutralSubstrate
        (language.neg (language.neg referenceProposition)) := by
    apply substrateCommitment_of_entails
    intro v hv
    have href : Sat v referenceProposition := hv referenceProposition rfl
    simp [referenceProposition] at href ⊢
    exact href
  rcases hrestricted _ hcommit with hmem | hpermitted
  · have hfixed := (mem_referentialCommitments_iff.mp hmem).2
    have heq :
        language.neg (language.neg referenceProposition) =
          referenceProposition := hfixed
    simp [referenceProposition] at heq
  · rw [permittedAttributionProposition_iff] at hpermitted
    rcases hpermitted with ⟨source, _⟩
    exact nomatch source

/--
The non-neutral substrate's foundational layer is not restricted to the
permitted classes: it commits to the contested proposition.
-/
theorem not_restricted_nonNeutral :
    ¬ FoundationalLayerRestrictedToPermittedClasses
        consequence substrates closureFixing attribution attributionBasis
        nonNeutralSubstrate := by
  intro hrestricted
  rw [foundationalLayerRestrictedToPermittedClasses_iff] at hrestricted
  rcases hrestricted contestedProposition NonNeutral.commitsToContested with
    hmem | hpermitted
  · have hfixed := (mem_referentialCommitments_iff.mp hmem).2
    have hcontested := hfixed Neutral.referenceOnly referenceOnly_satisfies_reference
    simp [Neutral.referenceOnly, contestedProposition] at hcontested
  · rw [permittedAttributionProposition_iff] at hpermitted
    rcases hpermitted with ⟨source, _⟩
    exact nomatch source

/-! ## Design-time guarantee -/

/--
A design-time guarantee system whose permitted bases are the substrates with
a restricted foundational layer.

A substrate `b` establishes a proposition `P` when `P` is the neutrality of
`b`. Soundness is the sufficiency theorem: under Referential Common Ground, a
restricted foundational layer is neutral.
-/
def designGuarantee : DesignTimeGuaranteeSystem where
  Basis := substrates.Carrier
  permitted := fun b =>
    FoundationalLayerRestrictedToPermittedClasses
      consequence substrates closureFixing attribution attributionBasis b
  establishes := fun b P =>
    P = Neutral consequence substrates b frameworks
  sound := by
    intro b P hpermitted hestablishes
    have hrestricted :
        FoundationalLayerRestrictedToPermittedClasses
          consequence substrates closureFixing attribution attributionBasis b :=
      hpermitted
    have hP : P = Neutral consequence substrates b frameworks :=
      hestablishes
    rw [hP]
    exact
      neutral_of_restricted_of_commonGround
        hrestricted (referentialCommonGround b)

/--
A substrate's neutrality is guaranteed at design time exactly when its
foundational layer is restricted to the permitted classes.
-/
theorem guaranteedAtDesignTime_neutral_iff_restricted
    (s : substrates.Carrier) :
    GuaranteedAtDesignTime designGuarantee
        (Neutral consequence substrates s frameworks) ↔
      FoundationalLayerRestrictedToPermittedClasses
        consequence substrates closureFixing attribution attributionBasis s := by
  constructor
  · intro hguaranteed
    have hneutral := holds_of_guaranteedAtDesignTime hguaranteed
    cases s with
    | neutral => exact restricted_neutral
    | nonNeutral => exact False.elim (NonNeutral.not_neutral hneutral)
  · intro hrestricted
    exact
      guaranteedAtDesignTime_of_establishes
        (G := designGuarantee) (basis := s) hrestricted rfl

/-! ## Contestability -/

/--
The contested proposition is not framework-invariant for any substrate of the
model: the denying framework is admissible and refutes it.
-/
theorem not_frameworkInvariant_contested (s : substrates.Carrier) :
    ¬ FrameworkInvariantProposition
        consequence substrates s frameworks contestedProposition := by
  intro hinvariant
  have hconsistent :=
    (frameworkInvariantProposition_iff.mp hinvariant)
      denyingFramework Neutral.denyingFramework_admissible
  apply not_entailsBottom_of_consistent hconsistent
  apply consequence.contradiction (p := contestedProposition)
  · apply consequence.entailsOfMem
    rw [mem_adjoin_iff]
    right
    rfl
  · apply consequence.entailsOfMem
    rw [mem_adjoin_iff]
    left
    rw [substrateFrameworkCommitments_eq, mem_combine_iff]
    right
    rw [denyingFramework_commitments]
    exact rfl

/--
Contestability holds in the realization for every substrate of the model.
-/
theorem contestability (s : substrates.Carrier) :
    Contestability
      consequence classification context statusFixing
      substrates closureFixing s frameworks designGuarantee := by
  rw [contestability_iff]
  intro p hp
  have hcn : CausalOrNormativeProposition classification context p :=
    causalOrNormativeProposition_of_contestedCausalOrNormativeProposition
      (mem_contestedCausalOrNormativeClass_iff.mp hp)
  rw [causalOrNormativeProposition_iff, causalProposition_iff,
    normativeProposition_iff] at hcn
  have hpeq : p = contestedProposition := by
    rcases hcn with hcausal | hnormative
    · exact False.elim hcausal
    · exact hnormative
  subst hpeq
  intro hguaranteed
  exact not_frameworkInvariant_contested s
    (holds_of_guaranteedAtDesignTime hguaranteed)

/--
The contested class is non-empty for the neutral substrate, so
Contestability is not satisfied merely because the class is empty.
-/
theorem contested_mem_class :
    contestedProposition ∈
      ContestedCausalOrNormativeClass
        consequence classification context statusFixing
        substrates closureFixing neutralSubstrate := by
  rw [mem_contestedCausalOrNormativeClass_iff,
    contestedCausalOrNormativeProposition_iff]
  refine ⟨?_, ?_⟩
  · rw [causalOrNormativeProposition_iff, causalProposition_iff,
      normativeProposition_iff]
    exact Or.inr rfl
  intro hfixed
  rcases hfixed with hentails | hentailsNeg
  · have hsat :=
      satisfies_referentialCommitments
        (s := neutralSubstrate) referenceOnly_satisfies_reference
    have hcontested := hentails Neutral.referenceOnly hsat
    simp [Neutral.referenceOnly, contestedProposition] at hcontested
  · have hsat :=
      satisfies_referentialCommitments
        (s := neutralSubstrate) allTrue_satisfies_reference
    have hneg := hentailsNeg Neutral.allTrue hsat
    simp [Neutral.allTrue, contestedProposition] at hneg

/-! ## Characterization hypothesis -/

/--
The neutral substrate makes no object-level causal or normative commitment.
-/
theorem noObjectLevelCommitment_neutral :
    NoObjectLevelCausalOrNormativeCommitment
      consequence classification context attribution interpretation
      substrates neutralSubstrate := by
  rw [noObjectLevelCausalOrNormativeCommitment_iff]
  intro p hp
  have hcommit :
      SubstrateCommitment consequence substrates neutralSubstrate p :=
    substrateCommitment_of_objectLevelCausalOrNormativeCommitment hp
  have hcn :=
    causalOrNormativeProposition_of_objectLevelCausalOrNormativeCommitment hp
  rw [causalOrNormativeProposition_iff, causalProposition_iff,
    normativeProposition_iff] at hcn
  have hpeq : p = contestedProposition := by
    rcases hcn with hcausal | hnormative
    · exact False.elim hcausal
    · exact hnormative
  subst hpeq
  exact Neutral.neutral_abstains_on_contested.1 hcommit

/--
The characterization hypothesis holds for the neutral substrate.
-/
theorem characterizationHypothesis_neutral :
    CharacterizationHypothesis
      consequence classification context statusFixing
      substrates closureFixing attribution attributionBasis interpretation
      neutralSubstrate frameworks designGuarantee := by
  rw [characterizationHypothesis_iff]
  intro _ _
  refine ⟨?_, fun _ => noObjectLevelCommitment_neutral⟩
  rw [neutralByDesign_iff]
  exact guaranteedAtDesignTime_neutral_iff_restricted neutralSubstrate

/--
The characterization hypothesis holds for the non-neutral substrate: both
sides of the equivalence are false.
-/
theorem characterizationHypothesis_nonNeutral :
    CharacterizationHypothesis
      consequence classification context statusFixing
      substrates closureFixing attribution attributionBasis interpretation
      nonNeutralSubstrate frameworks designGuarantee := by
  rw [characterizationHypothesis_iff]
  intro _ _
  refine ⟨?_, fun hrestricted => ?_⟩
  · rw [neutralByDesign_iff]
    exact guaranteedAtDesignTime_neutral_iff_restricted nonNeutralSubstrate
  · exact False.elim (not_restricted_nonNeutral hrestricted)

/-! ## Headline results -/

/--
Contestability, Referential Common Ground, and the characterization
hypothesis hold together for the neutral substrate of the discriminating
model.
-/
theorem assumptions_jointly_satisfiable :
    Contestability
        consequence classification context statusFixing
        substrates closureFixing neutralSubstrate frameworks designGuarantee ∧
      ReferentialCommonGround
        consequence substrates closureFixing attribution attributionBasis
        neutralSubstrate frameworks ∧
      CharacterizationHypothesis
        consequence classification context statusFixing
        substrates closureFixing attribution attributionBasis interpretation
        neutralSubstrate frameworks designGuarantee :=
  ⟨contestability neutralSubstrate,
    referentialCommonGround neutralSubstrate,
    characterizationHypothesis_neutral⟩

/--
The constraint theorem applies to the neutral substrate: it is neutral by
design exactly when its foundational layer is restricted, and both hold.
-/
theorem neutralByDesign_iff_restricted_neutral :
    NeutralByDesign consequence substrates neutralSubstrate frameworks
        designGuarantee ↔
      FoundationalLayerRestrictedToPermittedClasses
        consequence substrates closureFixing attribution attributionBasis
        neutralSubstrate :=
  neutralByDesign_iff_foundationalLayerRestricted
    characterizationHypothesis_neutral
    (contestability neutralSubstrate)
    (referentialCommonGround neutralSubstrate)

/--
The neutral substrate is neutral by design in the realization.
-/
theorem neutralByDesign_neutral :
    NeutralByDesign consequence substrates neutralSubstrate frameworks
      designGuarantee :=
  neutralByDesign_iff_restricted_neutral.mpr restricted_neutral

/--
The non-neutral substrate is not neutral by design in the realization.
-/
theorem not_neutralByDesign_nonNeutral :
    ¬ NeutralByDesign consequence substrates nonNeutralSubstrate frameworks
        designGuarantee :=
  fun hdesign =>
    NonNeutral.not_neutral (neutral_of_neutralByDesign hdesign)

/--
The constraint theorem derives, for the neutral substrate, that it makes no
object-level causal or normative commitment.
-/
theorem noObjectLevelCommitment_of_neutralByDesign_neutral :
    NoObjectLevelCausalOrNormativeCommitment
      consequence classification context attribution interpretation
      substrates neutralSubstrate :=
  noObjectLevelCommitment_of_neutralByDesign
    characterizationHypothesis_neutral
    (contestability neutralSubstrate)
    (referentialCommonGround neutralSubstrate)
    neutralByDesign_neutral

end

end SETest.NeutralSubstrate.Model.Discriminating.Assumptions
