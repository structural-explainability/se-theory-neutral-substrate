# SE Theory: Neutral Substrate

[![Docs Site](https://img.shields.io/badge/docs-site-blue?logo=github)](https://structural-explainability.github.io/se-theory-neutral-substrate/)
[![Repo](https://img.shields.io/badge/repo-GitHub-black?logo=github)](https://github.com/structural-explainability/se-theory-neutral-substrate)
[![Tooling](https://img.shields.io/badge/python-3.15%2B-blue?logo=python)](./pyproject.toml)
[![License](https://img.shields.io/badge/license-MIT-yellow.svg)](./LICENSE)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.21694487.svg)](https://doi.org/10.5281/zenodo.21694487)

[![CI-Lean](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-lean.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-lean.yml)
[![CI](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-python-zensical.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-python-zensical.yml)
[![Docs](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/deploy-zensical-lean.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/deploy-zensical-lean.yml)
[![Links](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/links.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/links.yml)
[![Dependabot](https://img.shields.io/badge/Dependabot-enabled-brightgreen.svg)](https://github.com/structural-explainability/se-theory-neutral-substrate/security)

> Lean 4 formalization of the neutral structural substrate of
> Structural Explainability.

This repository defines the formal substrate conditions needed for
Structural Explainability theory.

For full documentation, see [`docs/en/index.md`](./docs/en/index.md).

## Authority

Lean source files are authoritative for formal definitions, predicates, axioms,
theorems, proof obligations, and reference rules.

Reference artifacts under `reference/` declare the repository-owned
classification, traceability, and export intent for the Lean public surface.

Generated artifacts under `data/neutral-substrate/` are outputs.
They do not define theory semantics independently of Lean or the reference artifacts.

The reusable `se-theory-reference-kit` owns the generic validation,
cataloging, inspection, and export machinery.
This repository owns its Lean source, reference declarations, and
generated neutral-substrate artifacts.

## Import

Downstream Lean projects should import the public surface:

```text
import SE
```

There are currently:

```text
predicate: 31
requirement: 25
theorem: 54
type: 18
```

## Dependencies

```text
Propositional Language
        ↓
Commitment Theory and Consequence
        ↓
Frameworks, Referents, and Substrates
        ↓
Referential Commitments
        ↓
Classification, Attribution, and Interpretation
        ↓
Framework-Relative Properties
        ↓
Contestability and Referential Common Ground
        ↓
Interpretive Non-Commitment and Extension Stability
        ↓
Neutrality by Design
        ↓
Neutrality Constraint
```

## Implementation

```text
SE.lean  # Curated public import surface

SE/
├── Logic/
│   ├── Language/
│   │   ├── PropositionCarrier.lean  # AUX-001 Proposition Carrier
│   │   ├── Negation.lean            # AUX-002 Negation
│   │   ├── Bottom.lean              # AUX-003 Contradiction / Bottom
│   │   └── Basic.lean               # Composition
│   │
│   ├── Theory/
│   │   ├── CommitmentTheory.lean  # AUX-004 Commitment Theory
│   │   └── TheoryExtension.lean   # AUX-007 Theory Extension
│   │
│   ├── Consequence.lean  # AUX-005 Entailment
│   └── Consistency.lean  # AUX-006 Consistency
│
├── Framework/
│   ├── Basic.lean        # AUX-008 Framework
│   ├── Admissible.lean   # 09 Admissible Framework
│   └── Class.lean        # 10 Framework Class
│
├── Referent/
│   └── Carriers.lean     # AUX-010 Referent Carriers
│
├── Substrate/
│   ├── ReferentialRegime.lean        # 07 Referential Regime
│   ├── Basic.lean                    # 01 Substrate
│   ├── Commitment.lean               # 02 Substrate Commitment
│   └── ReferentialCommitments.lean   # 08 Referential Commitments
│
└── NeutralSubstrate/
    ├── Classification/
    │   ├── CausalNormative.lean             # 03 Causal or Normative
    │   └── ContestedCausalOrNormative.lean  # 15 Contested C or N Proposition
    │
    ├── Interpretation/
    │   ├── ObjectLevelProposition.lean
    │   │   # 05 Object-Level Interpretive Proposition
    │   └── ObjectLevelCausalOrNormativeCommitment.lean
    │       # 06 Object-Level C or N Commitment
    │
    ├── Attribution/
    │   ├── Basic.lean         # 04 Attribution Proposition
    │   ├── Permitted.lean     # 11 Permitted Attribution Proposition
    │   └── CommonGround.lean  # 18 Attribution and Common Ground
    │
    ├── FrameworkRelative/
    │   ├── Variant.lean                  # 12 Framework-Variant Proposition
    │   ├── Invariant.lean                # 13 Framework-Invariant Proposition
    │   └── CompatibleCommitmentSet.lean  # 14 Framework-Compatible Commitment Set
    │
    ├── Assumptions/
    │   ├── Contestability.lean           # 16 Contestability
    │   ├── ReferentialCommonGround.lean  # 17 Referential Common Ground
    │   └── SubstrateConsistency.lean     # 21 Substrate Consistency
    │
    ├── Neutrality/
    │   ├── InterpretiveNonCommitment.lean  # 19 Interpretive Non-Commitment
    │   ├── ExtensionStability.lean         # 20 Extension Stability
    │   ├── PropertyRelation.lean           # 22 Relation Between the Properties
    │   └── ByDesign.lean                   # 23 Neutrality by Design
    │
    ├── Examples/
    │   └── ReificationFragment.lean  # 25 Reification Fragment
    │
    ├── DesignTimeGuarantee.lean  # AUX-009 Design-Time Guarantee
    ├── Constraint.lean           # 24 Neutrality Constraint
    └── Spec.lean                 # Stable SE-100 citation identifiers
```

Approximate implementation order:

```text
AUX-001 through AUX-008
09, 10
07, 01, 02, 08
03, 04, 05, 06
11
12, 13, 14
15
AUX-009
16, 17, 18
19, 20, 21, 22
23
24
25
```

## Tests

```text
SETest.lean  # Lake test driver

SETest/
└── NeutralSubstrate.lean
    # Complete import inventory for Neutral Substrate test modules

SETest/NeutralSubstrate/
├── Logic/
├── Framework/
├── Referent/
├── Substrate/
├── Classification/
├── Attribution/
├── Interpretation/
├── FrameworkRelative/
├── Assumptions/
├── Neutrality/
├── DesignTimeGuarantee.lean
├── Constraint.lean
└── Spec.lean
```

## Reference Configuration

The theory-reference workflow is configured by:

```text
reference/theory-reference.toml
```

That file declares this repository's Lean public modules,
reference artifact layout, export targets, and validation commands.
Public symbols are declared in the reference artifacts.

## Developer

- Maintain `lakefile.toml` and `lean-toolchain`.

## Command Reference

<details>
<summary>Show command reference</summary>

### In a machine terminal

Open a machine terminal where you want the project:

```shell
git clone https://github.com/structural-explainability/se-theory-neutral-substrate

cd se-theory-neutral-substrate
code .
```

### In a VS Code terminal

Use VS Code Menu:
View / Command Palette / `Developer: Reload Window` to refresh.

```pwsh
.\rel.ps1
```

```shell
# save progress
git add -A
git commit -m "update"
git push -u origin main
```

### Inspect Theory-Reference Commands

```shell
uv run --locked se-theory-reference --help
uv run --locked se-theory-reference validate --help
uv run --locked se-theory-reference export --help
uv run --locked se-theory-reference catalog --help
uv run --locked se-theory-reference inspect --help
```

### Repair Dependency State

Use only when the normal update and build commands cannot repair the workspace:

```powershell
Remove-Item -Recurse -Force .\.lake\packages\mathlib `
    -ErrorAction SilentlyContinue

Remove-Item -Force .\lake-manifest.json `
    -ErrorAction SilentlyContinue

lake update
lake exe cache get
```

</details>

## Authority Manifest

[.accountability/surfaces.toml](./.accountability/surfaces.toml)

## Citation

[CITATION.cff](./CITATION.cff)

## License

[MIT](./LICENSE)

## Repository Manifest

[SE_MANIFEST.toml](./SE_MANIFEST.toml)
