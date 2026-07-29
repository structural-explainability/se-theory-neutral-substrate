# SE-100 Lean Formalization Basis

> Exact labeled mathematical environments extracted from the Paper 100 LaTeX source.

- Source: `se100-neutral-substrates-v1.tex`
- Extracted: 2026-07-29T05:37:26-05:00
- Labeled items: 25

Each item contains the exact LaTeX environment from its opening `\begin{...}` through its matching `\end{...}`.

The items remain in paper order.

## Summary

| Kind       | Count |
| ---------- | ----: |
| definition |    16 |
| note       |     2 |
| assumption |     3 |
| remark     |     2 |
| constraint |     1 |
| example    |     1 |

## Paper-Order Index

|   # | Paper ID                                         | Kind       | Title                                                     | Source lines |
| --: | ------------------------------------------------ | ---------- | --------------------------------------------------------- | -----------: |
|   1 | `se100.def.Substrate`                            | definition | Substrate                                                 |      502-508 |
|   2 | `se100.def.SubstrateCommitment`                  | definition | Substrate-Layer Commitment                                |      530-536 |
|   3 | `se100.note.CausalNormative`                     | note       | Causal and Normative Content as Primitive Classifications |      542-562 |
|   4 | `se100.def.AttributionProposition`               | definition | Attribution Proposition                                   |      568-578 |
|   5 | `se100.def.ObjectLevelInterpretiveProposition`   | definition | Object-Level Interpretive Proposition                     |      584-596 |
|   6 | `se100.def.ObjectLevelCausalNormativeCommitment` | definition | Object-Level Causal or Normative Commitment               |      606-611 |
|   7 | `se100.def.ReferentialRegime`                    | definition | Referential Regime                                        |      618-628 |
|   8 | `se100.def.ReferentialCommitments`               | definition | Referential Commitments                                   |      644-653 |
|   9 | `se100.def.AdmissibleFramework`                  | definition | Admissible Framework                                      |      659-672 |
|  10 | `se100.note.FrameworkClass`                      | note       | The Framework Class $\Frameworks$                         |      694-710 |
|  11 | `se100.def.PermittedAttributionProposition`      | definition | Permitted Attribution Proposition                         |      712-731 |
|  12 | `se100.def.FrameworkVariant`                     | definition | Framework-Variant Proposition                             |      733-744 |
|  13 | `se100.def.FrameworkInvariant`                   | definition | Framework-Invariant Proposition                           |      754-766 |
|  14 | `se100.def.FrameworkCompatibleCommitmentSet`     | definition | Framework-Compatible Commitment Set                       |      780-788 |
|  15 | `se100.def.ContestedCausalNormative`             | definition | Contested Causal or Normative Proposition                 |      827-836 |
|  16 | `se100.assump.Contestability`                    | assumption | Contestability                                            |      838-841 |
|  17 | `se100.assump.ReferentialCommonGround`           | assumption | Referential Common Ground                                 |      858-874 |
|  18 | `se100.remark.AttributionCommonGround`           | remark     | Attribution and Common Ground                             |      893-929 |
|  19 | `se100.def.InterpretiveNonCommitment`            | definition | Interpretive Non-Commitment                               |      932-941 |
|  20 | `se100.def.ExtensionStability`                   | definition | Extension Stability                                       |      947-954 |
|  21 | `se100.assump.SubstrateConsistency`              | assumption | Substrate Consistency                                     |      964-968 |
|  22 | `se100.remark.PropertyRelation`                  | remark     | Relation Between the Two Properties                       |     980-1017 |
|  23 | `se100.def.NeutralityByDesign`                   | definition | Neutrality by Design                                      |    1024-1041 |
|  24 | `se100.constraint.Neutrality`                    | constraint | Neutrality                                                |    1050-1067 |
|  25 | `se100.example.ReificationFragment`              | example    | Reification Fragment                                      |    1219-1225 |

## Extracted Basis

## 01. `se100.def.Substrate` — Substrate

- Kind: `definition`
- Source lines: `502-508`

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
- Source lines: `530-536`

```latex
\begin{definition}[Substrate-Layer Commitment]
  \label{se100.def.SubstrateCommitment}
  A substrate $\Substrate$ \emph{commits} to a proposition $p$ when
  $\Substrate \entails p$;
  that is, $p$ is asserted by the substrate independently of any interpretive
  framework.
\end{definition}
```

## 03. `se100.note.CausalNormative` — Causal and Normative Content as Primitive Classifications

- Kind: `note`
- Source lines: `542-562`

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

## 04. `se100.def.AttributionProposition` — Attribution Proposition

- Kind: `definition`
- Source lines: `568-578`

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

## 05. `se100.def.ObjectLevelInterpretiveProposition` — Object-Level Interpretive Proposition

- Kind: `definition`
- Source lines: `584-596`

```latex
\begin{definition}[Object-Level Interpretive Proposition]
  \label{se100.def.ObjectLevelInterpretiveProposition}
  An \emph{object-level interpretive proposition} is an asserted proposition
  $\varphi$,
  about the referents fixed by the substrate,
  rather than an attribution proposition of the form
  $\Asserts(x,\varphi)$.

  An \emph{object-level causal or normative proposition} is
  an object-level interpretive proposition whose content is causal or normative
  (\NoteRef{se100.note.CausalNormative}{Causal and Normative Content as
    Primitive Classifications}).
\end{definition}
```

## 06. `se100.def.ObjectLevelCausalNormativeCommitment` — Object-Level Causal or Normative Commitment

- Kind: `definition`
- Source lines: `606-611`

```latex
\begin{definition}[Object-Level Causal or Normative Commitment]
  \label{se100.def.ObjectLevelCausalNormativeCommitment}
  An \emph{object-level causal or normative commitment} is a substrate-layer
  commitment to an object-level causal or normative proposition,
  rather than to an attribution proposition about that proposition.
\end{definition}
```

## 07. `se100.def.ReferentialRegime` — Referential Regime

- Kind: `definition`
- Source lines: `618-628`

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

## 08. `se100.def.ReferentialCommitments` — Referential Commitments

- Kind: `definition`
- Source lines: `644-653`

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

## 09. `se100.def.AdmissibleFramework` — Admissible Framework

- Kind: `definition`
- Source lines: `659-672`

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

## 10. `se100.note.FrameworkClass` — The Framework Class $\Frameworks$

- Kind: `note`
- Source lines: `694-710`

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

## 11. `se100.def.PermittedAttributionProposition` — Permitted Attribution Proposition

- Kind: `definition`
- Source lines: `712-731`

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
  a permitted attribution proposition $\Asserts(x,\varphi)$ is among the
  substrate-layer commitments determined by $\SubstrateRef$; that is,
  \[
    \SubstrateRef \entails \Asserts(x,\varphi) .
  \]
  Committing to it commits the substrate to the attribution by $x$,
  not to the asserted proposition $\varphi$.
\end{definition}
```

## 12. `se100.def.FrameworkVariant` — Framework-Variant Proposition

- Kind: `definition`
- Source lines: `733-744`

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

## 13. `se100.def.FrameworkInvariant` — Framework-Invariant Proposition

- Kind: `definition`
- Source lines: `754-766`

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
  remain compatible with every admissible framework:
  no admissible framework refutes $p$ on the shared base.
\end{definition}
```

## 14. `se100.def.FrameworkCompatibleCommitmentSet` — Framework-Compatible Commitment Set

- Kind: `definition`
- Source lines: `780-788`

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

## 15. `se100.def.ContestedCausalNormative` — Contested Causal or Normative Proposition

- Kind: `definition`
- Source lines: `827-836`

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

## 16. `se100.assump.Contestability` — Contestability

- Kind: `assumption`
- Source lines: `838-841`

```latex
\begin{assumption}[Contestability]
  \label{se100.assump.Contestability}
  No $p \in C_{cn}$ is guaranteed framework-invariant at design time.
\end{assumption}
```

## 17. `se100.assump.ReferentialCommonGround` — Referential Common Ground

- Kind: `assumption`
- Source lines: `858-874`

```latex
\begin{assumption}[Referential Common Ground]
  \label{se100.assump.ReferentialCommonGround}
  Let $\SubstrateRef$ be the referential commitments of $\Substrate$
  (\DefRef{se100.def.ReferentialCommitments}{Referential Commitments}).
  For every admissible framework $\Framework$,
  \[
    \SubstrateRef \cup \Framework \notentails \bot .
  \]
  Moreover, for every permitted attribution proposition
  $\Asserts(x,\varphi)$,
  \[
    \SubstrateRef \cup \{\Asserts(x,\varphi)\} \cup \Framework
    \notentails \bot .
  \]
  Both conditions hold for every admissible framework,
  including admissible frameworks not known when $\Substrate$ is designed.
\end{assumption}
```

## 18. `se100.remark.AttributionCommonGround` — Attribution and Common Ground

- Kind: `remark`
- Source lines: `893-929`

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
    \SubstrateRef \cup {\Asserts(x,\varphi)} \cup \Framework
    \entails \bot
    \quad\text{iff}\quad
    \SubstrateRef \cup \Framework \entails \bot .
  \]
  Therefore, by
  \AssumpRef{se100.assump.ReferentialCommonGround}{Referential Common Ground},
  \[
    \SubstrateRef \cup {\Asserts(x,\varphi)} \cup \Framework
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

## 19. `se100.def.InterpretiveNonCommitment` — Interpretive Non-Commitment

- Kind: `definition`
- Source lines: `932-941`

```latex
\begin{definition}[Interpretive Non-Commitment]
  \label{se100.def.InterpretiveNonCommitment}
  A substrate $\Substrate$ satisfies \emph{interpretive non-commitment} if it
  makes no substrate-layer commitment to any proposition that is
  framework-variant with respect to $\Substrate$ and $\Frameworks$.
  Equivalently, if
  $p$ is framework-variant with respect to $\Substrate$ and $\Frameworks$,
  then
  $\Substrate \notentails p$ and $\Substrate \notentails \neg p$.
\end{definition}
```

## 20. `se100.def.ExtensionStability` — Extension Stability

- Kind: `definition`
- Source lines: `947-954`

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

## 21. `se100.assump.SubstrateConsistency` — Substrate Consistency

- Kind: `assumption`
- Source lines: `964-968`

```latex
\begin{assumption}[Substrate Consistency]
  \label{se100.assump.SubstrateConsistency}
  Every substrate considered in this paper is internally consistent:
  $\Substrate \notentails \bot$.
\end{assumption}
```

## 22. `se100.remark.PropertyRelation` — Relation Between the Two Properties

- Kind: `remark`
- Source lines: `980-1017`

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

## 23. `se100.def.NeutralityByDesign` — Neutrality by Design

- Kind: `definition`
- Source lines: `1024-1041`

```latex
\begin{definition}[Neutrality by Design]
  \label{se100.def.NeutralityByDesign}
  A substrate $\Substrate$ is \emph{neutral}
  if it satisfies interpretive non-commitment
  (\DefRef{se100.def.InterpretiveNonCommitment}{Interpretive Non-Commitment})
  and extension stability
  (\DefRef{se100.def.ExtensionStability}{Extension Stability}).

  $\Substrate$ is \emph{neutral by design} if its neutrality is guaranteed
  at design time for every admissible framework in $\Frameworks$,
  including admissible frameworks not known when the substrate is designed
  (\NoteRef{se100.note.FrameworkClass}{The Framework Class $\Frameworks$}).
  The design-time guarantee must follow from
  the membership of the foundational layer in the permitted classes:
  the referential commitments $\SubstrateRef$ and
  permitted attribution propositions.
  It must not rest on enumerating admissible frameworks.
\end{definition}
```

## 24. `se100.constraint.Neutrality` — Neutrality

- Kind: `constraint`
- Source lines: `1050-1067`

```latex
\begin{constraint}[Neutrality]
  \label{se100.constraint.Neutrality}
  Let $\Substrate$ be a substrate intended
  to remain usable by every admissible framework,
  including admissible frameworks not known when the substrate is designed.
  Assume
  \AssumpRef{se100.assump.Contestability}{Contestability} and
  \AssumpRef{se100.assump.ReferentialCommonGround}{Referential Common Ground}.
  Then $\Substrate$'s neutrality is guaranteed at design time
  in the sense of \DefRef{se100.def.NeutralityByDesign}{Neutrality by Design}
  if and only if its foundational layer is restricted to
  the referential commitments $\SubstrateRef$
  and permitted attribution propositions
  (\DefRef{se100.def.PermittedAttributionProposition}{Permitted Attribution Proposition}).
  In particular, $\Substrate$ makes no object-level causal or normative commitment
  (\DefRef{se100.def.ObjectLevelCausalNormativeCommitment}
  {Object-Level Causal or Normative Commitment}).
\end{constraint}
```

## 25. `se100.example.ReificationFragment` — Reification Fragment

- Kind: `example`
- Source lines: `1219-1225`

```latex
\begin{example}[Reification Fragment]
  \label{se100.example.ReificationFragment}
  Consider a decision record concerning an automated eligibility denial.
  The record involves a subject $u$, a decision $d$, a model or instrument $m$,
  a timestamp $t$, an institutional policy $r$, and
  a claim asserted by source framework $\Framework$.
\end{example}
```
