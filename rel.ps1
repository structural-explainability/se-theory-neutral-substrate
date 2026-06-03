#Requires -Version 7.0

<#
Run the validation sequence for se-theory-neutral-substrate.

This repository is a Lean/reference repository that consumes
se-theory-reference-kit. It does not build or publish a local Python package.
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
# C) Theory-reference validation and generated artifacts
# ============================================================

Invoke-Step "C1) Inspect resolved theory-reference declarations" "uv run se-theory-reference inspect" {
    uv run se-theory-reference inspect
}

Invoke-Step "C2) Validate reference artifacts against declared Lean public surface" "uv run se-theory-reference validate" {
    uv run se-theory-reference validate
}

Invoke-Step "C3) Run strict reference validation" "uv run se-theory-reference validate --strict" {
    uv run se-theory-reference validate --strict
}

Invoke-Step "C4) Regenerate JSON artifacts from reference TOML" "uv run se-theory-reference export" {
    uv run se-theory-reference export
}

Invoke-Step "C5) Confirm generated JSON artifacts are current without writing files" "uv run se-theory-reference export --check" {
    uv run se-theory-reference export --check
}

Invoke-Step "C6) Build or refresh generated reference catalog" "uv run se-theory-reference catalog" {
    uv run se-theory-reference catalog
}

Invoke-Step "C7) Confirm generated reference catalog is current" "uv run se-theory-reference catalog --check" {
    uv run se-theory-reference catalog --check
}

Invoke-Step "C8) Validate SE manifest against the published manifest schema" "uvx se-manifest-schema validate-manifest --path SE_MANIFEST.toml --strict" {
    uvx se-manifest-schema validate-manifest --path SE_MANIFEST.toml --strict
}

# ============================================================
# D) Pre-commit
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

# ============================================================
# E) Documentation
# ============================================================

Invoke-Step "E1) Build documentation" "uv run python -m zensical build" {
    uv run python -m zensical build
}

# ============================================================
# F) Final repository status
# ============================================================

Invoke-Step "F1) Show git status" "git status --short" {
    git status --short
}

Write-Host ""
Write-Host "============================================================"
Write-Host "Repository validation completed successfully."
Write-Host "============================================================"
