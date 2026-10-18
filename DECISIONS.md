# Design Decisions

This file records design rationale.
Lean source defines the formal semantics;
`reference/` declares public-surface classification and traceability.
This file does not introduce additional assumptions or requirements.

## Object Language and Metalanguage

Object-language propositions use an arbitrary carrier.
Entailment judgments are Lean propositions about that carrier.

Object-language negation and contradiction remain distinct from Lean `Not`
and `False`.
This preserves the distinction among an asserted proposition,
its negation, an attribution of it, and an entailment judgment about it.

The shared language does not require finite enumeration, decidable equality,
or decidable entailment.

## Commitment Theories and Consequence

Commitment theories are sets of object-language propositions.
Combination and adjoining use ordinary set operations.

Consequence remains abstract.
Its structural laws are stated in Lean;
additional logical principles require explicit assumptions.

Consistency is defined through non-entailment of contradiction.
It is not built into every commitment theory, since inconsistent theories
must remain representable.

Generalized cut supports reasoning about arbitrary collections of entailed
commitments without assuming finite enumeration.

## Frameworks and Admissibility

Candidate frameworks remain distinct from their commitment theories.
Grounding and documentation are represented separately from commitments.

Admissibility is a predicate on candidates rather than a property made true
by the carrier's construction.
Its abstract grounding and documentation predicates
require justification in concrete realizations.

No identification with other theories' frame or
interpretation structures is implicit.

## Referential Interfaces

A referential regime composes distinct individuation, co-reference, and
persistence accounts.

- Individuation distinguishes candidate presentations, admissibility,
  singular unity, and same-unit identity.
- Co-reference concerns references to the same referent.
- Persistence concerns strict diachronic identity across settings.

The interfaces do not identify these judgments with carrier equality,
identifier equality, observational agreement, provenance, or succession.

Supplying the interfaces does not establish substantive criteria or
compatibility among the accounts.
Those require explicit constructions and justified semantic connections.

## Attribution and Aboutness

Establishing that a source asserts a proposition does not establish the
asserted proposition.

A concrete attributional basis must justify the attribution;
identifiers, records, and provenance do not establish
that basis merely by being present.

Aboutness/classification does not itself establish
denotation, co-reference, same-unit identity, persistence,
or referential fixing.

## Proof Boundaries

Under Referential Common Ground, foundational restriction is proved
sufficient for extension stability and neutrality.

That result does not establish neutrality by design,
which additionally requires a permitted design-time guarantee basis.

The full `NeutralityConstraint` is an explicit condition on realizations.
Theorems assuming that condition must not be described as independently
deriving it from the minimal interfaces.

## Access to Definitions

Definitions needed across module boundaries must provide an explicit access
path through an exposed body or a controlled theorem API.

Use `@[expose]` where unfolding is intended.
Otherwise provide appropriate characterization,
introduction, or elimination lemmas.

Public imports and definition exposure serve different purposes:
public imports provide access to declarations;
exposure supports unfolding.
