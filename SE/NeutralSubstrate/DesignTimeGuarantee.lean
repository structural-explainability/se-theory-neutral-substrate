/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

/-!
# Design-Time Guarantees

This module provides the abstract design-time guarantee interface used by:

- `se100.assump.Contestability` — Contestability
- `se100.def.NeutralityByDesign` — Neutrality by Design
- `se100.constraint.Neutrality` — Neutrality

A design-time guarantee is not merely the truth of a proposition.

It records that the proposition is established from a permitted design-time
basis. This distinction preserves the paper's requirement that neutrality
follow from membership in the permitted foundational classes rather than
from enumerating the admissible frameworks known when the substrate is
designed.

The meaning of a design-time basis and the relation by which such a basis
establishes a claim remain abstract. No proof calculus, decision procedure,
finiteness condition, enumeration method, or temporal logic is imposed.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate

universe u

public section

/--
An abstract system of design-time guarantees.

A guarantee system specifies:

- the available kinds of design-time basis;
- which bases are permitted;
- which propositions each basis establishes; and
- soundness of the establishment relation.

The permitted-basis condition represents the paper's restriction on how a
design-time guarantee may be obtained. In particular, later modules may
restrict permitted bases to referential commitments and permitted
attribution propositions rather than framework enumeration.
-/
structure DesignTimeGuaranteeSystem where

  /--
  The carrier of possible design-time bases.
  -/
  Basis : Type u

  /--
  Whether a basis is permitted as a source of a design-time guarantee.
  -/
  permitted : Basis → Prop

  /--
  Whether a basis establishes a proposition at design time.
  -/
  establishes : Basis → Prop → Prop

  /--
  Every proposition established by a permitted design-time basis holds.
  -/
  sound :
    ∀ {basis : Basis} {P : Prop},
      permitted basis →
      establishes basis P →
      P

/--
A proposition is guaranteed at design time when some permitted design-time
basis establishes it.

This definition retains the basis of the guarantee rather than identifying a
design-time guarantee with the proposition alone.
-/
def GuaranteedAtDesignTime
    (G : DesignTimeGuaranteeSystem.{u})
    (P : Prop) :
    Prop :=
  ∃ basis,
    G.permitted basis ∧
      G.establishes basis P

/--
A proposition is guaranteed at design time exactly when it is established by
some permitted design-time basis.
-/
@[simp]
theorem guaranteedAtDesignTime_iff
    {G : DesignTimeGuaranteeSystem.{u}}
    {P : Prop} :
    GuaranteedAtDesignTime G P ↔
      ∃ basis,
        G.permitted basis ∧
          G.establishes basis P :=
  Iff.rfl

/--
Every proposition guaranteed at design time holds.
-/
theorem holds_of_guaranteedAtDesignTime
    {G : DesignTimeGuaranteeSystem.{u}}
    {P : Prop}
    (hP : GuaranteedAtDesignTime G P) :
    P := by
  rcases hP with ⟨basis, hpermitted, hestablishes⟩
  exact G.sound hpermitted hestablishes

/--
A permitted basis that establishes a proposition supplies a design-time
guarantee for that proposition.
-/
theorem guaranteedAtDesignTime_of_establishes
    {G : DesignTimeGuaranteeSystem.{u}}
    {basis : G.Basis}
    {P : Prop}
    (hpermitted : G.permitted basis)
    (hestablishes : G.establishes basis P) :
    GuaranteedAtDesignTime G P :=
  ⟨basis, hpermitted, hestablishes⟩

/--
Every design-time guarantee has a permitted basis that establishes its
claim.
-/
theorem exists_permittedBasis_of_guaranteedAtDesignTime
    {G : DesignTimeGuaranteeSystem.{u}}
    {P : Prop}
    (hP : GuaranteedAtDesignTime G P) :
    ∃ basis,
      G.permitted basis ∧
        G.establishes basis P :=
  hP

end

end SE.NeutralSubstrate
