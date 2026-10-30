# Research Doubts and Open Questions

This document records the current research assessment,
known limitations, unresolved questions, and safeguards
against overclaiming for this theory.

For the three research criteria, doubt classifications,
status definitions, and procedures, see the
[SE Research Doubts Standard](https://raw.githubusercontent.com/structural-explainability/.github/refs/heads/main/docs/en/research/doubts.md).

## Repository Summary

This assessment is a summary of the present evidence.

| Criterion                | Current assessment                                                                                                                                                                         |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Mathematical Correctness | Formal results are established under stated hypotheses. Joint satisfiability has a bounded Lean witness.                                                                                   |
| Scientific Adequacy      | Partially established. The discriminating model demonstrates formal possibilities, but applicability to general concrete realizations remains open.                                        |
| Theoretical Contribution | The proposed contribution concerns neutrality constraints on shared records under interpretive disagreement. Its significance and relationship to prior work require continued evaluation. |

The doubts below identify specific issues affecting these assessments.

---

<!-- markdownlint-disable MD024 -->

## Register 1. Doubts About Assumptions (Undermining Doubts)

These questions concern the premises of an argument.
Even if a theorem is correctly proved, can we establish the assumptions necessary to apply it?

### UM-001. (OPEN) Referential Common Ground

#### Research criterion

Scientific Adequacy

#### Concern

`ReferentialCommonGround` requires the referential commitments to remain compatible with every admissible framework.

Can we establish this requirement for concrete systems, particularly when the admissible framework class is not finite or enumerated?

#### Current Knowledge

The theorem `referentialCommonGround_of_frameworkCompatibleCommitmentSet` reduces the formal obligation: compatibility of the referential commitments already implies the permitted-attribution condition.

The remaining compatibility requirement still ranges over the complete admissible framework class.

The discriminating model establishes Referential Common Ground for its two-framework realization.

The companion `se-theory-common-ground` (SE-110) investigates a bounded fragment.

#### Remaining Work

We need justified referential commitments and
a way to establish compatibility for the
admissible frameworks of a concrete realization.

This need not require enumeration;
a general proof based on appropriate properties may suffice.

The obligation is also recorded in [DECISIONS.md](DECISIONS.md#joint-compatibility-of-referential-commitments).

### UM-002. (RESOLVED) Joint Satisfiability of the Assumptions

#### Research criterion

Mathematical Correctness

#### Concern

What if Contestability, Referential Common Ground, and `CharacterizationHypothesis` cannot hold simultaneously?

If the assumptions were contradictory, a conditional theorem could be formally proved without having a model to which it applies.

#### Current Knowledge

The Lean declaration

`SETest.NeutralSubstrate.Model.Discriminating.Assumptions.assumptions_jointly_satisfiable`

establishes a model satisfying the assumptions together.

The declaration `neutralByDesign_iff_restricted_neutral` applies the constraint theorem to that model.

#### Resolution

We have a formal witness showing that the assumptions are jointly satisfiable.

The witness is limited to two frameworks and has no attribution sources.
It establishes the existence of a satisfactory model,
not the applicability of the assumptions to every real-world system.

The broader applicability question belongs to Scientific Adequacy.

### UM-003. (OPEN) Referential Fixing and Logical Consequences

#### Research criterion

Scientific Adequacy

#### Concern

Suppose the substrate entails a proposition that is
neither fixed by its referential regime nor a permitted attribution proposition.

In that case, the foundational layer is not restricted to the permitted classes.

Can a concrete realization justify how it classifies
all the propositions to which its substrate commits?

#### Current Knowledge

The `ReferentialFixing` interface does not impose closure under logical consequence.

In the discriminating model:

- `closureFixing` provides a closed construction for which the neutral substrate is restricted (`restricted_neutral`).
- The model's `literalFixing` fails the foundational restriction (`not_restricted_neutral_of_literalFixing`).

These examples demonstrate that the choice of referential fixing matters.

#### Remaining Work

A concrete realization must justify which propositions are legitimately referentially fixed.

Defining a fixing predicate that makes the restriction hold
is not sufficient scientific justification.

The corresponding obligation is also recorded in
[DECISIONS.md](DECISIONS.md#joint-compatibility-of-referential-commitments).

## Register 2. Doubts About Conclusions (Rebutting Doubts)

These questions concern whether a claimed conclusion is false.
For example, a counterexample satisfying all the premises
but violating the conclusion would challenge the claimed theorem or its formalization.
A model that violates a required assumption does not
necessarily refute a conditional theorem.
If a counterexample is found,
we must identify the exact claim it challenges and
whether its assumptions are satisfied.

**None currently identified.**

## Register 3. Doubts About What Our Results Mean (Undercutting Doubts)

These questions concern the connection
between a formal theorem and the scientific claim made about it.
A theorem may be correct while its informal interpretation is too strong.
Some of these doubts are addressed by permanent documentation
rules rather than additional proofs.

### UC-001. (STANDING RULES) Characterization Hypothesis

#### Research criterion

Scientific Adequacy

#### Concern

A reader might interpret the neutrality characterization
as something derived from the minimal interfaces.
But `CharacterizationHypothesis` is an explicit condition on a realization.

#### Current Knowledge

The associated equivalence theorems establish relationships
under their stated conditions.
They do not independently prove that
every realization satisfies `CharacterizationHypothesis`.

#### Standing Rules

1. Always identify the characterization hypothesis when describing results that depend on it.
2. Do not present conditional conclusions as unconditional consequences of the minimal interfaces.

This limitation is recorded in the Proof Boundaries section of
[DECISIONS.md](DECISIONS.md).

### UC-002. (STANDING RULES) Neutrality Versus Neutrality by Design

#### Research criterion

Scientific Adequacy

#### Concern

A reader might confuse establishing neutrality with establishing the stronger property of neutrality by design.

The latter includes a permitted design-time guarantee basis.

#### Current Knowledge

`neutral_of_restricted_of_commonGround` establishes neutrality under foundational restriction and Referential Common Ground.

It does not independently establish neutrality by design.

The separate theorem `neutralByDesign_iff_foundationalLayerRestricted` establishes a stronger conditional equivalence using `CharacterizationHypothesis`, Contestability, and Referential Common Ground.

#### Standing Rules

1. Distinguish semantic neutrality from neutrality by design.
2. State additional assumptions whenever claiming the stronger result.

The Proof Boundaries section of [DECISIONS.md](DECISIONS.md) records this distinction.

<!-- markdownlint-enable MD024 -->
