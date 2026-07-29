# DECISIONS.md

## AUX-001 — Proposition Carrier

Use an arbitrary type: Proposition : Type u
Do not use Lean Prop.
The paper distinguishes: object-language proposition p
from:
the Lean proposition asserting that T entails p.
They must remain separate.
For example: `entails T p`
is a Lean proposition about an object-language proposition p.

If p : Prop, then object language and metalanguage begin to collapse.
That would make later distinctions such as:

```text
Asserts(x, φ)
φ
neg φ
T ⊢ φ
```

less controlled.

Don't require:

- DecidableEq Proposition
- Fintype Proposition
- BEq Proposition
- Repr Proposition

Paper 100 quantifies over an open proposition space.
Papers 200, 210, and 220 use finite carriers where their theorems require finiteness,
but do not justify making the shared proposition carrier finite.

So AUX-001 should be:

```lean
structure PropositionalLanguage where
Proposition : Type u
```

or the corresponding field of a larger logical system.

## AUX-002 — Negation

Use a primitive object-language operation: `neg : Proposition → Proposition`
This must not be Lean metalevel `Not`.
The distinction is: `neg p`
is an object-language proposition, while: `¬ entails T p`
is a Lean proposition denying an entailment judgment.
They're different.

Do not initially assume `neg (neg p) = p`
or: `neg bottom = ...`
or excluded middle, completeness, or decidability.

Paper 100 does not require involutive negation
(twice brings you back to original).
Adding it would be stronger logic than the paper needs.

The required connection (item 22) between negation and contradiction belongs in the consequence system:

```text
T ⊢ p →
T ⊢ neg p →
T ⊢ bottom
```

## AUX-003 — Contradiction / Bottom

Use a distinguished object-language proposition: `bottom : Proposition`.
Do not identify it with Lean False.
The paper statement: `T ⊬ bottom`
is a claim about the object-language consequence relation.
It is not just: `¬False`
or a Lean kernel consistency statement.

Do not add explosion unless needed.
Paper 100 requires:

```text
T ⊢ p
T ⊢ neg p
────────────
T ⊢ bottom
```

It does not require:

```text
T ⊢ bottom
────────────
T ⊢ q
```

Explosion is conventional in classical logic but not needed by the paper proofs.
Keeps the interface usable even if a later account wants to
distinguish contradiction detection from arbitrary consequence.

## AUX-004 — Commitment Theory

Use:

```lean
abbrev Theory (L : PropositionalLanguage) :=
Set L.Proposition
```

It supports:

```text
T ∪ U
{p}
p ∈ T
T ⊆ U
```

Use Set, not Finset.
The paper doesn't say commitment theories are finite.
The framework class and design-time guarantees are deliberately open-ended.
The central result must not depend on enumeration.
Set gives arbitrary commitment collections without requiring: `DecidableEq Proposition`.
A computational implementation can later use Finset and
prove that its finite representation denotes the relevant Set.
That would be a realization layer, not theory-layer definition.

Theory id not a new structure.
There is currently no additional invariant that every commitment set must carry.
A wrapper structure would add indirection without adding semantics.
Introduce later only if downstream formalization exposes a need.

## AUX-005 — Entailment

Use an abstract consequence relation: `entails : Theory L → L.Proposition → Prop`.
Do not commit Paper 100 to a particular proof calculus, model theory, theorem prover, or syntax.
The paper reasons only through structural consequence laws.
For minimal required laws use the following interface:

```lean
structure ConsequenceSystem extends PropositionalLanguage where
entails :
Set Proposition → Proposition → Prop

entails_of_mem :
∀ {T p}, p ∈ T → entails T p

monotone :
∀ {T U p},
T ⊆ U →
entails T p →
entails U p

cut :
∀ {T U p},
(∀ q ∈ U, entails T q) →
entails U p →
entails T p

contradiction :
∀ {T p},
entails T p →
entails T (neg p) →
entails T bottom
```

Field names may change but logical content should be approximately this.

Membership or reflexivity:

```text
p ∈ T
──────
T ⊢ p
```

A commitment in a theory is entailed by that theory.

Monotonicity:

```text
T ⊆ U
T ⊢ p
──────
U ⊢ p
```

Used in item 22 when moving from: `S ⊢ p`
to: `S ∪ F ⊢ p`.

Generalized cut:

```text
T entails every member of U
U ⊢ p
──────────────────────────
T ⊢ p
```

Supports the attribution-common-ground argument.
Proves that adding propositions already entailed by a theory does not add independent consequence.

Contradiction introduction:

```text
T ⊢ p
T ⊢ neg p
────────────
T ⊢ bottom
```

Required by item 22.
Generalized cut matters.
For one permitted attribution proposition q, it gives:

```text
T ⊢ q
→
(T ∪ {q} ∪ U ⊢ bottom ↔ T ∪ U ⊢ bottom)
```

It gives the arbitrary-set version needed by the central constraint:

```text
(∀ q ∈ A, T ⊢ q)
→
(T ∪ A ∪ U ⊢ bottom ↔ T ∪ U ⊢ bottom)
```

Do not need:
finiteness of the permitted attribution set;
compactness;
enumeration;
induction over a list of attributions.
Generalized cut handles the whole set.
Strengthens sufficiency side of item 24 without strengthening paper substantive claims.

## AUX-006 — Consistency

Define consistency, rather than introducing it as an independent primitive:

```lean
def Consistent
(C : ConsequenceSystem)
(T : Set C.Proposition) : Prop :=
¬ C.entails T C.bottom
```

Matches the paper notation: `T ⊬ bottom`.

Consistency should remain proposition-valued, not:
a Boolean;
a decision procedure;
a typeclass;
a proof field carried by every theory;
or a property automatically true by construction.

The paper assumes substrate consistency and defines admissibility using framework consistency.
Those statements would lose content if only consistent theories could be constructed.

## AUX-007 — Theory Extension

Use ordinary set operations, like `T ∪ U`
and: `insert p T`
or equivalently: `T ∪ {p}`.
No additional theory-extension structure is needed.
Provide named helpers for readability:

```lean
def Theory.combine
(T U : Set P) : Set P :=
T ∪ U

def Theory.adjoin
(T : Set P)
(p : P) : Set P :=
insert p T
```

Transparent definitions over sets.
Avoid coercing frameworks into sets.
The paper writes: `S ∪ F` for readability.
In Lean, keep the actual projection explicit:
`substrateCommitments S ∪ frameworkCommitments F`
or provide a clearly named helper: `combinedTheory S F`.

Avoid a broad coercion from Framework to Set Proposition.
A framework is not just a commitment theory;
it has evidentiary and documentary properties.

## AUX-008 — Framework

Use an abstract candidate-framework carrier with observable predicates and projections.
Do not define: `Framework := Theory`.
A framework has more structure than its commitments.
Do not define: `Framework := {F // Admissible F}`.
That would make admissibility true by construction and erase item 09.
Do not use a Lean typeclass to represent the paper framework class.
The word `class` in the paper is mathematical.

## Recommended interface

Something close to:

```lean
structure FrameworkSystem
(C : ConsequenceSystem) where

Framework : Type v

commitments :
Framework → Set C.Proposition

evidentiallyGrounded :
Framework → Prop

presentedAsInterpretiveFunction :
Framework → Prop

hasNamedSource :
Framework → Prop

hasDocumentedScope :
Framework → Prop

hasCitableBasis :
Framework → Prop

Then item 09 becomes:

def AdmissibleFramework
(M : FrameworkSystem C)
(F : M.Framework) : Prop :=
Consistent C (M.commitments F) ∧
M.evidentiallyGrounded F ∧
M.presentedAsInterpretiveFunction F ∧
M.hasNamedSource F ∧
M.hasDocumentedScope F ∧
M.hasCitableBasis F
```

Preserves all three paper conditions:
internal consistency;
evidentiary grounding;
documented interpretive function with:
named source;
documented scope;
citable basis.

## Nonlogical Conditions As Predicates

Paper 100 never analyzes the internal structure of
evidence, methods, measurements, records, standards, sources, or documents.
It uses only the result that a framework is or is not admissible.
The shared theory layer should expose those conditions as predicates.
A concrete realization may later prove: `evidentiallyGrounded F`
from structured claims and evidence records.
But the Paper 100 theorem layer does not need that realization.
Same separation we use elsewhere:

```text
abstract theory property
vs.
concrete executable checker
```

Keep Framework distinct from Paper 220 Frame is especially important.
Paper 100 framework is an interpretive position carrying commitments, grounding, and documentation.
Paper 220 interpreted frames participate in:
finite probe families;
interpretation functions;
output equivalences;
interpretive kernels;
environment regimes.
Related concepts, but not definitionally identical.
The names remain distinct:

```text
SE.Framework
SE.InterpretiveFrame
SE.InterpretiveKernel
```

Paper 220 may later define a map from an admissible framework to one or more interpreted frames.
Not forced to identify them.

## Recommended Combined Interface

The conceptual organization should look like this:

```lean
universe u v

namespace SE

structure PropositionalLanguage where
Proposition : Type u
neg : Proposition → Proposition
bottom : Proposition

abbrev Theory (L : PropositionalLanguage) :=
Set L.Proposition

structure ConsequenceSystem
extends PropositionalLanguage where

entails :
Theory toPropositionalLanguage →
Proposition →
Prop

entails_of_mem :
∀ {T p}, p ∈ T → entails T p

monotone :
∀ {T U p},
T ⊆ U →
entails T p →
entails U p

cut :
∀ {T U p},
(∀ q ∈ U, entails T q) →
entails U p →
entails T p

contradiction :
∀ {T p},
entails T p →
entails T (neg p) →
entails T bottom

def Consistent
(C : ConsequenceSystem)
(T : Theory C.toPropositionalLanguage) : Prop :=
¬ C.entails T C.bottom

structure FrameworkSystem
(C : ConsequenceSystem) where

Framework : Type v

commitments :
Framework → Theory C.toPropositionalLanguage

evidentiallyGrounded :
Framework → Prop

presentedAsInterpretiveFunction :
Framework → Prop

hasNamedSource :
Framework → Prop

hasDocumentedScope :
Framework → Prop

hasCitableBasis :
Framework → Prop

end SE
```

## Later Papers

### Paper 200 — Referential Regimes

Paper 200 needs finite carriers, equivalence relations, partitions, refinement, and regime structure.
None of that requires the proposition carrier to be finite.
Its finite carriers should be local parameters such as:

```lean
Record : Type u
[Finite Record]
```

or whatever exact representation the Paper 200 audit selects.
The logical foundation remains independent.

### Paper 210 — Operational Identity

Paper 210 needs:
declared partitions;
operational partitions;
transformation histories;
signatures;
witnesses;
finite comparison procedures.
Those should not be encoded into Proposition, Theory, or Framework.
Operational audit can produce propositions or evidence artifacts later,
but partition machinery should remain structurally separate.

### Paper 220 — Interpretive Kernels

Paper 220 needs:
frame carriers;
occurrence carriers;
probes;
interpretation functions;
output equivalence;
induced kernels;
refinement thresholds.
Keeping Framework abstract lets Paper 220 relate frameworks to frames without identifying the two.
Keeping entailment abstract prevents Paper 220 finite kernel semantics from
becoming the accidental definition of Paper 100 consequence.

## Rejected

Rejected these implementations:

```text
Proposition := Prop
Theory := Finset Proposition
Entailment := membership
Consistency := a Boolean checker
Framework := Theory
Framework := subtype of admissible frameworks
FrameworkClass := List Framework
Negation := Lean Not
Bottom := Lean False
```

Each would collapse a distinction made by the paper or
impose a computational restriction that is not in the theory.

## Aux Resolution

The auxiliaries resolve as follows:

```text
AUX-001  arbitrary object-language carrier
AUX-002  primitive object-language negation
AUX-003  distinguished object-language bottom
AUX-004  Set-valued commitment theory
AUX-005  abstract Tarskian consequence relation
         plus contradiction introduction
AUX-006  non-entailment of bottom
AUX-007  set union and singleton extension
AUX-008  abstract candidate-framework carrier
         with commitment projection and admissibility predicates
```

Smallest foundation sufficient for Paper 100
and neutral toward Papers 200, 210, and 220.
