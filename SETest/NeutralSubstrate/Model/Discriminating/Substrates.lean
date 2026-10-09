module

public import SETest.NeutralSubstrate.Model.Discriminating.Frameworks
public import SE.Substrate.ReferentialCommitments
public import SE.Substrate.ReferentialRegime

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
The trivial individuation account used by the discriminating model.

The model uses singleton presentations and referent carriers because its
semantic discrimination concerns substrate commitments rather than
individuation.
-/
def individuationAccount : IndividuationAccount Unit where
  Context := Unit
  Presentation := Unit
  presents := fun _ _ _ => True
  admissiblePresentation := fun _ _ => True
  one := fun _ _ => True
  sameUnit := fun _ _ _ => True

/--
The individuation regime shared by both discriminating substrates.
-/
def individuationRegime : IndividuationRegime referents where
  entity := individuationAccount
  occurrence := individuationAccount
  institutionalArtifact := individuationAccount

/--
The trivial co-reference account used by the discriminating model.
-/
def coReferenceAccount : CoReferenceAccount Unit where
  Context := Unit
  Reference := Unit
  coReference := fun _ _ _ => True

/--
The co-reference regime shared by both discriminating substrates.
-/
def coReferenceRegime : CoReferenceRegime referents where
  entity := coReferenceAccount
  occurrence := coReferenceAccount
  institutionalArtifact := coReferenceAccount

/--
The trivial persistence account used by the discriminating model.

The model uses singleton stages and settings because its semantic
discrimination concerns substrate commitments rather than persistence.
-/
def persistenceAccount : PersistenceAccount Unit where
  Setting := Unit
  Stage := Unit
  eligibleStage := fun _ _ => True
  persists := fun _ _ _ _ => True

/--
The persistence regime shared by both discriminating substrates.
-/
def persistenceRegime : PersistenceRegime referents where
  entity := persistenceAccount
  occurrence := persistenceAccount
  institutionalArtifact := persistenceAccount

/--
The referential regime shared by both concrete substrates.
-/
def referentialRegime : ReferentialRegime referents where
  individuation := individuationRegime
  coReference := coReferenceRegime
  persistence := persistenceRegime

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
  change SubstrateView.neutral ≠ SubstrateView.nonNeutral
  intro h
  cases h

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
