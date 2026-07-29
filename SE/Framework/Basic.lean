/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Theory.CommitmentTheory

/-!
# Framework

This module defines the abstract interface for candidate interpretive
frameworks.

A framework has a commitment theory together with the properties needed to
state evidentiary grounding and documented interpretive function.

This interface does not require a framework to be admissible. Admissibility
is defined separately.

The framework carrier is not assumed to be finite, enumerable, decidable,
or known at design time.
-/

set_option autoImplicit false

namespace SE.Framework

open SE.Logic.Language
open SE.Logic.Theory

universe u v

public section

/--
An abstract interface for candidate interpretive frameworks over an
object-language proposition carrier.

The interface exposes only the information required by the admissibility
definition. Concrete framework representations may supply this information
from richer evidence, provenance, documentation, or interpretation records.
-/
structure FrameworkSystem (P : PropositionCarrier.{u}) where
  /--
  The carrier of candidate interpretive frameworks.
  -/
  Carrier : Type v

  /--
  The commitment theory associated with a framework.
  -/
  commitments :
    Carrier →
    CommitmentTheory P

  /--
  Whether the framework satisfies the paper's evidentiary-grounding
  condition.
  -/
  evidentiallyGrounded :
    Carrier →
    Prop

  /--
  Whether the framework is presented as an interpretive function.
  -/
  presentedAsInterpretiveFunction :
    Carrier →
    Prop

  /--
  Whether the framework has a named source.
  -/
  hasNamedSource :
    Carrier →
    Prop

  /--
  Whether the framework has documented scope.
  -/
  hasDocumentedScope :
    Carrier →
    Prop

  /--
  Whether the framework has a citable basis.
  -/
  hasCitableBasis :
    Carrier →
    Prop

end

end SE.Framework
