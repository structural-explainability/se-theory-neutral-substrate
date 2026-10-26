/-
Copyright (c) 2026 Denise M. Case. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import MathlibMini.Set
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

-- RR.DEFINES: SE.Logic.Theory.CommitmentTheory
/--
A collection of object-language propositions treated as commitments.

A commitment theory is represented as a `Set`, so no finiteness,
enumeration, or decidable membership assumption is imposed.
-/
abbrev CommitmentTheory (P : SE.Logic.Language.PropositionCarrier.{u}) :=
  MathlibMini.Set P.Proposition

end

end SE.Logic.Theory
