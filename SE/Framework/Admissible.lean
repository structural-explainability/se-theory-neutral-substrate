/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Framework.Basic
public import SE.Logic.Consistency

/-!
# Admissible Framework

This module formalizes:

- `se100.def.AdmissibleFramework` — Admissible Framework

A framework is admissible when it satisfies three conditions:

1. internal consistency;
2. evidentiary grounding; and
3. documented interpretive function.

The documented interpretive-function condition requires presentation as an
interpretive function together with a named source, documented scope, and
citable basis.
-/

set_option autoImplicit false

namespace SE.Framework

open SE.Logic
open SE.Logic.Language

universe u v

public section

variable
  {L : PropositionalLanguage.{u}}

/--
A framework has a documented interpretive function when it is presented as
an interpretive function with a named source, documented scope, and citable
basis.

This groups the four requirements that constitute the third admissibility
condition in the paper.
-/
def DocumentedInterpretiveFunction
    (M : FrameworkSystem L.carrier)
    (F : M.Carrier) :
    Prop :=
  M.presentedAsInterpretiveFunction F ∧
    M.hasNamedSource F ∧
    M.hasDocumentedScope F ∧
    M.hasCitableBasis F

/--
A candidate framework is admissible when it is internally consistent,
evidentially grounded, and has a documented interpretive function.
-/
def AdmissibleFramework
    (C : ConsequenceSystem L)
    (M : FrameworkSystem.{u, v} L.carrier)
    (F : M.Carrier) :
    Prop :=
  Consistent C (M.commitments F) ∧
    M.evidentiallyGrounded F ∧
    DocumentedInterpretiveFunction M F

end

end SE.Framework
