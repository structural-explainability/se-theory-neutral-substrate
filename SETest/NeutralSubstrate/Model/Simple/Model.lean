module

public import SETest.NeutralSubstrate.Model.Consequence
public import SE.Framework.Basic
public import SE.Referent.Carriers
public import SE.Substrate.Basic
public import SE.Substrate.ReferentialRegime

/-!
# Simple Neutral-Substrate Model

A minimal concrete realization of the Neutral Substrate interfaces.

The model has:

- one object-language atom;
- one substrate;
- one framework;
- empty substrate and framework commitment theories; and
- a trivial referential regime.

This model witnesses that the interface hierarchy is jointly inhabited.
The discriminating model provides the stronger non-vacuity witnesses.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Model.Simple

open SE.Framework
open SE.Logic.Theory
open SE.Referent
open SE.Substrate
open SETest.NeutralSubstrate.Model

@[expose] public section

/--
The single atom used by the simple model.
-/
inductive Atom where
  | reference
  deriving DecidableEq

/--
The concrete object language used by the simple model.
-/
abbrev language :=
  formulaLanguage Atom

/--
The model-theoretic consequence system used by the simple model.
-/
abbrev consequence :=
  modelConsequence Atom

/--
A concrete proposition witnessing that the object language is inhabited.
-/
def referenceProposition : Formula Atom :=
  Formula.atom .reference

/--
The simple referent carriers.

Each referent category has one inhabitant. The categories remain distinct
at the type-interface level even though each is realized by `Unit`.
-/
def referents : ReferentCarriers where
  Entity := Unit
  Occurrence := Unit
  InstitutionalArtifact := Unit

/--
The trivial individuation account used by the simple model.

The model has singleton candidate presentations and referent carriers, so
all individuation judgments hold trivially.
-/
def individuationAccount : IndividuationAccount Unit where
  Context := Unit
  Presentation := Unit
  presents := fun _ _ _ => True
  admissiblePresentation := fun _ _ => True
  one := fun _ _ => True
  sameUnit := fun _ _ _ => True

/--
The trivial individuation regime used by the simple model.
-/
def individuation : IndividuationRegime referents where
  entity := individuationAccount
  occurrence := individuationAccount
  institutionalArtifact := individuationAccount

/--
The trivial co-reference account used by the simple model.
-/
def coReferenceAccount : CoReferenceAccount Unit where
  Context := Unit
  Reference := Unit
  coReference := fun _ _ _ => True

/--
The trivial co-reference regime used by the simple model.
-/
def coReference : CoReferenceRegime referents where
  entity := coReferenceAccount
  occurrence := coReferenceAccount
  institutionalArtifact := coReferenceAccount

/--
The trivial persistence account used by the simple model.
-/
def persistenceAccount : PersistenceAccount Unit where
  Setting := Unit
  Stage := Unit
  eligibleStage := fun _ _ => True
  persists := fun _ _ _ _ => True

/--
The trivial persistence regime used by the simple model.
-/
def persistence : PersistenceRegime referents where
  entity := persistenceAccount
  occurrence := persistenceAccount
  institutionalArtifact := persistenceAccount

/--
The trivial referential regime used by the simple substrate.
-/
def referentialRegime : ReferentialRegime referents where
  individuation := individuation
  coReference := coReference
  persistence := persistence
/--
The simple substrate system.

It has one substrate whose commitment theory is empty.
-/
def substrates : SubstrateSystem language referents where
  Carrier := Unit
  commitments := fun _ => ∅
  referentialRegime := fun _ => referentialRegime

/--
The unique substrate in the simple model.
-/
def substrate : substrates.Carrier :=
  ()

/--
The simple framework system.

It has one framework whose commitment theory is empty. Its evidentiary
and documentation conditions are satisfied trivially.
-/
def frameworks : FrameworkSystem language.carrier where
  Carrier := Unit
  commitments := fun _ => ∅
  evidentiallyGrounded := fun _ => True
  presentedAsInterpretiveFunction:= fun _ => True
  hasNamedSource := fun _ => True
  hasDocumentedScope := fun _ => True
  hasCitableBasis := fun _ => True

/--
The unique framework in the simple model.
-/
def framework : frameworks.Carrier :=
  ()

@[simp]
theorem substrate_commitments :
    substrates.commitments substrate =
      (∅ : CommitmentTheory language.carrier) :=
  rfl

@[simp]
theorem framework_commitments :
    frameworks.commitments framework =
      (∅ : CommitmentTheory language.carrier) :=
  rfl

/--
The simple language has a satisfiable proposition.
-/
theorem referenceProposition_satisfiable :
    ∃ v : Atom → Prop, Sat v referenceProposition := by
  refine ⟨fun _ => True, ?_⟩
  simp [referenceProposition]

/--
The substrate and framework carriers are inhabited.
-/
theorem carriers_inhabited :
    Nonempty substrates.Carrier ∧
      Nonempty frameworks.Carrier :=
  ⟨⟨substrate⟩, ⟨framework⟩⟩

end

end SETest.NeutralSubstrate.Model.Simple
