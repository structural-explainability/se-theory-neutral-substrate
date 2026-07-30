/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SETest.NeutralSubstrate.Model.Consequence
public import SE.Framework.Class

/-!
# Discriminating Frameworks

Concrete admissible-framework candidates for the discriminating
Neutral Substrate model.

The language contains:

- one referential proposition; and
- one contested proposition.

The two frameworks disagree about the contested proposition:

- the affirming framework commits to the proposition;
- the denying framework commits to its negation.

Neither framework commits to the negation of its own commitment.
Their consistency and admissibility are proved in the later model modules.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Model.Discriminating

open SE.Framework
open SE.Logic.Theory
open SETest.NeutralSubstrate.Model

@[expose] public section

/--
The atoms used by the discriminating model.
-/
inductive Atom where
  | reference
  | contested
  deriving DecidableEq

/--
The concrete propositional language used by the discriminating model.
-/
abbrev language :=
  formulaLanguage Atom

/--
The model-theoretic consequence system used by the discriminating model.
-/
abbrev consequence :=
  modelConsequence Atom

/--
A proposition representing stable referential content.
-/
def referenceProposition : Formula Atom :=
  Formula.atom .reference

/--
A proposition on which the two frameworks disagree.
-/
def contestedProposition : Formula Atom :=
  Formula.atom .contested

/--
The object-language negation of the contested proposition.
-/
def negatedContestedProposition : Formula Atom :=
  language.neg contestedProposition

/--
The two concrete interpretive frameworks.
-/
inductive FrameworkView where
  | affirming
  | denying
  deriving DecidableEq

/--
The discriminating framework system.

The affirming framework commits to the contested proposition.
The denying framework commits to its object-language negation.
All evidentiary and documentation conditions are witnessed trivially;
semantic consistency is proved separately.
-/
def frameworks : FrameworkSystem language.carrier where
  Carrier := FrameworkView
  commitments := fun
    | .affirming => {contestedProposition}
    | .denying => {negatedContestedProposition}
  evidentiallyGrounded := fun _ => True
  presentedAsInterpretiveFunction := fun _ => True
  hasNamedSource := fun _ => True
  hasDocumentedScope := fun _ => True
  hasCitableBasis := fun _ => True

/--
The framework that affirms the contested proposition.
-/
def affirmingFramework : frameworks.Carrier :=
  .affirming

/--
The framework that denies the contested proposition.
-/
def denyingFramework : frameworks.Carrier :=
  .denying

@[simp]
theorem affirmingFramework_commitments :
    frameworks.commitments affirmingFramework =
      ({contestedProposition} :
        CommitmentTheory language.carrier) :=
  rfl

@[simp]
theorem denyingFramework_commitments :
    frameworks.commitments denyingFramework =
      ({negatedContestedProposition} :
        CommitmentTheory language.carrier) :=
  rfl

@[simp]
theorem affirmingFramework_ne_denyingFramework :
    affirmingFramework ≠ denyingFramework := by
  simp [affirmingFramework, denyingFramework]

@[simp]
theorem referenceProposition_ne_contestedProposition :
    referenceProposition ≠ contestedProposition := by
  simp [referenceProposition, contestedProposition]

end

end SETest.NeutralSubstrate.Model.Discriminating
