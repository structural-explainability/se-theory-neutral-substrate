/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Referent.Carriers

/-!
# Referential Regime

This module formalizes:

- `se100.def.ReferentialRegime` — Referential Regime

A referential regime is the triple of individuation, co-reference, and
persistence conditions by which a substrate fixes and tracks entities,
occurrences, and institutional artifacts.

The conditions are represented abstractly as binary relations over each
referent carrier. No equivalence-relation laws, decidability, finiteness,
enumeration, or computational representation are assumed here.

Later theories may impose additional structure on particular referential
regimes without changing this Paper 100 interface.
-/

set_option autoImplicit false

namespace SE.Substrate

open SE.Referent

universe u

public section

/--
A family of conditions over the three referent carriers.

Each field gives the condition applicable to one referent kind. No
relationship among the three conditions is assumed.
-/
structure ReferentConditionFamily
    (R : ReferentCarriers.{u}) where

  /--
  The condition over entities.
  -/
  entity :
    R.Entity →
    R.Entity →
    Prop

  /--
  The condition over occurrences.
  -/
  occurrence :
    R.Occurrence →
    R.Occurrence →
    Prop

  /--
  The condition over institutional artifacts.
  -/
  institutionalArtifact :
    R.InstitutionalArtifact →
    R.InstitutionalArtifact →
    Prop

/--
The triple of individuation, co-reference, and persistence conditions by
which a substrate fixes and tracks entities, occurrences, and institutional
artifacts.
-/
structure ReferentialRegime
    (R : ReferentCarriers.{u}) where

  /--
  Conditions determining when something counts as one thing rather than
  another.
  -/
  individuationConditions :
    ReferentConditionFamily R

  /--
  Conditions determining when two references are treated as referring to
  the same thing.
  -/
  coReferenceConditions :
    ReferentConditionFamily R

  /--
  Conditions determining when something remains the same across time,
  transformation, revision, or institutional change.
  -/
  persistenceConditions :
    ReferentConditionFamily R

end

end SE.Substrate
