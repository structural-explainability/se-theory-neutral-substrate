/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

-- SE/NeutralSubstrate/Spec.lean
-- Canonical citation identifiers for the Neutral Substrate theory.
-- Strings are stable across refactors; the identifier is the contract,
-- and the corresponding Lean declaration is the implementation.

@[expose] public section

namespace SE.NeutralSubstrate.Spec

/-- Paper item 01: substrate. -/
def se100DefSubstrate : String :=
  "se100.def.Substrate"

/-- Paper item 02: substrate commitment. -/
def se100DefSubstrateCommitment : String :=
  "se100.def.SubstrateCommitment"

/-- Paper item 03: causal or normative classification. -/
def se100NoteCausalNormative : String :=
  "se100.note.CausalNormative"

/-- Paper item 04: attribution proposition. -/
def se100DefAttributionProposition : String :=
  "se100.def.AttributionProposition"

/-- Paper item 05: object-level interpretive proposition. -/
def se100DefObjectLevelInterpretiveProposition : String :=
  "se100.def.ObjectLevelInterpretiveProposition"

/-- Paper item 06: object-level causal or normative commitment. -/
def se100DefObjectLevelCausalNormativeCommitment : String :=
  "se100.def.ObjectLevelCausalNormativeCommitment"

/-- Paper item 07: referential regime. -/
def se100DefReferentialRegime : String :=
  "se100.def.ReferentialRegime"

/-- Paper item 08: referential commitments. -/
def se100DefReferentialCommitments : String :=
  "se100.def.ReferentialCommitments"

/-- Paper item 09: admissible framework. -/
def se100DefAdmissibleFramework : String :=
  "se100.def.AdmissibleFramework"

/-- Paper item 10: framework class. -/
def se100NoteFrameworkClass : String :=
  "se100.note.FrameworkClass"

/-- Paper item 11: permitted attribution proposition. -/
def se100DefPermittedAttributionProposition : String :=
  "se100.def.PermittedAttributionProposition"

/-- Paper item 12: framework-variant proposition. -/
def se100DefFrameworkVariant : String :=
  "se100.def.FrameworkVariant"

/-- Paper item 13: framework-invariant proposition. -/
def se100DefFrameworkInvariant : String :=
  "se100.def.FrameworkInvariant"

/-- Paper item 14: framework-compatible commitment set. -/
def se100DefFrameworkCompatibleCommitmentSet : String :=
  "se100.def.FrameworkCompatibleCommitmentSet"

/-- Paper item 15: contested causal or normative proposition. -/
def se100DefContestedCausalNormative : String :=
  "se100.def.ContestedCausalNormative"

/-- Paper item 16: contestability assumption. -/
def se100AssumpContestability : String :=
  "se100.assump.Contestability"

/-- Paper item 17: referential common-ground assumption. -/
def se100AssumpReferentialCommonGround : String :=
  "se100.assump.ReferentialCommonGround"

/-- Paper item 18: attribution and common ground. -/
def se100RemarkAttributionCommonGround : String :=
  "se100.remark.AttributionCommonGround"

/-- Paper item 19: interpretive non-commitment. -/
def se100DefInterpretiveNonCommitment : String :=
  "se100.def.InterpretiveNonCommitment"

/-- Paper item 20: extension stability. -/
def se100DefExtensionStability : String :=
  "se100.def.ExtensionStability"

/-- Paper item 21: substrate-consistency assumption. -/
def se100AssumpSubstrateConsistency : String :=
  "se100.assump.SubstrateConsistency"

/-- Paper item 22: relation between the two neutrality properties. -/
def se100RemarkPropertyRelation : String :=
  "se100.remark.PropertyRelation"

/-- Paper item 23: neutrality by design. -/
def se100DefNeutralityByDesign : String :=
  "se100.def.NeutralityByDesign"

/-- Paper item 24: neutrality constraint. -/
def se100ConstraintNeutrality : String :=
  "se100.constraint.Neutrality"

/-- Paper item 25: reification fragment. -/
def se100ExampleReificationFragment : String :=
  "se100.example.ReificationFragment"

end SE.NeutralSubstrate.Spec
