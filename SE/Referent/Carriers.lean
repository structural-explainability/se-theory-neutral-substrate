/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

/-!
# AUX-010. Referent Carriers

This module defines the carriers over which referential regimes operate.

Paper 100 distinguishes referents of three kinds:

- entities;
- occurrences; and
- institutional artifacts.

The carriers are intentionally abstract. No finiteness, decidable equality,
enumeration, identity relation, persistence relation, or computational
representation is assumed here.

Referential regimes define the relevant individuation, co-reference, and
persistence conditions separately.
-/

set_option autoImplicit false

namespace SE.Referent

universe u

public section

/--
The abstract carriers of referents distinguished by the Structural
Explainability theory.

The entity, occurrence, and institutional-artifact carriers are independent
types within a shared universe.
-/
structure ReferentCarriers where
  /--
  The carrier of entities.
  -/
  Entity : Type u

  /--
  The carrier of occurrences.
  -/
  Occurrence : Type u

  /--
  The carrier of institutional artifacts.
  -/
  InstitutionalArtifact : Type u

end

end SE.Referent
