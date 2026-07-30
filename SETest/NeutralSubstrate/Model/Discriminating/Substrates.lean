/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SETest.NeutralSubstrate.Model.Discriminating.Frameworks
public import SE.Substrate.ReferentialCommitments

/-!
# Discriminating Substrates

Concrete substrate realizations for the discriminating model.

The model contains two substrates in one substrate system:

- `neutralSubstrate` commits only to stable referential content;
- `nonNeutralSubstrate` additionally commits directly to the contested
  proposition.

The two substrates therefore share the same language, referent carriers,
referential regime, and framework system. They differ only in whether the
contested proposition is embedded in the substrate commitment theory.

This isolates the neutrality distinction tested by the later
`Neutral.lean` and `NonNeutral.lean` modules.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Model.Discriminating

open SE.Logic.Theory
open SE.Referent
open SE.Substrate

@[expose] public section

/--
The referent carriers used by the discriminating model.

Each referent category is inhabited by one value. The semantic
discrimination in this model concerns substrate commitments rather than
the cardinality of the referent carriers.
-/
def referents : ReferentCarriers where
  Entity := Unit
  Occurrence := Unit
  InstitutionalArtifact := Unit

/--
The universal condition family over the model's referent carriers.
-/
def conditionFamily : ReferentConditionFamily referents where
  entity := fun _ _ => True
  occurrence := fun _ _ => True
  institutionalArtifact := fun _ _ => True

/--
The referential regime shared by both concrete substrates.
-/
def referentialRegime : ReferentialRegime referents where
  individuationConditions := conditionFamily
  coReferenceConditions := conditionFamily
  persistenceConditions := conditionFamily

/--
The propositions fixed by the model's referential regime.

Only the stable reference proposition is treated as referentially fixed.
The contested proposition is deliberately excluded.
-/
def referentialFixing : ReferentialFixing language referents where
  fixedBy := fun _ p => p = referenceProposition

/--
The two substrate realizations.

The neutral realization contains only referential content.
The non-neutral realization additionally contains the contested
object-level proposition.
-/
inductive SubstrateView where
  | neutral
  | nonNeutral
  deriving DecidableEq

/--
The discriminating substrate system.
-/
def substrates : SubstrateSystem language referents where
  Carrier := SubstrateView
  commitments := fun
    | .neutral =>
        {referenceProposition}
    | .nonNeutral =>
        {referenceProposition, contestedProposition}
  referentialRegime := fun _ => referentialRegime

/--
The substrate containing only the stable reference proposition.
-/
def neutralSubstrate : substrates.Carrier :=
  .neutral

/--
The substrate that also commits directly to the contested proposition.
-/
def nonNeutralSubstrate : substrates.Carrier :=
  .nonNeutral

@[simp]
theorem neutralSubstrate_commitments :
    substrates.commitments neutralSubstrate =
      ({referenceProposition} :
        CommitmentTheory language.carrier) :=
  rfl

@[simp]
theorem nonNeutralSubstrate_commitments :
    substrates.commitments nonNeutralSubstrate =
      ({referenceProposition, contestedProposition} :
        CommitmentTheory language.carrier) :=
  rfl

@[simp]
theorem neutralSubstrate_ne_nonNeutralSubstrate :
    neutralSubstrate ≠ nonNeutralSubstrate := by
  simp [neutralSubstrate, nonNeutralSubstrate]

@[simp]
theorem referentialFixing_fixedBy_iff
    (s : substrates.Carrier)
    (p : language.Proposition) :
    referentialFixing.fixedBy
        (substrates.referentialRegime s) p ↔
      p = referenceProposition :=
  Iff.rfl

end

end SETest.NeutralSubstrate.Model.Discriminating
