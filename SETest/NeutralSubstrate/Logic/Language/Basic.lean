/-
Copyright (c) 2026 Denise M. Case.
Released under MIT license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

import SE.Logic.Language.Basic

/-!
# Propositional Language Tests

Compile-time API and theorem-application tests for
`SE.Logic.Language.Basic`.
-/

set_option autoImplicit false

namespace SETest.NeutralSubstrate.Logic.Language.Basic

#check SE.Logic.Language.PropositionCarrier
#check SE.Logic.Language.Negation
#check SE.Logic.Language.Bottom
#check SE.Logic.Language.PropositionalLanguage
#check SE.Logic.Language.PropositionalLanguage.Proposition
#check SE.Logic.Language.PropositionalLanguage.neg
#check SE.Logic.Language.PropositionalLanguage.bottom

end SETest.NeutralSubstrate.Logic.Language.Basic
