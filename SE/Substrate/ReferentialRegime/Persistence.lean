module

public import SE.Referent.Carriers

/-!
**# Persistence**

This module defines the abstract persistence interface used by a
referential regime.

Persistence concerns strict diachronic identity: whether eligible whole
stages count as stages of the same continuing unit across two settings.

This module exposes only the boundary required by Neutral Substrate.
It does not provide the substantive persistence theory that determines which
criteria, stages, settings, paths, or histories are scientifically warranted.

In particular, this interface does not identify persistence with:

- temporal proximity;
- continuity alone;
- transformation;
- provenance;
- succession;
- carrier equality;
- individuation;
- co-reference.

No path quantifier, route semantics, stage-membership relation,
existence-at-setting relation, equivalence-relation laws, decidability,
finiteness, enumeration, or computational representation is assumed here.
-/

set_option autoImplicit false

namespace SE.Substrate

open SE.Referent

universe u

public section

-- RR.DEFINES: SE.Substrate.PersistenceAccount
/--
A persistence account for one referent kind.

The account itself represents the governing persistence criterion.

`Setting` supplies the settings between which persistence may be evaluated.
`Stage` supplies the eligible whole-stage candidates to which a persistence
judgment may apply.

The `Referent` parameter records the referent kind governed by this account.
No generic stage-to-referent membership relation is introduced here.
-/
structure PersistenceAccount
    (Referent : Type u) where

  /--
  Settings relevant to persistence judgments.
  -/
  Setting : Type u

  /--
  Candidate stages relevant to persistence judgments.
  -/
  Stage : Type u

  /--
  Whether a candidate stage is eligible for persistence evaluation at the
  selected setting.

  Eligibility is distinct from a positive persistence judgment.
  -/
  eligibleStage :
    Setting →
    Stage →
    Prop

  /--
  Whether two eligible stages stand in strict persistence across the
  selected settings.

  This is a diachronic-identity judgment. It is not merely continuity,
  provenance, succession, or transformation.
  -/
  persists :
    Setting →
    Setting →
    Stage →
    Stage →
    Prop

-- RR.DEFINES: SE.Substrate.PersistenceRegime
/--
The persistence accounts for the three referent kinds distinguished by
Structural Explainability.

Each referent kind has its own persistence account. The substantive
persistence theory governing those accounts remains external to this
interface.
-/
structure PersistenceRegime
    (R : ReferentCarriers.{u}) where

  /--
  Persistence account for entities.
  -/
  entity :
    PersistenceAccount R.Entity

  /--
  Persistence account for occurrences.
  -/
  occurrence :
    PersistenceAccount R.Occurrence

  /--
  Persistence account for institutional artifacts.
  -/
  institutionalArtifact :
    PersistenceAccount R.InstitutionalArtifact

end

end SE.Substrate
