# DOUBTS.md

This file lists known ways repository results could be wrong or misread.
Lean cannot check that assumptions hold together, or that a theorem says what the prose claims.
Those kinds of doubts are recorded here.
Each entry raises a question about the argument.

<!-- markdownlint-disable MD024 -->

---

## A. Undermining Doubts

### UM-001 se100.assump.ReferentialCommonGround (Open)

#### Doubt

If a concrete realization cannot establish `ReferentialCommonGround`,
which quantifies over the whole admissible framework class with no enumeration,
then the conditional theorems that assume it do not apply to that realization.

#### Today

Not dischargeable in general.
Bounded fragment: se-theory-common-ground (SE-110)
[DECISIONS.md](DECISIONS.md#joint-compatibility-of-referential-commitments)
lists the corresponding obligation for concrete realizations as unresolved.

### UM-002 RCG and Contestability together (Open, check)

#### Doubt

If no model satisfies both assumptions,
then the main theorem holds vacuously.

#### Today

Models prove neutral and non-neutral substrates are separated.
No theorem naming both assumptions has been found, though one may exist implicitly.

---

## B. Rebutting Doubts

None identified.

---

## C. Undercutting Doubts

### UC-001 CharacterizationHypothesis (Standing rule)

#### Doubt

If a result that assumes `CharacterizationHypothesis` is described
as deriving it from the minimal interfaces,
then the result is misread,
because the hypothesis is an explicit condition on realizations.

#### Today

A wording rule in the [DECISIONS.md](DECISIONS.md) Proof Boundaries section.

### UC-002 Neutrality by design (Standing rule)

#### Doubt

If the foundational-restriction result is described as establishing neutrality by design,
then the result is misread,
because neutrality by design additionally requires a permitted design-time guarantee basis.

#### Today

The same Proof Boundaries section states the limit:
the result gives extension stability and neutrality, not neutrality by design.

---

<!-- markdownlint-enable MD024 -->

## Allowable Status Values

- **Open**: the doubt stands. Nothing fully discharges it.
- **Open, check**: something in the repository may already handle it. The next step is to verify.
- **Standing rule**: it cannot be closed by proof. A rule keeps it in check and must keep being followed.
- **Resolved**: closed. `Today` names the declaration or rule that closes it.

## How To Add Entry

To add an entry:

1. Choose the kind (see Kinds of doubt) and take the next ID for it.
2. Under that kind, add a heading with the ID, the subject, and the status in parentheses.
3. The subject is the Lean declaration or concept.
4. Status is part of the heading.
5. Add Doubt as one sentence stating what would be wrong, written as a condition.
6. Add Today with what exists now, such as a declaration, a sibling repository, or a documentation rule.

## How To Close Entry

To close an entry,
change the status in its heading to Resolved and
make **Handled today** name the declaration or rule that closes it.

## Doubt Kinds

Every doubt attacks one of three parts of an argument:

1. a premise,
2. the conclusion, or
3. the link between them.

The names come from argumentation theory.

### Undermining

- **Attacks:** a premise, meaning an assumption or hypothesis a result depends on.
- **Asks:** can it be established? Can the assumptions hold together, or does the theorem hold vacuously?
- **Typically closed by:** showing the assumption for a concrete case, exhibiting a model that satisfies the assumptions together, or restricting the assumption.

### Rebutting

- **Attacks:** the conclusion.
- **Asks:** is the claimed conclusion false?
- **Typically closed by:** a proof of the claim, or correcting or withdrawing it.

### Undercutting

- **Attacks:** the link between the formal result and the claim made for it.
- **Asks:** does the theorem show what is said it shows?
- **Typically closed by:** fixing the wording, scoping the claim to what is proved, or a standing rule.

## Reference

- Terms used here: [docs/en/vocab.md](docs/en/vocab.md)
- Proof boundaries and wording rules: [DECISIONS.md](DECISIONS.md)
- Prakken (2010), [An abstract framework for argumentation with structured arguments](https://doi.org/10.1080/19462160903564592): names undermining, rebutting and undercutting
- Pollock (1987), [Defeasible reasoning](https://doi.org/10.1207/s15516709cog1104_4): rebutting versus undercutting defeaters
- [Defeasible Reasoning](https://plato.stanford.edu/entries/reasoning-defeasible/), Stanford Encyclopedia of Philosophy: background reading
