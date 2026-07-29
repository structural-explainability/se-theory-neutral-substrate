/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Language.Basic

/-!
# Attribution Propositions

This module formalizes:

- `se100.def.AttributionProposition` — Attribution Proposition

An attribution proposition is an object-language proposition of the form
`asserts x φ`, meaning that a framework, source, agent, institution, record,
or document `x` asserts proposition `φ`.

The source carrier and the proposition-forming operation are abstract.
Concrete realizations may represent different kinds of attribution sources
within the same carrier.

No injectivity, decidable equality, source enumeration, or computational
encoding assumption is imposed.

In particular, this module introduces no entailment from `asserts x φ` to
`φ`. A substrate may therefore commit to the attribution proposition without
thereby committing to the asserted proposition.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.Attribution

open SE.Logic.Language

universe u v

public section

/--
An object-language attribution interface.

`Source` supplies the possible bearers of attributed assertions.
`asserts x φ` is the object-language proposition stating that source `x`
asserts proposition `φ`.
-/
structure AttributionSystem
    (L : PropositionalLanguage.{u}) where

  /--
  The carrier of frameworks, sources, agents, institutions, records,
  documents, or other identified attribution sources.
  -/
  Source : Type v

  /--
  The object-language proposition stating that a source asserts a
  proposition.
  -/
  asserts :
    Source →
    L.Proposition →
    L.Proposition

/--
An attribution proposition is a proposition of the form `asserts x φ` for
some attribution source `x` and asserted proposition `φ`.
-/
def AttributionProposition
    {L : PropositionalLanguage.{u}}
    (A : AttributionSystem.{u, v} L)
    (p : L.Proposition) :
    Prop :=
  ∃ x φ, p = A.asserts x φ

/--
Every proposition constructed by `asserts` is an attribution proposition.
-/
theorem attributionProposition_asserts
    {L : PropositionalLanguage.{u}}
    (A : AttributionSystem.{u, v} L)
    (x : A.Source)
    (φ : L.Proposition) :
    AttributionProposition A (A.asserts x φ) := by
  exact ⟨x, φ, rfl⟩

/--
An attribution proposition has a source and an asserted proposition whose
attribution form equals it.
-/
theorem exists_asserts_eq_of_attributionProposition
    {L : PropositionalLanguage.{u}}
    {A : AttributionSystem.{u, v} L}
    {p : L.Proposition}
    (hp : AttributionProposition A p) :
    ∃ x φ, p = A.asserts x φ :=
  hp

end

end SE.NeutralSubstrate.Attribution
