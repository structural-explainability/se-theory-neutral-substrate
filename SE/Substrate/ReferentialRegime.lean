module

public import SE.Referent.Carriers

public import SE.Substrate.ReferentialRegime.CoReference
public import SE.Substrate.ReferentialRegime.Individuation
public import SE.Substrate.ReferentialRegime.Persistence


/-!
# Referential Regime

This module formalizes:

- `se100.def.ReferentialRegime` - Referential Regime

A referential regime composes the distinct semantic accounts by which a
substrate individuates referents, relates references by co-reference, and
tracks persistence.

Individuation, co-reference, and persistence are intentionally represented
by different interfaces.
They are not assumed to have the same semantic structure.

The component interfaces remain abstract.
In particular, this module does not identify carrier equality
with individuation, co-reference, or persistence,
and it does not supply the substantive theories deferred to
later layers.
-/

set_option autoImplicit false

namespace SE.Substrate

open SE.Referent

universe u

public section

-- RR.DEFINES: SE.Substrate.ReferentialRegime
-- RR.IMPLEMENTS: se100.def.ReferentialRegime
/--
The referential regime by which a substrate individuates referents, relates
references by co-reference, and tracks persistence.

The three components have distinct semantic roles and interfaces.
-/
structure ReferentialRegime
    (R : ReferentCarriers.{u}) where

  /--
  The individuation semantics for the referent carriers.
  -/
  individuation :
    IndividuationRegime R

  /--
  The co-reference semantics associated with the referent carriers.
  -/
  coReference :
    CoReferenceRegime R

  /--
  The persistence semantics associated with the referent carriers.
  -/
  persistence :
    PersistenceRegime R

end

end SE.Substrate
