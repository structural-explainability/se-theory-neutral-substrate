/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Consistency
public import SE.NeutralSubstrate.FrameworkRelative.Variant

/-!
# Extension Stability

This module formalizes:

- `se100.def.ExtensionStability` — Extension Stability

A substrate satisfies extension stability when its commitments remain
consistent with the commitments of every admissible framework.

For every admissible framework `F`, the combined commitment theory satisfies:

`S ∪ F ⊬ ⊥`.

Here, extension refers to combining a substrate with a framework. It does not
refer to changing or enlarging the intrinsic framework class.

No decidability, finiteness, enumeration, or effective search procedure for
the framework class is assumed.
-/

set_option autoImplicit false

namespace SE.NeutralSubstrate.Neutrality

open SE.Framework
open SE.Logic
open SE.Logic.Language
open SE.NeutralSubstrate.FrameworkRelative
open SE.Referent
open SE.Substrate

universe u v w x

public section

/--
A substrate satisfies extension stability when its combined commitment
theory with every admissible framework remains consistent.

This formalizes the paper's condition:

`S ∪ F ⊬ ⊥`

for every admissible framework `F`.
-/
def ExtensionStability
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (S : SubstrateSystem.{u, v, w} L R)
    (s : S.Carrier)
    (M : FrameworkSystem.{u, x} L.carrier) :
    Prop :=
  ∀ framework,
    framework ∈ FrameworkClass C M →
      Consistent C
        (SubstrateFrameworkCommitments S s M framework)

/--
A substrate satisfies extension stability exactly when every admissible
substrate-framework commitment theory remains consistent.
-/
@[simp]
theorem extensionStability_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier} :
    ExtensionStability C S s M ↔
      ∀ framework,
        framework ∈ FrameworkClass C M →
          Consistent C
            (SubstrateFrameworkCommitments S s M framework) :=
  Iff.rfl

/--
Extension stability supplies consistency for the substrate combined with any
selected admissible framework.
-/
theorem consistent_substrateFrameworkCommitments_of_extensionStability
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    (hstability : ExtensionStability C S s M)
    {framework : M.Carrier}
    (hframework : framework ∈ FrameworkClass C M) :
    Consistent C
      (SubstrateFrameworkCommitments S s M framework) :=
  hstability framework hframework

end

end SE.NeutralSubstrate.Neutrality
