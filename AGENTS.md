# ./AGENTS.md

## Scope

- Changes must preserve:
  - determinism
  - cross-platform compatibility
  - data-driven definitions
- Do not introduce hidden logic where declarative structure is possible.
- Prefer explicit, inspectable structure over implicit behavior.

## Formal Contract Constraints

- Files under `data/contract/` are **generated artifacts**.
- Do **not** edit JSON contract registries manually.
- All contract artifacts must be produced via:

```shell
lake exe export_contract
```

- The Lean surface (`NeutralSubstrate/*.lean`) is the **authoritative source of structural constraints**.
- Python code may **serialize and validate**, but must not redefine contract semantics.

## WHY

- This repo defines the **formal contract layer** for the SE ecosystem.
- Operational repositories depend on these exported artifacts.
- Divergence between Lean, export, and JSON invalidates the contract.

## Requirements

- Use **uv** for all environment, dependency, and run commands.
- Do **not** recommend or use `pip install ...` as the primary workflow.
- The canonical Python version is defined in `.python-version`.
- Commands must work on Windows, macOS, and Linux.
- If shell-specific commands are unavoidable, provide both:
  - PowerShell (Windows)
  - bash/zsh (macOS/Linux)

## Quickstart

```shell
uv self update
uv python pin $(cat .python-version)
uv sync --extra dev --extra docs --upgrade
```

## Common Tasks

### Export contract artifacts

```shell
lake update
lake build
lake exe export_contract
```

### Validate contract artifacts

```shell
uv run python -m se_theory validate
```

### Lint / format

```shell
uv run python -m ruff format .
uv run python -m ruff check . --fix
```

### Build documentation

```shell
uv run python -m zensical build
```

## pre-commit

- pre-commit runs only on tracked / staged files.
- Developers should `git add -A` before expecting hooks to run.

## Non-goals

- This repository does **not** define:
  - operational validation pipelines
  - domain mappings
  - runtime systems
  - interpretation semantics

- Those belong to downstream SE repositories.
