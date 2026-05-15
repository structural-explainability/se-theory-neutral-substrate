# SE Theory: Neutral Substrate

[![Docs Site](https://img.shields.io/badge/docs-site-blue?logo=github)](https://structural-explainability.github.io/se-theory-neutral-substrate/)
[![Repo](https://img.shields.io/badge/repo-GitHub-black?logo=github)](https://github.com/structural-explainability/se-theory-neutral-substrate)
[![Tooling](https://img.shields.io/badge/python-3.15%2B-blue?logo=python)](./pyproject.toml)
[![License](https://img.shields.io/badge/license-MIT-yellow.svg)](./LICENSE)

[![CI-Lean](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-lean.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-lean.yml)
[![CI](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-python-zensical.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-python-zensical.yml)
[![Docs](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/deploy-zensical.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/deploy-zensical.yml)
[![Links](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/links.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/links.yml)

> Lean 4 formalization of the neutral structural substrate of Structural
> Explainability.

This repository defines the formal substrate conditions needed for Structural
Explainability theory without encoding identity regimes, persistence behavior,
domain semantics, or operational behavior.

It provides the neutral ground on which downstream theory repositories can build.

## Substrate

```text
Neutral substrate definitions are independent of identity regimes.
Regime-specific persistence is evaluated downstream.
```

This repository treats the neutral substrate as a formal theory layer that can
be imported by downstream Structural Explainability repositories.

## Dependencies

This repository is a foundational theory-layer repository for Structural
Explainability.

It should not depend on transformation theory, persistence theory, identity
regimes, or structural-explainability integration theory. Those repositories
consume the neutral substrate, not the reverse.

## Covers

This repository covers:

- neutral structural primitives
- substrate well-formedness vocabulary
- admissibility conditions
- extension stability
- interpretive non-commitment
- separation constraints
- substrate-level invariants
- neutrality axioms
- neutrality theorems
- Lean-side reference identifiers
- machine-readable neutral-substrate contract artifacts
- public Lean import surface

## Owns

This repository owns:

- Lean definitions under `NeutralSubstrate/`
- the public import surface `NeutralSubstrate.lean`
- curated exports in `NeutralSubstrate/Surface.lean`
- canonical citation IDs in `NeutralSubstrate/Spec.lean`
- reference artifacts under `reference/`
- generated neutral-substrate artifacts under `data/neutral-substrate/`
- validation and export tooling for neutral-substrate artifacts
- machine-checked theorems for neutral substrate theory

## Does not own

This repository does not own:

- transformation theory
- persistence theory
- identity regimes
- regime profiles
- regime classification matrices
- regime-specific persistence semantics
- mapping semantics
- accountable entities
- exchange protocols
- domain examples
- operational validation
- runtime systems
- operational policy

## Design Constraints

Lean source files are authoritative for formal definitions, predicates, axioms,
theorems, proof obligations, and reference rules.

Python and generated data may mirror, validate, export, or document the Lean
surface. They must not define theory semantics independently of Lean.

Constructor-level vocabulary is intentionally not duplicated in this README.
See the Lean source files and reference registries for current values.

The neutral substrate must remain upstream of transformation, persistence,
identity-regime, and integration theory.

## Documentation Constraints

Documentation is descriptive only.

It may provide orientation, summaries, and navigation. It must not introduce
formal semantics absent from Lean.

Documentation must not:

- restate formal definitions in alternative form
- introduce new terminology not present in Lean or reference artifacts
- encode rules or invariants not present in Lean
- diverge from Lean module naming

Documentation may provide:

- explanatory summaries
- structural descriptions
- navigation and orientation
- non-authoritative theorem descriptions

## Contents

Primary Lean locations:

```text
NeutralSubstrate/Core.lean
NeutralSubstrate/Spec.lean
NeutralSubstrate/Surface.lean
NeutralSubstrate.lean
```

Reference artifacts mirror the Lean public surface:

```text
reference/
```

Generated neutral-substrate contract artifacts are in:

```text
data/neutral-substrate/
```

## Build

Use VS Code Menu:
View / Command Palette / `Developer: Reload Window` to refresh.

```shell
elan self update
lake update
lake build
lake build TestAll
uv run se-ref-validate
uv run se-ref-export --check
uv run se-validate --strict
uv run python -m pyright
uv run python -m pytest
uv run python -m zensical build
```

## Import

Downstream Lean projects should import the public surface:

```lean
import NeutralSubstrate
```

The public import surface is curated in:

```text
NeutralSubstrate.lean
NeutralSubstrate/Surface.lean
```

## Tooling

Python and other tooling may be used for:

- documentation generation
- formatting and linting
- repository automation
- reference artifact validation
- generated contract export checks

They must not:

- define correctness
- validate theory semantics independently of Lean
- replace Lean definitions or proofs
- introduce downstream theory dependencies

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

```shell
uv self update
uv python pin 3.15
uv sync --extra dev --extra docs --upgrade

# install git hooks once per clone
uvx pre-commit install

# build Lean (source of truth)
lake build
lake build TestAll

# generate/check registry artifacts
uv run se-validate --strict
uv run se-ref-validate
uv run se-ref-export
uv run se-ref-export --check

# autofix and manual fix issues
git add -A
uvx pre-commit run --all-files
# repeat if changes were made
git add -A
uvx pre-commit run --all-files

# do chores
uv run python -m pyright
uv run python -m pytest
uv run python -m zensical build

# save progress
git add -A
git commit -m "update"
git push -u origin main
```

</details>

## Citation

[CITATION.cff](./CITATION.cff)

## License

[MIT](./LICENSE)

## Manifest

[SE_MANIFEST.toml](./SE_MANIFEST.toml)
