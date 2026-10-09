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

Import the public theory surface:

```lean
import SE.NeutralSubstrate
```

## Lean Module Convention

Production Lean code uses the `SE.*` namespace.

- `SE.lean` is the repository production entry point.
- `SE/<Project>.lean` is the project public import surface.
- Production modules live under `SE/<Project>/`.

Test Lean code uses the `SETest.*` namespace.

- `SETest.lean` is the repository test entry point.
- `SETest/<Project>.lean` is the project test surface.
- Test modules live under `SETest/<Project>/`.

`Spec.lean` is used when the project defines a specification module.

## Theory Structure

```mermaid
flowchart TD
    A["Propositional Language"] --> B["Commitment Theory and Consequence"]
    B --> C["Frameworks, Referent Carriers, Referential Regimes, and Substrates"]
    C --> D["Referential Commitments"]
    D --> E["Classification, Attribution, and Interpretation"]
    E --> F["Framework-Relative Properties"]
    F --> G["Contestability and Referential Common Ground"]
    G --> H["Interpretive Non-Commitment and Extension Stability"]
    H --> I["Neutrality by Design"]
    I --> J["Neutrality Constraint"]
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

Maintain:

- `formalization\source\se100-lean-basis.md` - from the paper
- `lakefile.toml`
- `lean-toolchain`
- `reference/theory-reference.toml` - hand-maintained configuration
- `reference/*.toml` - hand-maintained/scaffolded reference source artifacts
- Lean source + RR comments - hand-maintained theory source

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

# inspect shared theory-reference command surface
uvx se-theory-reference-kit@latest --help
uvx se-theory-reference-kit@latest validate --help
uvx se-theory-reference-kit@latest scaffold --help
uvx se-theory-reference-kit@latest export --help
uvx se-theory-reference-kit@latest catalog --help
uvx se-theory-reference-kit@latest inspect --help

# validate reference artifacts against the declared Lean public surface
uvx se-theory-reference-kit@latest validate
uvx se-theory-reference-kit@latest validate --strict

# scaffold reference artifacts from Lean public declarations
uvx se-theory-reference-kit@latest scaffold
uvx se-theory-reference-kit@latest scaffold --dry-run
uvx se-theory-reference-kit@latest scaffold --overwrite

# regenerate or check generated JSON artifacts from reference TOML
uvx se-theory-reference-kit@latest export
uvx se-theory-reference-kit@latest export --check

# build or verify the generated reference catalog
uvx se-theory-reference-kit@latest catalog
uvx se-theory-reference-kit@latest catalog --check

# inspect resolved repository configuration and reference declarations
uvx se-theory-reference-kit@latest inspect

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

[MIT](./LICENSE)

## Repository Manifest

[SE_MANIFEST.toml](./SE_MANIFEST.toml) -
repository semantic ownership/scope

## Reference

[reference/](./reference/) -
public-surface classification and traceability
