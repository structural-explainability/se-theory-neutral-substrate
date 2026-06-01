#Requires -Version 7.0

<#
Run the release validation sequence for se-theory-neutral-substrate.

The script echoes each exact command before running it.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Invoke-Step {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Section,

        [Parameter(Mandatory = $true)]
        [string]$Command,

        [Parameter(Mandatory = $true)]
        [scriptblock]$Script
    )

    Write-Host ""
    Write-Host "============================================================"
    Write-Host $Section
    Write-Host "============================================================"
    Write-Host $Command
    & $Script
}

# ============================================================
# A) Toolchain refresh
# ============================================================

Invoke-Step "A1) Update elan" "elan self update" {
    elan self update
}

Invoke-Step "A2) Update Lake dependencies" "lake update" {
    lake update
}

Invoke-Step "A3) Sync Python tooling" "uv sync --extra dev --extra docs --upgrade" {
    uv sync --extra dev --extra docs --upgrade
}

Invoke-Step "A4) Install pre-commit hooks" "uvx pre-commit install" {
    uvx pre-commit install
}

# ============================================================
# B) Lean build and tests
# ============================================================

Invoke-Step "B1) Build Lean library" "lake build" {
    lake build
}

Invoke-Step "B2) Build Lean test surface" "lake build TestAll" {
    lake build TestAll
}

# ============================================================
# C) Reference validation and generated artifacts
# ============================================================

Invoke-Step "C1) Validate reference TOML against Lean symbols and public-surface coverage" "uv run se-ref-validate" {
    uv run se-ref-validate
}

Invoke-Step "C2) Regenerate JSON artifacts from reference TOML" "uv run se-ref-export" {
    uv run se-ref-export
}

Invoke-Step "C3) Confirm generated JSON artifacts are current without writing files" "uv run se-ref-export --check" {
    uv run se-ref-export --check
}

Invoke-Step "C4) Run full repo validation gate: strict reference validation plus generated-export freshness check" "uv run se-validate --strict" {
    uv run se-validate --strict
}

Invoke-Step "C5) Validate SE manifest against the published manifest schema" "uvx --from se-manifest-schema se-manifest validate-manifest --strict" {
    uvx --from se-manifest-schema se-manifest validate-manifest --strict
}

# ============================================================
# D) Pre-commit and Python tests
# ============================================================

Invoke-Step "D1) Stage all changes so pre-commit sees tracked/staged files" "git add -A" {
    git add -A
}

Invoke-Step "D2) Run pre-commit checks" "uvx pre-commit run --all-files" {
    uvx pre-commit run --all-files
}

Invoke-Step "D3) Run pre-commit checks again after autofixes" "uvx pre-commit run --all-files" {
    uvx pre-commit run --all-files
}

Invoke-Step "D4) Run Python tests" "uv run python -m pytest" {
    uv run python -m pytest
}

Invoke-Step "D5) Run Pyright" "uv run python -m pyright" {
    uv run python -m pyright
}

Invoke-Step "D6) Run final pre-commit check after tests/type checks" "uvx pre-commit run --all-files" {
    uvx pre-commit run --all-files
}

# ============================================================
# E) Documentation
# ============================================================

Invoke-Step "E1) Build documentation" "uv run python -m zensical build" {
    uv run python -m zensical build
}

# ============================================================
# F) Architectural and code-health checks
# ============================================================

Invoke-Step "F1) Run import-linter contract checks" "uvx --with-editable . import-linter lint" {
    uvx --with-editable . import-linter lint
}

Invoke-Step "F2) Find dead code" "uvx --with-editable . vulture src/se_theory_neutral_substrate" {
    uvx --with-editable . vulture src/se_theory_neutral_substrate
}

Invoke-Step "F3) Check complexity; any output means C-or-worse complexity exists" "uvx radon cc src/se_theory_neutral_substrate -s -a -n C" {
    uvx radon cc src/se_theory_neutral_substrate -s -a -n C
}

Invoke-Step "F4) Report raw code metrics" "uvx radon raw src/se_theory_neutral_substrate -j | uv run python -c `"import json, sys; data=json.load(sys.stdin); keys=('loc','lloc','sloc','comments','multi','blank','single_comments'); totals={k:sum(file[k] for file in data.values()) for k in keys}; print('\n'.join(f'{k.upper()}: {v}' for k,v in totals.items()))`"" {
    uvx radon raw src/se_theory_neutral_substrate -j | uv run python -c "import json, sys; data=json.load(sys.stdin); keys=('loc','lloc','sloc','comments','multi','blank','single_comments'); totals={k:sum(file[k] for file in data.values()) for k in keys}; print('\n'.join(f'{k.upper()}: {v}' for k,v in totals.items()))"
}

# ============================================================
# G) Distribution artifacts
# ============================================================

Invoke-Step "G1) Build source and wheel distributions" "uv build" {
    uv build
}

# Invoke-Step "G2) Check distribution metadata" "uvx twine check dist/*" {
#     uvx twine check dist/*
# }

Write-Host ""
Write-Host "============================================================"
Write-Host "Release validation completed successfully."
Write-Host "============================================================"
