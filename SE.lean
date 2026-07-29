/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module -- shake: keep-all

public import SE.Logic.Language.Basic

public import SE.Logic.Theory.CommitmentTheory
public import SE.Logic.Theory.TheoryExtension

public import SE.Logic.Consequence
public import SE.Logic.Consistency

public import SE.Framework.Basic
public import SE.Framework.Admissible
public import SE.Framework.Class

public import SE.Referent.Carriers

public import SE.Substrate.ReferentialRegime
public import SE.Substrate.Basic
public import SE.Substrate.Commitment
public import SE.Substrate.ReferentialCommitments

public import SE.NeutralSubstrate.Classification.CausalNormative
public import SE.NeutralSubstrate.Classification.ContestedCausalOrNormative

public import SE.NeutralSubstrate.Attribution.Basic
public import SE.NeutralSubstrate.Attribution.Permitted
public import SE.NeutralSubstrate.Attribution.CommonGround

public import SE.NeutralSubstrate.Interpretation.ObjectLevelProposition
public import SE.NeutralSubstrate.Interpretation.ObjectLevelCausalOrNormativeCommitment

public import SE.NeutralSubstrate.FrameworkRelative.Variant
public import SE.NeutralSubstrate.FrameworkRelative.Invariant
public import SE.NeutralSubstrate.FrameworkRelative.CompatibleCommitmentSet

public import SE.NeutralSubstrate.DesignTimeGuarantee

public import SE.NeutralSubstrate.Assumptions.Contestability
public import SE.NeutralSubstrate.Assumptions.ReferentialCommonGround
public import SE.NeutralSubstrate.Assumptions.SubstrateConsistency

public import SE.NeutralSubstrate.Neutrality.InterpretiveNonCommitment
public import SE.NeutralSubstrate.Neutrality.ExtensionStability
public import SE.NeutralSubstrate.Neutrality.PropertyRelation
public import SE.NeutralSubstrate.Neutrality.ByDesign

public import SE.NeutralSubstrate.Constraint
public import SE.NeutralSubstrate.Examples.ReificationFragment
public import SE.NeutralSubstrate.Spec

/-!
# Structural Explainability

Root module for the Structural Explainability Neutral Substrate theory.
-/
