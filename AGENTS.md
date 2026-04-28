# ./AGENTS.md (SE Theory)

## Scope

- Changes must preserve:
  - determinism
  - cross-platform compatibility
  - data-driven definitions
- Do not introduce hidden logic where declarative structure is possible.
- Prefer explicit, inspectable structure over implicit behavior.

## Theory Constraints

- Lean files are the **authoritative source of all formal definitions and theorems**.

- Do **not** introduce:
  - runtime execution paths
  - export pipelines
  - contract artifact generation
  - semantic validation outside Lean

- There is **no executable surface** in theory repositories.

## Documentation Constraints

- Documentation is descriptive only.
- Documentation must mirror Lean module structure.
- Documentation must not:
  - redefine formal semantics
  - introduce new definitions
  - encode invariants not present in Lean
  - diverge from Lean naming

If documentation and Lean differ, **Lean is correct**.

## Python Tooling Constraints

Python may be used only for:

- documentation generation (Zensical)
- repository hygiene (pre-commit, ruff)
- lightweight automation

Python must not:

- define correctness
- validate theory semantics
- interpret Lean results
- export contract artifacts

There must be **no Python application or CLI surface**.

## WHY

- These repositories define the **formal theory layer** of Structural Explainability.
- Correctness is expressed exclusively as **machine-checked Lean theorems**.
- Introducing parallel semantic systems creates drift and invalidates guarantees.

## Requirements

- Use **uv** for all environment and tooling commands.
- Do **not** recommend or use `pip install ...` as the primary workflow.
- The canonical Python version is defined in `.python-version`.
- Commands must work on Windows, macOS, and Linux.

## Quickstart

```shell
uv self update
uv python pin $(cat .python-version)
uv sync --extra dev --extra docs --upgrade
```

## Common Tasks

### Build Lean theory

```shell
elan self update
lake update
lake build
```

### Build documentation

```shell
uv run python -m zensical build
```

## pre-commit

- pre-commit runs only on tracked / staged files.
- Developers should `git add -A` before expecting hooks to run.

## Non-goals

This repository does **not** define:

- identity-regime execution behavior
- operational validation pipelines
- domain mappings
- runtime systems
- contract artifact exports
- interpretation semantics

These belong to downstream SE repositories.
