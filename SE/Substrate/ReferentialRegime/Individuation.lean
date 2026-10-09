module

public import SE.Referent.Carriers

/-!
**# Individuation**

This module defines the abstract individuation interface used by a
referential regime.

Individuation distinguishes:

- candidate presentations;
- admissible whole-directed presentations;
- successful singular presentation of one whole; and
- dyadic identity between successful presentations.

The distinction between `one` and `sameUnit` is intentional:

- `one` is a monadic unity judgment;
- `sameUnit` is a dyadic identity judgment.

Carrier equality is not identified with either judgment.

The account remains abstract. No decidability, finiteness, enumeration,
equivalence-relation laws, semantic-status representation, or computational
procedure is assumed here.
-/

set_option autoImplicit false

namespace SE.Substrate

open SE.Referent

universe u

public section

-- RR.DEFINES: SE.Substrate.IndividuationAccount
/--
An individuation account for one referent kind.

The account itself represents the governing individuation criterion.
`Context` supplies the circumstances under which that criterion is applied.

`Presentation` supplies candidate presentations from which successful
one-whole and same-unit judgments may be made.

`presents` relates a presentation to a referent-carrier element. No
totality, functionality, injectivity, surjectivity, or identity consequence
is assumed for this relation.
-/
structure IndividuationAccount
    (Referent : Type u) where

  /--
  The circumstances in which the individuation account is evaluated.
  -/
  Context : Type u

  /--
  Candidate presentations to which the individuation account may apply.
  -/
  Presentation : Type u

  /--
  Whether a candidate presentation presents a particular carrier element
  under the selected context.

  This relation does not identify presentation equality, carrier equality,
  or same-unit identity.
  -/
  presents :
    Context →
    Presentation →
    Referent →
    Prop

  /--
  Whether a candidate presentation is admissible as a whole-directed
  presentation under the selected context.

  Admissibility does not itself establish that the presentation succeeds
  in presenting one whole.
  -/
  admissiblePresentation :
    Context →
    Presentation →
    Prop

  /--
  Whether a candidate presentation succeeds as a singular presentation of
  one whole under the selected context.

  This is the monadic unity judgment.
  -/
  one :
    Context →
    Presentation →
    Prop

  /--
  Whether two candidate presentations count as presentations of the same
  individuated unit under the selected context.

  This is the dyadic identity judgment. No global equivalence-relation laws
  are imposed by this interface.
  -/
  sameUnit :
    Context →
    Presentation →
    Presentation →
    Prop

-- RR.DEFINES: SE.Substrate.IndividuationRegime
/--
The individuation accounts for the three referent kinds distinguished by
Structural Explainability.

Each referent kind has its own individuation account. No relationship among
the three accounts is assumed.
-/
structure IndividuationRegime
    (R : ReferentCarriers.{u}) where

  /--
  Individuation account for entities.
  -/
  entity :
    IndividuationAccount R.Entity

  /--
  Individuation account for occurrences.
  -/
  occurrence :
    IndividuationAccount R.Occurrence

  /--
  Individuation account for institutional artifacts.
  -/
  institutionalArtifact :
    IndividuationAccount R.InstitutionalArtifact

end

end SE.Substrate
