/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Language.Basic

/-!
# Causal and Normative Content

This module formalizes:

- `se100.note.CausalNormative` — Causal and Normative Content as Primitive
  Classifications

Causal and normative propositions are treated as primitive,
accountability-context-relative content classifications.

The classifications are not reduced to surface vocabulary or to a formal
decision procedure.
No decidability, exhaustiveness, mutual exclusion, or
computational classification method is assumed.

A proposition may therefore be:

- causal;
- normative;
- both causal and normative; or
- neither causal nor normative

in a given accountability context.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.Classification

open SE.Logic.Language

universe u v

public section

-- RR.DEFINES: SE.NeutralSubstrate.Classification.CausalNormativeClassification
-- RR.IMPLEMENTS: se100.note.CausalNormative
/--
An abstract, context-relative classification of object-language propositions
as causal or normative.

Concrete realizations may determine these classifications through domain
analysis, governance rules, expert judgment, or another declared method.
This theory assumes only that the classifications have been fixed for the
relevant accountability context.
-/
structure CausalNormativeClassification
    (L : PropositionalLanguage.{u}) where

  /--
  The carrier of accountability contexts in which content classifications
  are fixed.
  -/
  Context : Type v

  /--
  Whether a proposition is classified as causal in an accountability context.
  -/
  causal :
    Context →
    L.Proposition →
    Prop

  /--
  Whether a proposition is classified as normative in an accountability
  context.
  -/
  normative :
    Context →
    L.Proposition →
    Prop

-- RR.DEFINES: SE.NeutralSubstrate.Classification.CausalProposition
/--
A proposition is causal in an accountability context when the selected
classification system classifies it as causal.
-/
def CausalProposition
    {L : PropositionalLanguage.{u}}
    (K : CausalNormativeClassification.{u, v} L)
    (c : K.Context)
    (p : L.Proposition) :
    Prop :=
  K.causal c p

-- RR.DEFINES: SE.NeutralSubstrate.Classification.NormativeProposition
/--
A proposition is normative in an accountability context when the selected
classification system classifies it as normative.
-/
def NormativeProposition
    {L : PropositionalLanguage.{u}}
    (K : CausalNormativeClassification.{u, v} L)
    (c : K.Context)
    (p : L.Proposition) :
    Prop :=
  K.normative c p

-- RR.DEFINES: SE.NeutralSubstrate.Classification.CausalOrNormativeProposition
/--
A proposition is causal or normative in an accountability context when it
has at least one of the two primitive classifications.
-/
def CausalOrNormativeProposition
    {L : PropositionalLanguage.{u}}
    (K : CausalNormativeClassification.{u, v} L)
    (c : K.Context)
    (p : L.Proposition) :
    Prop :=
  CausalProposition K c p ∨
    NormativeProposition K c p

end

end SE.NeutralSubstrate.Classification
