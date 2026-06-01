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

For the full documentation, see [`docs/en/index.md`](./docs/en/index.md).

## Authority

Lean source files are authoritative for formal definitions, predicates, axioms,
theorems, proof obligations, and reference rules.

Reference artifacts under `reference/` and generated artifacts under
`data/neutral-substrate/` mirror the Lean public surface.
They do not define theory semantics independently of Lean.

## Import

Downstream Lean projects should import the public surface:

```text
import SE.NeutralSubstrate
```

The public import surface is curated in:

```text
SE.NeutralSubstrate.lean
SE.NeutralSubstrate/Surface.lean
```

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

```shell
elan self update
lake update

uv self update
uv python pin 3.15
uv sync --extra dev --extra docs --upgrade

# install git hooks once per clone
uvx pre-commit install

# build Lean (source of truth)
lake build
lake build TestAll

# Validate reference TOML against Lean symbols and public-surface coverage.
uv run se-ref-validate --strict
# Getting a warn lean_symbol declared as 'abbrev' for 'Ontology'` is ok.

# Regenerate JSON artifacts from reference TOML.
uv run se-ref-export

# Confirm generated JSON artifacts are current.
uv run se-ref-export --check

# Run the full repo validation gate:
# strict reference validation plus generated-export freshness check.
uv run se-validate --strict

# validate manifest file
uvx --from se-manifest-schema se-manifest validate-manifest --strict

# fix issues
git add -A
uvx pre-commit run --all-files
# repeat if changes were made
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
