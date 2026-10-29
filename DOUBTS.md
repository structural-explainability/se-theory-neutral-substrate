# Research Doubts and Open Questions

This document records known
limitations, unresolved questions, and potential weaknesses
in the repository theory.

A doubt is not necessarily an error.
It's a question worth keeping visible so
we don't claim more than the evidence supports.

Some doubts can be resolved through mathematical proof.
Others require scientific examples, comparisons with existing work, or
better explanations of what the results mean.

The objective is to distinguish what we have established
from what remains to be demonstrated.

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

**None currently identified.**

A model that violates a required assumption does not
necessarily refute a conditional theorem.

If a counterexample is found,
we must identify the exact claim it challenges and
whether its assumptions are satisfied.

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

## Guide

State what is proved,
what is supported by evidence, and
what remains uncertain.
A known limitation is not a failure when accurately identified and respected.

## Research Criteria

We evaluate Structural Explainability research against three criteria.

| Criterion                       | Asks                                                                                                     |
| ------------------------------- | -------------------------------------------------------------------------------------------------------- |
| **1. Mathematical Correctness** | Are definitions precise, assumptions explicit, and claimed mathematical results correctly proved?        |
| **2. Scientific Adequacy**      | Do definitions, assumptions, and models meaningfully represent the phenomena we intend to study?         |
| **3. Theoretical Contribution** | Does the work establish something new and significant, beyond restating assumptions or existing results? |

These criteria are related, and satisfying one does not establish the others.

### Criteria 1. Mathematical Correctness

Lean checks whether a formal theorem follows from
its stated assumptions and the underlying logical rules.
It can also establish that assumptions are jointly satisfiable
by verifying a model in which they all hold.

However, a Lean proof does not automatically establish
that its assumptions describe a real system or that
the theorem's informal explanation is accurate.

Mathematical correctness requires **correct formal definitions and proofs**,
**with assumptions and dependencies made explicit**.

### Criteria 2. Scientific Adequacy

A mathematically correct theory may still be
**inadequate for its intended applications**.
For example, an assumption might be satisfiable in a small formal model
but difficult to justify for actual public records or competing identity criteria.

Scientific adequacy requires clear connections
between formal concepts and the phenomena they represent,
supported by appropriate examples, evidence, or explicit limitations.

### Criteria 3. Theoretical Contribution

Correct mathematics and plausible models are not enough
to establish a substantive theoretical contribution.
The theory should **help with understanding** that was previously
unclear, unresolved, or insufficiently characterized.

Theoretical contribution requires an identifiable contribution,
appropriately situated relative to prior work,
with claims proportionate to the established results.
A contribution may be small, conditional, or limited in scope.

## Contributors

A doubt should be recorded when we identify a specific reason
that a research claim could be incorrect, inapplicable, insufficiently supported, or misunderstood.

### Status Values

| Status             | Meaning                                                                    |
| ------------------ | -------------------------------------------------------------------------- |
| **Open**           | A substantive question remains unanswered.                                 |
| **Open, check**    | An existing result may address the question, but has not been verified.    |
| **Resolved**       | The specific concern has been answered; the entry identifies the evidence. |
| **Standing rules** | Continuing safeguards against misinterpretation or overclaiming.           |

Resolving a doubt does not necessarily resolve every related scientific question.

### Recording a New Doubt

1. Identify the specific concern and the research criterion it affects.
2. Classify it as undermining, rebutting, or undercutting.
3. Assign the next available ID: `UM`, `RB`, or `UC`.
4. State the concern in ordinary language.
5. Explain what the current theory, evidence, or implementation establishes.
6. Identify what remains unresolved, or the documentation rule that prevents misinterpretation.

Preserve existing IDs so that references remain stable.

### Resolving a Doubt

When a concern is resolved:

- Change its status to `Resolved`.
- Explain exactly what established the resolution.
- Link or name the relevant theorem, model, experiment, or other evidence.
- Retain important scope limitations.

If a previously resolved doubt is reopened by new evidence, document why.

### Relationship to Other Repository Files

- **Lean source:** Formal definitions, assumptions, and mathematical proofs.
- **`reference/`:** Registered formal results and traceability information.
- **`DECISIONS.md`:** Design rationale, methodological choices, and proof boundaries.
- **`DOUBTS.md`:** Unresolved scientific questions, potential weaknesses, and safeguards against overclaiming.

## Terminology

The doubt categories come from argumentation theory:

- **Undermining:** Challenges a premise.
- **Rebutting:** Challenges a conclusion.
- **Undercutting:** Challenges the support connecting premises, results, and claims.

## References

See also:

- [Research vocabulary](docs/en/vocab.md)
- [Design decisions](DECISIONS.md)
- Prakken (2010), [An abstract framework for argumentation with structured arguments](https://doi.org/10.1080/19462160903564592)
- Pollock (1987), [Defeasible reasoning](https://doi.org/10.1207/s15516709cog1104_4)
- [Defeasible Reasoning](https://plato.stanford.edu/entries/reasoning-defeasible/), Stanford Encyclopedia of Philosophy
