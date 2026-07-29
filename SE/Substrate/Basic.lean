/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.Logic.Language.Basic
public import SE.Logic.Theory.CommitmentTheory
public import SE.Referent.Carriers
public import SE.Substrate.ReferentialRegime

/-!
# Substrate

This module formalizes:

- `se100.def.Substrate` — Substrate

A substrate is a shared representational base providing stable reference for
entities, occurrences, and institutional artifacts.

Stable reference is supplied by a referential regime consisting of
individuation, co-reference, and persistence conditions.

The commitment-theory projection supports the paper's subsequent definition
of substrate-layer commitment. No consistency, admissibility, neutrality,
extension-stability, finiteness, enumeration, or decidability condition is
built into the substrate interface.
-/

set_option autoImplicit false

namespace SE.Substrate

open SE.Logic.Language
open SE.Logic.Theory
open SE.Referent

universe u v w

public section

/--
An abstract interface for substrates over a propositional language and fixed
referent carriers.

Each substrate supplies:

- its substrate-layer commitment theory; and
- the referential regime by which it provides stable reference.

Compatibility with admissible frameworks is stated separately by later
framework-relative and neutrality properties.
-/
structure SubstrateSystem
    (L : PropositionalLanguage.{u})
    (R : ReferentCarriers.{v}) where

  /--
  The carrier of candidate substrates.
  -/
  Carrier : Type w

  /--
  The complete substrate-layer commitment theory associated with a substrate.
  -/
  commitments :
    Carrier →
    CommitmentTheory L.carrier

  /--
  The individuation, co-reference, and persistence conditions by which a
  substrate fixes and tracks its referents.
  -/
  referentialRegime :
    Carrier →
    ReferentialRegime R

end

end SE.Substrate
