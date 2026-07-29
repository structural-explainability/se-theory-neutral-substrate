/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import Mathlib.Data.Set.Basic
public import SE.Logic.Language.PropositionCarrier

/-!
# AUX-004. Commitment Theory

This module defines a commitment theory as a set of object-language
propositions.

Commitment theories are not assumed to be finite, enumerable, decidable,
complete, or internally consistent.
-/

set_option autoImplicit false

namespace SE.Logic.Theory

universe u

public section

/--
A collection of object-language propositions treated as commitments.

A commitment theory is represented as a `Set`, so no finiteness,
enumeration, or decidable membership assumption is imposed.
-/
abbrev CommitmentTheory (P : SE.Logic.Language.PropositionCarrier.{u}) :=
  Set P.Proposition

end

end SE.Logic.Theory
