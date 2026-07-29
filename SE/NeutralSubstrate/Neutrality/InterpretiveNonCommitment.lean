/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.NeutralSubstrate.FrameworkRelative.Variant
public import SE.Substrate.Commitment

/-!
# Interpretive Non-Commitment

This module formalizes:

- `se100.def.InterpretiveNonCommitment` —
  Interpretive Non-Commitment

A substrate satisfies interpretive non-commitment when it makes no
substrate-layer commitment to either side of a framework-variant
proposition.

For every proposition `p` that is framework-variant with respect to the
substrate and framework class, the substrate entails neither `p` nor its
object-language negation `¬p`.

The definition uses this explicit two-sided condition directly. It does not
assume that the object-language negation of every framework-variant
proposition is itself framework-variant, because the abstract language does
not impose a double-negation law.

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
A substrate satisfies interpretive non-commitment when every
framework-variant proposition is absent from the substrate's commitments in
both its positive and object-language-negated forms.

This formalizes the paper's condition:

`S ⊬ p` and `S ⊬ ¬p`

whenever `p` is framework-variant with respect to `S` and the framework
class.
-/
def InterpretiveNonCommitment
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    (C : ConsequenceSystem L)
    (S : SubstrateSystem.{u, v, w} L R)
    (s : S.Carrier)
    (M : FrameworkSystem.{u, x} L.carrier) :
    Prop :=
  ∀ p,
    FrameworkVariantProposition C S s M p →
      ¬ SubstrateCommitment C S s p ∧
        ¬ SubstrateCommitment C S s (L.neg p)

/--
A substrate satisfies interpretive non-commitment exactly when it commits to
neither a framework-variant proposition nor its object-language negation.
-/
@[simp]
theorem interpretiveNonCommitment_iff
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier} :
    InterpretiveNonCommitment C S s M ↔
      ∀ p,
        FrameworkVariantProposition C S s M p →
          ¬ SubstrateCommitment C S s p ∧
            ¬ SubstrateCommitment C S s (L.neg p) :=
  Iff.rfl

/--
A substrate satisfying interpretive non-commitment does not commit to a
framework-variant proposition.
-/
theorem not_substrateCommitment_of_interpretiveNonCommitment
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    (hnonCommitment : InterpretiveNonCommitment C S s M)
    {p : L.Proposition}
    (hvariant : FrameworkVariantProposition C S s M p) :
    ¬ SubstrateCommitment C S s p :=
  (hnonCommitment p hvariant).1

/--
A substrate satisfying interpretive non-commitment does not commit to the
object-language negation of a framework-variant proposition.
-/
theorem not_negSubstrateCommitment_of_interpretiveNonCommitment
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    (hnonCommitment : InterpretiveNonCommitment C S s M)
    {p : L.Proposition}
    (hvariant : FrameworkVariantProposition C S s M p) :
    ¬ SubstrateCommitment C S s (L.neg p) :=
  (hnonCommitment p hvariant).2

/--
Interpretive non-commitment supplies both non-commitment conclusions for a
framework-variant proposition.
-/
theorem no_commitment_pair_of_interpretiveNonCommitment
    {L : PropositionalLanguage.{u}}
    {R : ReferentCarriers.{v}}
    {C : ConsequenceSystem L}
    {S : SubstrateSystem.{u, v, w} L R}
    {s : S.Carrier}
    {M : FrameworkSystem.{u, x} L.carrier}
    (hnonCommitment : InterpretiveNonCommitment C S s M)
    {p : L.Proposition}
    (hvariant : FrameworkVariantProposition C S s M p) :
    ¬ SubstrateCommitment C S s p ∧
      ¬ SubstrateCommitment C S s (L.neg p) :=
  hnonCommitment p hvariant

end

end SE.NeutralSubstrate.Neutrality
