# SE Theory: Neutral Substrate

[![Docs Site](https://img.shields.io/badge/docs-site-blue?logo=github)](https://structural-explainability.github.io/se-theory-neutral-substrate/)
[![Repo](https://img.shields.io/badge/repo-GitHub-black?logo=github)](https://github.com/structural-explainability/se-theory-neutral-substrate)
[![Tooling](https://img.shields.io/badge/python-3.15%2B-blue?logo=python)](./pyproject.toml)
[![License](https://img.shields.io/badge/license-Apache--2.0-yellow.svg)](./LICENSE)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.21694487.svg)](https://doi.org/10.5281/zenodo.21694487)

[![CI-Lean](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-lean.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-lean.yml)
[![CI](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-python-zensical.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/ci-python-zensical.yml)
[![Docs](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/deploy-zensical-lean.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/deploy-zensical-lean.yml)
[![Links](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/links.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-neutral-substrate/actions/workflows/links.yml)
[![Dependabot](https://img.shields.io/badge/Dependabot-enabled-brightgreen.svg)](https://github.com/structural-explainability/se-theory-neutral-substrate/security)

> Lean 4 formalization of the neutral structural substrate of
> Structural Explainability.

Scope and exclusions are defined in [SE_MANIFEST.toml](./SE_MANIFEST.toml).
The Lean source states what is proved and under which assumptions.
This library states neutrality conditions in the abstract;
it does not certify any concrete realization,
which must justify its own referential
fixing and framework compatibility.

## Authority

Lean source files are authoritative for formal definitions, predicates, axioms,
theorems, proof obligations, and reference rules.

Reference artifacts under `reference/` and generated artifacts under
`data/` mirror the Lean public surface.
They do not define theory semantics independently of Lean.

The CI-Lean workflow builds the declared public Lean surface with
`lake build --wfail`,
failing on reported warnings, including `sorry`.
Successful compilation verifies formal declarations against their
stated assumptions; it does not establish the scientific adequacy
of those assumptions or interpretations.
Recorded doubts about them are in [DOUBTS.md](./DOUBTS.md).

## Import

Import the public theory surface:

```lean
import SE.NeutralSubstrate
```

## Developer

Maintain:

- `scripts/get-basis.ps1` update `$ExpectedItemCount` from the paper
- `formalization/source/se100-lean-basis.md` - from the paper
- `lakefile.toml`
- `lean-toolchain`
- `reference/theory-reference.toml` - hand-maintained configuration
- `reference/*.toml` - reference source artifacts
- Lean source and RR traceability comments (`-- RR.DEFINES`, `-- RR.IMPLEMENTS`) - hand-maintained theory source

### Clone and Open Project in VS Code

Open a machine terminal where you want the project
and open in VS Code:

```shell
git clone https://github.com/structural-explainability/se-theory-neutral-substrate

cd se-theory-neutral-substrate
code .
```

### Setup and Run

Use VS Code Menu:
View / Command Palette / `Developer: Reload Window` to refresh.

```shell
.\sit.ps1
.\rel.ps1

# shared theory-reference tooling: commands and options
uvx se-theory-reference-kit@latest --help

# validate SE manifest file
uvx se-manifest-schema validate-manifest --path SE_MANIFEST.toml --strict

# save progress
git add -A
git commit -m "update"
git push -u origin main
```

## Authority Manifest

[.accountability/surfaces.toml](./.accountability/surfaces.toml)

## Changelog

[CHANGELOG.md](./CHANGELOG.md)

## Citation

[CITATION.cff](./CITATION.cff)

## Documentation

[Documentation](https://structural-explainability.github.io/se-theory-neutral-substrate/) -
descriptive orientation

## Formal Semantics

[Lean](./SE.lean)

## License

[Apache 2.0](./LICENSE)

## Repository Manifest

[SE_MANIFEST.toml](./SE_MANIFEST.toml) -
repository semantic ownership/scope

## Reference

[reference/](./reference/) -
public-surface classification and traceability
