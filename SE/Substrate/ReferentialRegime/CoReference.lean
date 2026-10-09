module

public import SE.Referent.Carriers

/-!
**# Co-Reference**

This module defines the abstract co-reference interface used by a
referential regime.

Co-reference concerns whether two references are treated as referring to
the same referent.

This interface intentionally does not define a denotation relation between
references and referent-carrier elements. The denotation and co-reference
lifting problem remains a separate semantic boundary.

In particular, this module does not identify co-reference with:

- reference equality;
- referent-carrier equality;
- individuation or `sameUnit`;
- persistence.

No reflexivity, symmetry, transitivity, decidability, finiteness,
enumeration, or computational representation is assumed here.
-/

set_option autoImplicit false

namespace SE.Substrate

open SE.Referent

universe u

public section

-- RR.DEFINES: SE.Substrate.CoReferenceAccount
/--
A co-reference account for one referent kind.

The `Referent` parameter records the referent kind governed by the account.
No generic denotation relation from `Reference` to `Referent` is introduced
here.

Concrete theories may later supply such a bridge without changing the
meaning of co-reference itself.
-/
structure CoReferenceAccount
    (Referent : Type u) where

  /--
  The circumstances in which co-reference is evaluated.
  -/
  Context : Type u

  /--
  References eligible for co-reference judgments under this account.
  -/
  Reference : Type u

  /--
  Whether two references co-refer under the selected context.

  This relation is distinct from reference equality, referent-carrier
  equality, individuation, and persistence.
  -/
  coReference :
    Context →
    Reference →
    Reference →
    Prop

-- RR.DEFINES: SE.Substrate.CoReferenceRegime
/--
The co-reference accounts for the three referent kinds distinguished by
Structural Explainability.

The association with each referent carrier records the kind of referent to
which the corresponding references are directed. No generic reference-to-
referent denotation relation is imposed here.
-/
structure CoReferenceRegime
    (R : ReferentCarriers.{u}) where

  /--
  Co-reference account for references to entities.
  -/
  entity :
    CoReferenceAccount R.Entity

  /--
  Co-reference account for references to occurrences.
  -/
  occurrence :
    CoReferenceAccount R.Occurrence

  /--
  Co-reference account for references to institutional artifacts.
  -/
  institutionalArtifact :
    CoReferenceAccount R.InstitutionalArtifact

end

end SE.Substrate
