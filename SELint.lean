/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public meta import Batteries.Tactic.Lint
import Mathlib.Tactic.Linter.HashCommandLinter
import all SE.NeutralSubstrate

/-!
# Structural Explainability Lint Driver

Runs the Batteries environment linters
over declarations in this module hierarchy.
-/

namespace SELint

open Batteries.Tactic.Lint

/--
Run the documentation linter while ignoring compiler-generated
`ofNat_ctorIdx` declarations, which have no source declaration to document.
-/
@[env_linter disabled]
public meta def docBlameSource : Linter where
  test declName :=
    match declName with
    | .str _ "ofNat_ctorIdx" => pure none
    | _ => docBlame.test declName
  noErrorsFound := docBlame.noErrorsFound
  errorsFound := docBlame.errorsFound
  isFast := docBlame.isFast

end SELint

set_option linter.hashCommand false

#lint- only
  unusedArguments
  docBlameSource
  checkType
  synTaut
  unusedHavesSuffices
  impossibleInstance
  nonClassInstance
  simpNF
  simpComm
  in SE.IdentityRegimes

public def main : IO Unit :=
  pure ()
