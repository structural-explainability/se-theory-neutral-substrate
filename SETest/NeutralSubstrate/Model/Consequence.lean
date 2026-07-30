/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SETest.NeutralSubstrate.Model.Language
public import SE.Logic.Consequence

/-!
# Semantic Consequence System for Model Tests

The model-theoretic consequence relation over `Formula α`: `Entails T p` holds
when every valuation satisfying all of `T` satisfies `p`.

This choice discharges the three `ConsequenceSystem` laws cleanly and stays
non-degenerate:

- `entailsOfMem` and `cut` are immediate from the definition;
- `contradiction` holds because `bot` is unsatisfiable, so a theory forcing
  both `p` and `neg p` has no model and vacuously entails `bot`;
- `Consistent C T` is exactly "`T` has a model", so consistency is a real,
  checkable property — which the discriminating model will exploit.

The laws are proved as standalone lemmas on the raw `Formula` constructors
(no dependence on the language projections), then assembled. Only the final
assembly relies on the upstream `@[expose]` prerequisite, at the points where
the field types mention `(formulaLanguage α).neg`/`.bottom`.
-/

set_option autoImplicit false

@[expose] public section

namespace SETest.NeutralSubstrate.Model

open SE.Logic
open SE.Logic.Language
open SE.Logic.Theory

/-- A valuation satisfies a commitment theory when it satisfies every member. -/
def Satisfies {α : Type} (v : α → Prop)
    (T : CommitmentTheory (formulaLanguage α).carrier) : Prop :=
  ∀ q ∈ T, Sat v q

/-- Model-theoretic consequence: every model of `T` is a model of `p`. -/
def Entails {α : Type}
    (T : CommitmentTheory (formulaLanguage α).carrier) (p : Formula α) : Prop :=
  ∀ v, Satisfies v T → Sat v p

theorem Entails.ofMem {α : Type}
    {T : CommitmentTheory (formulaLanguage α).carrier} {p : Formula α}
    (h : p ∈ T) : Entails T p :=
  fun _ hv => hv p h

theorem Entails.cut {α : Type}
    {T U : CommitmentTheory (formulaLanguage α).carrier} {p : Formula α}
    (hU : ∀ q ∈ U, Entails T q) (hUp : Entails U p) : Entails T p :=
  fun v hv => hUp v (fun q hq => hU q hq v hv)

theorem Entails.contradiction {α : Type}
    {T : CommitmentTheory (formulaLanguage α).carrier} {p : Formula α}
    (hp : Entails T p) (hnp : Entails T (Formula.neg p)) :
    Entails T (Formula.bot : Formula α) :=
  fun v hv => (hnp v hv) (hp v hv)

/-- The concrete consequence system on `Formula α`. -/
def modelConsequence (α : Type) : ConsequenceSystem (formulaLanguage α) where
  entails := Entails
  entailsOfMem := Entails.ofMem
  cut := Entails.cut
  contradiction := fun hp hnp => Entails.contradiction hp hnp

end SETest.NeutralSubstrate.Model

end
