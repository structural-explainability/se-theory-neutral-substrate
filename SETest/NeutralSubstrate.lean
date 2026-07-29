/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module -- shake: keep-all

import SETest.NeutralSubstrate.Logic.Language.Basic
import SETest.NeutralSubstrate.Logic.Theory.CommitmentTheory
import SETest.NeutralSubstrate.Logic.Theory.TheoryExtension
import SETest.NeutralSubstrate.Logic.Consequence
import SETest.NeutralSubstrate.Logic.Consistency
import SETest.NeutralSubstrate.Framework.Basic
import SETest.NeutralSubstrate.Framework.Admissible
import SETest.NeutralSubstrate.Framework.Class
import SETest.NeutralSubstrate.Referent.Carriers
import SETest.NeutralSubstrate.Substrate.ReferentialRegime
import SETest.NeutralSubstrate.Substrate.Basic
import SETest.NeutralSubstrate.Substrate.Commitment
import SETest.NeutralSubstrate.Substrate.ReferentialCommitments
import SETest.NeutralSubstrate.Classification.CausalNormative
import SETest.NeutralSubstrate.Classification.ContestedCausalOrNormative
import SETest.NeutralSubstrate.Attribution.Basic
import SETest.NeutralSubstrate.Attribution.Permitted
import SETest.NeutralSubstrate.Attribution.CommonGround
import SETest.NeutralSubstrate.Interpretation.ObjectLevelProposition
import SETest.NeutralSubstrate.Interpretation.ObjectLevelCausalOrNormativeCommitment
import SETest.NeutralSubstrate.FrameworkRelative.Variant
import SETest.NeutralSubstrate.FrameworkRelative.Invariant
import SETest.NeutralSubstrate.FrameworkRelative.CompatibleCommitmentSet
import SETest.NeutralSubstrate.DesignTimeGuarantee
import SETest.NeutralSubstrate.Assumptions.Contestability
import SETest.NeutralSubstrate.Assumptions.ReferentialCommonGround
import SETest.NeutralSubstrate.Assumptions.SubstrateConsistency
import SETest.NeutralSubstrate.Neutrality.InterpretiveNonCommitment
import SETest.NeutralSubstrate.Neutrality.ExtensionStability
import SETest.NeutralSubstrate.Neutrality.PropertyRelation
import SETest.NeutralSubstrate.Neutrality.ByDesign
import SETest.NeutralSubstrate.Constraint
import SETest.NeutralSubstrate.Spec

/-!
# Neutral Substrate Tests

Complete test-module inventory for the Structural Explainability Neutral
Substrate theory.
-/
