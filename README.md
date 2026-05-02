# SE Theory: Neutral Substrate

[![Docs Site](https://img.shields.io/badge/docs-site-blue?logo=github)](https://structural-explainability.github.io/se-theory-neutral-substrate/)
[![Repo](https://img.shields.io/badge/repo-GitHub-black?logo=github)](https://github.com/structural-explainability/se-theory-neutral-substrate)
[![Tooling](https://img.shields.io/badge/python-3.15%2B-blue?logo=python)](./pyproject.toml)
[![License](https://img.shields.io/badge/license-MIT-yellow.svg)](./LICENSE)

[![CI-Lean](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-lean.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-lean.yml)
[![CI](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-python-zensical.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-python-zensical.yml)
[![Docs](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/deploy-zensical.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/deploy-zensical.yml)
[![Links](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/links.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/links.yml)

> Lean 4 formalization of the neutral structural substrate of Structural Explainability.

Defines admissibility conditions for identity-regime application
without encoding identity, persistence, domain semantics,
or operational behavior.

## Owns

- Neutral structural primitives
- Substrate well-formedness
- Admissibility conditions
- Separation constraints (non-encoding)
- Substrate-level invariants
- Machine-checked theorems

## Does not own

- Identity regimes
- Regime profiles
- Persistence behavior
- Mapping semantics
- Domain examples
- Operational validation
- Runtime systems

## Design Constraints

- Lean is the only source of truth for correctness
- No executable entry points
- No exported runtime artifacts
- No cross-repo coupling beyond imports
- All guarantees are expressed as theorems

## Documentation Constraints

- The documentation layer is descriptive only.
- Documentation sections must mirror Lean module structure.

### Authority

- Lean source files are the only authoritative definition of:
  - types
  - predicates
  - theorems
  - proof obligations

- Documentation must not introduce or redefine formal semantics.

### Prohibited in docs

- Restating formal definitions in alternative form
- Introducing new terminology not present in Lean
- Encoding rules or invariants not present in Lean
- Diverging naming from Lean modules

### Allowed in docs

- Explanatory summaries
- Structural descriptions
- Navigation and orientation
- Non-authoritative theorem descriptions

## Import

Single import surface:

```lean
import NeutralSubstrate
```

## Build

```shell
elan self update
lake update
lake build
lake build TestBasic
lake build TestRegime
```

## Tooling

Python and other tooling may be used for:

- documentation generation
- formatting and linting
- repository automation

They must not:

- define correctness
- validate theory semantics
- replace Lean proofs

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

uvx pre-commit install

git add -A
uvx pre-commit run --all-files
# repeat if changes were made
git add -A
uvx pre-commit run --all-files

uv run python -m se_theory_neutral_substrate validate
uv run python -m se_theory_neutral_substrate validate --strict
uv run python -m se_theory_neutral_substrate validate --require-tag

uv run python -m se_theory_neutral_substrate sync

uv run python -m se_theory_neutral_substrate scaffold
uv run python -m se_theory_neutral_substrate scaffold --dry-run
uv run python -m se_theory_neutral_substrate scaffold --overwrite

uv run python -m se_theory_neutral_substrate ref-validate
uv run python -m se_theory_neutral_substrate ref-validate --strict

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
