# SE-100 Lean Formalization Basis

> Exact labeled mathematical environments extracted from the authoritative Paper 100 LaTeX source.

- Source: `se100-neutral-substrates-v1.tex`
- Extracted: 2026-10-24T17:05:23-05:00
- Labeled items: 28

Each item contains the exact LaTeX environment from its opening `\begin{...}` through its matching `\end{...}`.

The items remain in paper order. No mathematical text inside an extracted environment has been rewritten.

## Summary

| Kind | Count |
| --- | ---: |
| definition | 16 |
| note | 3 |
| assumption | 3 |
| remark | 4 |
| constraint | 1 |
| example | 1 |

## Paper-Order Index

| # | Paper ID | Kind | Title | Source lines |
| ---: | --- | --- | --- | ---: |
| 1 | `se100.def.Substrate` | definition | Substrate | 514-520 |
| 2 | `se100.def.SubstrateCommitment` | definition | Substrate-Layer Commitment | 542-548 |
| 3 | `se100.note.ConsequenceSystem` | note | Consequence System | 550-559 |
| 4 | `se100.note.CausalNormative` | note | Causal and Normative Content as Primitive Classifications | 565-585 |
| 5 | `se100.def.AttributionProposition` | definition | Attribution Proposition | 591-601 |
| 6 | `se100.def.ObjectLevelInterpretiveProposition` | definition | Object-Level Interpretive Proposition | 607-619 |
| 7 | `se100.def.ObjectLevelCausalNormativeCommitment` | definition | Object-Level Causal or Normative Commitment | 629-634 |
| 8 | `se100.def.ReferentialRegime` | definition | Referential Regime | 641-651 |
| 9 | `se100.def.ReferentialCommitments` | definition | Referential Commitments | 667-676 |
| 10 | `se100.def.AdmissibleFramework` | definition | Admissible Framework | 688-701 |
| 11 | `se100.note.FrameworkClass` | note | The Framework Class $\Frameworks$ | 723-739 |
| 12 | `se100.def.PermittedAttributionProposition` | definition | Permitted Attribution Proposition | 741-760 |
| 13 | `se100.def.FrameworkVariant` | definition | Framework-Variant Proposition | 762-773 |
| 14 | `se100.def.FrameworkInvariant` | definition | Framework-Invariant Proposition | 783-794 |
| 15 | `se100.remark.FrameworkInvariantRefutation` | remark | Framework Invariance and Refutation | 808-822 |
| 16 | `se100.def.FrameworkCompatibleCommitmentSet` | definition | Framework-Compatible Commitment Set | 824-832 |
| 17 | `se100.def.ContestedCausalNormative` | definition | Contested Causal or Normative Proposition | 885-894 |
| 18 | `se100.assump.Contestability` | assumption | Contestability | 896-899 |
| 19 | `se100.assump.ReferentialCommonGround` | assumption | Referential Common Ground | 916-935 |
| 20 | `se100.remark.AttributionCommonGround` | remark | Attribution and Common Ground | 959-995 |
| 21 | `se100.def.InterpretiveNonCommitment` | definition | Interpretive Non-Commitment | 998-1009 |
| 22 | `se100.def.ExtensionStability` | definition | Extension Stability | 1015-1022 |
| 23 | `se100.assump.SubstrateConsistency` | assumption | Substrate Consistency | 1032-1036 |
| 24 | `se100.remark.PropertyRelation` | remark | Relation Between the Two Properties | 1048-1085 |
| 25 | `se100.def.NeutralityByDesign` | definition | Neutrality by Design | 1092-1106 |
| 26 | `se100.constraint.Neutrality` | constraint | Neutrality | 1118-1135 |
| 27 | `se100.remark.CharacterizationHypothesis` | remark | Characterization as an Explicit Hypothesis | 1141-1155 |
| 28 | `se100.example.ReificationFragment` | example | Reification Fragment | 1257-1263 |

## Extracted Basis

## 01. `se100.def.Substrate` — Substrate

- Kind: `definition`
- Source lines: `514-520`

```latex
\begin{definition}[Substrate]
  \label{se100.def.Substrate}
  A \emph{substrate} $\Substrate$ is a shared representational base providing
  stable reference for entities, occurrences, and institutional artifacts
  across a class of admissible interpretive frameworks $\Frameworks$.
  Stable reference consists of individuation, co-reference, and persistence.
\end{definition}
```

## 02. `se100.def.SubstrateCommitment` — Substrate-Layer Commitment

- Kind: `definition`
- Source lines: `542-548`

```latex
\begin{definition}[Substrate-Layer Commitment]
  \label{se100.def.SubstrateCommitment}
  A substrate $\Substrate$ \emph{commits} to a proposition $p$ when
  $\Substrate \entails p$;
  that is, $p$ is asserted by the substrate independently of any interpretive
  framework.
\end{definition}
```

## 03. `se100.note.ConsequenceSystem` — Consequence System

- Kind: `note`
- Source lines: `550-559`

```latex
\begin{note}[Consequence System]
  \label{se100.note.ConsequenceSystem}
  The arguments below use only three properties of $\entails$:
  (i)~every member of a theory is entailed by it;
  (ii)~generalized cut: if $T$ entails every member of $U$ and $U$
  entails $p$, then $T$ entails $p$ (monotonicity follows); and
  (iii)~if a theory entails both $p$ and $\neg p$, it entails $\bot$.
  No explosion, excluded middle, negation introduction, double negation,
  completeness, decidability, or compactness is assumed.
\end{note}
```

## 04. `se100.note.CausalNormative` — Causal and Normative Content as Primitive Classifications

- Kind: `note`
- Source lines: `565-585`

```latex
\begin{note}[Causal and Normative Content as Primitive Classifications]
  \label{se100.note.CausalNormative}
  This paper treats \emph{causal proposition} and \emph{normative proposition}
  as primitive content classifications,
  not as terms reduced here to a formal decision procedure.
  As a working guide,
  a proposition is causal if it asserts that one event,
  state, action, condition, or process brought about, produced, prevented, or
  contributed to another.
  A proposition is normative if it asserts that something was justified,
  permitted, required, prohibited, correct, incorrect, compliant, or in
  violation of a rule, standard, policy, or norm.

  The classification is not by surface vocabulary.
  An innocuous-looking field can encode a causal or normative commitment,
  and causal or normative words can appear inside an attributed assertion
  without the substrate committing to the asserted causal or normative
  proposition.
  The constraint applies once the relevant content classification is fixed
  for the accountability context.
\end{note}
```

## 05. `se100.def.AttributionProposition` — Attribution Proposition

- Kind: `definition`
- Source lines: `591-601`

```latex
\begin{definition}[Attribution Proposition]
  \label{se100.def.AttributionProposition}
  An \emph{attribution proposition} is a proposition of the form
  $\Asserts(x,\varphi)$,
  meaning that some framework, source, agent, institution, record, or document $x$
  asserts proposition $\varphi$.

  A substrate-layer commitment to $\Asserts(x,\varphi)$ is a
  commitment to the attribution,
  not to the asserted proposition $\varphi$.
\end{definition}
```

## 06. `se100.def.ObjectLevelInterpretiveProposition` — Object-Level Interpretive Proposition

- Kind: `definition`
- Source lines: `607-619`

```latex
\begin{definition}[Object-Level Interpretive Proposition]
  \label{se100.def.ObjectLevelInterpretiveProposition}
  An \emph{object-level interpretive proposition} is an asserted proposition
  $\varphi$ itself,
  about the referents fixed by the substrate,
  rather than an attribution proposition of the form
  $\Asserts(x,\varphi)$.

  An \emph{object-level causal or normative proposition} is
  an object-level interpretive proposition whose content is causal or normative
  (\NoteRef{se100.note.CausalNormative}{Causal and Normative Content as
    Primitive Classifications}).
\end{definition}
```

## 07. `se100.def.ObjectLevelCausalNormativeCommitment` — Object-Level Causal or Normative Commitment

- Kind: `definition`
- Source lines: `629-634`

```latex
\begin{definition}[Object-Level Causal or Normative Commitment]
  \label{se100.def.ObjectLevelCausalNormativeCommitment}
  An \emph{object-level causal or normative commitment} is a substrate-layer
  commitment to an object-level causal or normative proposition,
  rather than to an attribution proposition about that proposition.
\end{definition}
```

## 08. `se100.def.ReferentialRegime` — Referential Regime

- Kind: `definition`
- Source lines: `641-651`

```latex
\begin{definition}[Referential Regime]
  \label{se100.def.ReferentialRegime}
  A \emph{referential regime} is the triple of
  \begin{enumerate}
    \item individuation conditions,
    \item co-reference conditions, and
    \item persistence conditions
  \end{enumerate}
  by which a substrate fixes and tracks entities, occurrences, and institutional
  artifacts.
\end{definition}
```

## 09. `se100.def.ReferentialCommitments` — Referential Commitments

- Kind: `definition`
- Source lines: `667-676`

```latex
\begin{definition}[Referential Commitments]
  \label{se100.def.ReferentialCommitments}
  Let $\SubstrateRef$ denote the \emph{referential commitments} of $\Substrate$.
  These are the substrate-layer commitments fixed by its referential regime,
  including identifiers;
  the typing of entities, occurrences, and institutional artifacts;
  timestamps;
  provenance;
  and referential relations among them.
\end{definition}
```

## 10. `se100.def.AdmissibleFramework` — Admissible Framework

- Kind: `definition`
- Source lines: `688-701`

```latex
\begin{definition}[Admissible Framework]
  \label{se100.def.AdmissibleFramework}
  A framework $\Framework$ is \emph{admissible} if it satisfies three conditions:
  \begin{enumerate}
    \item \textbf{Internal consistency}: $\Framework \notentails \bot$.
    \item \textbf{Evidentiary grounding}: where $\Framework$ makes empirical,
          causal, normative, or other interpretive claims, it identifies the evidence,
          source, method, measurement, observation, record, rule, standard, or
          document on which those claims rely.
    \item \textbf{Documented interpretive function}: $\Framework$ is presented as
          an interpretive function with a
          named source, documented scope, and citable basis.
  \end{enumerate}
\end{definition}
```

## 11. `se100.note.FrameworkClass` — The Framework Class $\Frameworks$

- Kind: `note`
- Source lines: `723-739`

```latex
\begin{note}[The Framework Class $\Frameworks$]
  \label{se100.note.FrameworkClass}
  Throughout, $\Frameworks$ denotes the
  class of \emph{all} admissible interpretive frameworks.
  Admissibility is an intrinsic property
  (\DefRef{se100.def.AdmissibleFramework}{Admissible Framework}),
  so membership in $\Frameworks$ does not depend on designer knowledge.
  The class is open and not enumerable at design time:
  new admissible interpretive frameworks can be authored at any
  point in a record's lifetime.
  ``Extension of $\Frameworks$'' below refers to
  such frameworks becoming known and entering consideration,
  not to change in the intrinsic class.
  This sense of extension is distinct from the
  substrate-with-framework extension $\Substrate \cup \Framework$ named in
  \DefRef{se100.def.ExtensionStability}{Extension Stability}.
\end{note}
```

## 12. `se100.def.PermittedAttributionProposition` — Permitted Attribution Proposition

- Kind: `definition`
- Source lines: `741-760`

```latex
\begin{definition}[Permitted Attribution Proposition]
  \label{se100.def.PermittedAttributionProposition}
  An attribution proposition $\Asserts(x,\varphi)$ is
  \emph{permitted at the foundational layer} if the attributional basis for
  $x$'s assertion of $\varphi$ is fixed by the substrate's referential
  commitments $\SubstrateRef$.

  The attributional basis includes the source, assertion occurrence,
  provenance, and content reference needed to identify what was asserted,
  by whom, and under what record basis.

  Because its attributional basis is fixed by $\SubstrateRef$,
  a permitted attribution proposition $\Asserts(x,\varphi)$ is itself among the
  substrate-layer commitments determined by $\SubstrateRef$; that is,
  \[
    \SubstrateRef \entails \Asserts(x,\varphi) .
  \]
  Committing to it commits the substrate to the attribution by $x$,
  not to the asserted proposition $\varphi$.
\end{definition}
```

## 13. `se100.def.FrameworkVariant` — Framework-Variant Proposition

- Kind: `definition`
- Source lines: `762-773`

```latex
\begin{definition}[Framework-Variant Proposition]
  \label{se100.def.FrameworkVariant}
  A proposition $p$ is \emph{framework-variant}
  with respect to substrate $\Substrate$ and framework class $\Frameworks$
  if there exist admissible frameworks $\FrameworkOne, \FrameworkTwo \in \Frameworks$
  such that
  \[
    \Substrate \cup \FrameworkOne \entails p
    \quad\text{and}\quad
    \Substrate \cup \FrameworkTwo \entails \neg p
  \]
\end{definition}
```

## 14. `se100.def.FrameworkInvariant` — Framework-Invariant Proposition

- Kind: `definition`
- Source lines: `783-794`

```latex
\begin{definition}[Framework-Invariant Proposition]
  \label{se100.def.FrameworkInvariant}
  A proposition $p$ is \emph{framework-invariant} with respect to substrate
  $\Substrate$ and framework class $\Frameworks$
  if, for every admissible framework $\Framework \in \Frameworks$,
  \[
    \Substrate \cup \Framework \cup \{p\} \notentails \bot .
  \]
  Equivalently,
  $p$ can be added to the substrate and
  remain compatible with every admissible framework.
\end{definition}
```

## 15. `se100.remark.FrameworkInvariantRefutation` — Framework Invariance and Refutation

- Kind: `remark`
- Source lines: `808-822`

```latex
\begin{remark}[Framework Invariance and Refutation]
  \label{se100.remark.FrameworkInvariantRefutation}
  Say that an admissible framework $\Framework$ \emph{refutes} $p$
  if $\Substrate \cup \Framework \entails \neg p$.
  Framework invariance implies that no admissible framework refutes $p$:
  if $\Substrate \cup \Framework \entails \neg p$,
  then $\Substrate \cup \Framework \cup \{p\}$ entails both $p$ and $\neg p$,
  hence $\bot$.

  The converse requires negation introduction:
  if $T \cup \{q\} \entails \bot$, then $T \entails \neg q$.
  This paper does not assume it.
  Framework invariance is therefore defined by consistency,
  not by non-refutation.
\end{remark}
```

## 16. `se100.def.FrameworkCompatibleCommitmentSet` — Framework-Compatible Commitment Set

- Kind: `definition`
- Source lines: `824-832`

```latex
\begin{definition}[Framework-Compatible Commitment Set]
  \label{se100.def.FrameworkCompatibleCommitmentSet}
  A set of substrate-layer commitments $C$ is \emph{framework-compatible}
  with respect to $\Frameworks$ if, for every admissible framework
  $\Framework \in \Frameworks$,
  \[
    C \cup \Framework \notentails \bot .
  \]
\end{definition}
```

## 17. `se100.def.ContestedCausalNormative` — Contested Causal or Normative Proposition

- Kind: `definition`
- Source lines: `885-894`

```latex
\begin{definition}[Contested Causal or Normative Proposition]
  \label{se100.def.ContestedCausalNormative}
  A causal or normative proposition $p$ is \emph{contested}
  in the relevant accountability context
  if its acceptance, rejection, interpretation, or application
  is not fixed by the referential commitments $\SubstrateRef$,
  so that it may vary across admissible frameworks.

  Let $C_{cn}$ denote the class of contested causal or normative propositions.
\end{definition}
```

## 18. `se100.assump.Contestability` — Contestability

- Kind: `assumption`
- Source lines: `896-899`

```latex
\begin{assumption}[Contestability]
  \label{se100.assump.Contestability}
  No $p \in C_{cn}$ is guaranteed framework-invariant at design time.
\end{assumption}
```

## 19. `se100.assump.ReferentialCommonGround` — Referential Common Ground

- Kind: `assumption`
- Source lines: `916-935`

```latex
\begin{assumption}[Referential Common Ground]
  \label{se100.assump.ReferentialCommonGround}
  Let $\SubstrateRef$ be the referential commitments of $\Substrate$
  (\DefRef{se100.def.ReferentialCommitments}{Referential Commitments}).
  For every admissible framework $\Framework$,
  \[
    \SubstrateRef \cup \Framework \notentails \bot .
  \]
  In particular, for every permitted attribution proposition
  $\Asserts(x,\varphi)$,
  \[
    \SubstrateRef \cup \{\Asserts(x,\varphi)\} \cup \Framework
    \notentails \bot .
  \]
  This second condition follows from the first,
  because $\SubstrateRef \entails \Asserts(x,\varphi)$ by definition;
  the argument below does not use it.
  Both conditions hold for every admissible framework,
  including admissible frameworks not known when $\Substrate$ is designed.
\end{assumption}
```

## 20. `se100.remark.AttributionCommonGround` — Attribution and Common Ground

- Kind: `remark`
- Source lines: `959-995`

```latex
\begin{remark}[Attribution and Common Ground]
  \label{se100.remark.AttributionCommonGround}
  A permitted attribution proposition
  $\Asserts(x,\varphi)$ commits the substrate to the attribution by $x$,
  not to the asserted proposition $\varphi$
  (\DefRef{se100.def.PermittedAttributionProposition}{Permitted Attribution Proposition}).
  An admissible framework may reject $\varphi$ without rejecting that
  $x$ asserted it.

  A permitted attribution proposition satisfies
  $\SubstrateRef \entails \Asserts(x,\varphi)$
  by definition
  (\DefRef{se100.def.PermittedAttributionProposition}{Permitted Attribution Proposition}).
  Hence adjoining it to the foundational layer adds no independent commitment
  beyond what is already determined by $\SubstrateRef$: for every admissible
  framework $\Framework$,
  \[
    \SubstrateRef \cup \{\Asserts(x,\varphi)\} \cup \Framework
    \entails \bot
    \quad\text{iff}\quad
    \SubstrateRef \cup \Framework \entails \bot .
  \]
  Therefore, by
  \AssumpRef{se100.assump.ReferentialCommonGround}{Referential Common Ground},
  \[
    \SubstrateRef \cup \{\Asserts(x,\varphi)\} \cup \Framework
    \notentails \bot .
  \]

  If an admissible framework rejects $\varphi$,
  that does not alone contest the attribution proposition $\Asserts(x,\varphi)$.
  But if admissible frameworks contest whether the attributional basis,
  for example, who asserted the claim, what was
  asserted, or what provenance identifies the assertion occurrence,
  then the attribution proposition is not permitted at the foundational layer.
  That is a boundary case, not an exception to the neutrality constraint.
\end{remark}
```

## 21. `se100.def.InterpretiveNonCommitment` — Interpretive Non-Commitment

- Kind: `definition`
- Source lines: `998-1009`

```latex
\begin{definition}[Interpretive Non-Commitment]
  \label{se100.def.InterpretiveNonCommitment}
  A substrate $\Substrate$ satisfies \emph{interpretive non-commitment} if it
  makes no substrate-layer commitment to any proposition that is
  framework-variant with respect to $\Substrate$ and $\Frameworks$.
  It also makes no commitment to the negation of such a proposition,
  and does not assume that negation preserves framework variance;
  explicitly, if
  $p$ is framework-variant with respect to $\Substrate$ and $\Frameworks$,
  then
  $\Substrate \notentails p$ and $\Substrate \notentails \neg p$.
\end{definition}
```

## 22. `se100.def.ExtensionStability` — Extension Stability

- Kind: `definition`
- Source lines: `1015-1022`

```latex
\begin{definition}[Extension Stability]
  \label{se100.def.ExtensionStability}
  A substrate $\Substrate$ satisfies \emph{extension stability} if, for every
  admissible framework $\Framework$,
  \[
    \Substrate \cup \Framework \notentails \bot
  \]
\end{definition}
```

## 23. `se100.assump.SubstrateConsistency` — Substrate Consistency

- Kind: `assumption`
- Source lines: `1032-1036`

```latex
\begin{assumption}[Substrate Consistency]
  \label{se100.assump.SubstrateConsistency}
  Every substrate considered in this paper is internally consistent:
  $\Substrate \notentails \bot$.
\end{assumption}
```

## 24. `se100.remark.PropertyRelation` — Relation Between the Two Properties

- Kind: `remark`
- Source lines: `1048-1085`

```latex
\begin{remark}[Relation Between the Two Properties]
  \label{se100.remark.PropertyRelation}
  Extension stability entails interpretive non-commitment.
  To see this, suppose that $p$ is framework-variant with respect to
  $\Substrate$ and $\Frameworks$.
  Then there are admissible frameworks $\FrameworkOne, \FrameworkTwo \in \Frameworks$
  such that
  \[
    \Substrate \cup \FrameworkOne \entails p
    \qquad\text{and}\qquad
    \Substrate \cup \FrameworkTwo \entails \neg p .
  \]

  If $\Substrate \entails p$, then
  $\Substrate \cup \FrameworkTwo \entails p$
  and
  $\Substrate \cup \FrameworkTwo \entails \neg p$,
  so
  \[
    \Substrate \cup \FrameworkTwo \entails \bot .
  \]
  If $\Substrate \entails \neg p$, then
  $\Substrate \cup \FrameworkOne \entails \neg p$
  and
  $\Substrate \cup \FrameworkOne \entails p$,
  so
  \[
    \Substrate \cup \FrameworkOne \entails \bot .
  \]
  In either case, extension stability fails.
  Therefore, if extension stability holds, the substrate cannot commit to
  either side of a framework-variant proposition.

  This paper uses only this direction.
  The two properties are retained under separate names because they identify
  distinct design failures:
  substrate-layer commitment on disputed content and breakdown of layerability.
\end{remark}
```

## 25. `se100.def.NeutralityByDesign` — Neutrality by Design

- Kind: `definition`
- Source lines: `1092-1106`

```latex
\begin{definition}[Neutrality by Design]
  \label{se100.def.NeutralityByDesign}
  A substrate $\Substrate$ is \emph{neutral}
  when it satisfies interpretive non-commitment
  (\DefRef{se100.def.InterpretiveNonCommitment}{Interpretive Non-Commitment})
  and extension stability
  (\DefRef{se100.def.ExtensionStability}{Extension Stability}).

  It is \emph{neutral by design} when some permitted
  design-time basis establishes that neutrality for the full
  intrinsic class of admissible frameworks, including frameworks
  not known when the substrate is constructed.
  Truth of the neutrality condition and possession of such a
  permitted basis are distinct claims.
\end{definition}
```

## 26. `se100.constraint.Neutrality` — Neutrality

- Kind: `constraint`
- Source lines: `1118-1135`

```latex
\begin{constraint}[Neutrality]
  \label{se100.constraint.Neutrality}
  Let $\Substrate$ be a substrate with referential commitments
  $\SubstrateRef$. Assume
  \AssumpRef{se100.assump.ReferentialCommonGround}{Referential Common Ground}.
  If every substrate-layer commitment is either a member of
  $\SubstrateRef$ or a permitted attribution proposition
  (\DefRef{se100.def.PermittedAttributionProposition}
  {Permitted Attribution Proposition}),
  then $\Substrate$ satisfies extension stability and
  interpretive non-commitment for every admissible framework.
  Thus it is semantically neutral.

  This result does not, without a further permitted
  design-time-guarantee basis, establish neutrality by design.
  Nor does it assert that every neutral substrate must satisfy
  this specific restriction.
\end{constraint}
```

## 27. `se100.remark.CharacterizationHypothesis` — Characterization as an Explicit Hypothesis

- Kind: `remark`
- Source lines: `1141-1155`

```latex
\begin{remark}[Characterization as an Explicit Hypothesis]
  \label{se100.remark.CharacterizationHypothesis}
  The biconditional (under Contestability and Referential Common
  Ground, neutrality by design holds if and only if the foundational
  layer is restricted to the permitted classes) is not derived here.
  Its forward direction is the by-design form of
  \ConstRef{se100.constraint.Neutrality}{Neutrality}, which requires a
  permitted design-time basis; its reverse direction is the converse
  discussed below under limits of necessity.
  The accompanying Lean formalization represents the biconditional,
  together with the exclusion of object-level causal or normative
  commitments by that restriction, as an explicit hypothesis on a
  realization, named \texttt{CharacterizationHypothesis}.
  It is an assumption about the realization, not a result of this paper.
\end{remark}
```

## 28. `se100.example.ReificationFragment` — Reification Fragment

- Kind: `example`
- Source lines: `1257-1263`

```latex
\begin{example}[Reification Fragment]
  \label{se100.example.ReificationFragment}
  Consider a decision record concerning an automated eligibility denial.
  The record involves a subject $u$, a decision $d$, a model or instrument $m$,
  a timestamp $t$, an institutional policy $r$, and
  a claim asserted by a source $x$ (for example, a framework).
\end{example}
```
