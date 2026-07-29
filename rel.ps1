#Requires -Version 7.3

<#
Run the repository release-validation sequence.

This repository is a Lean/reference repository that consumes
se-theory-reference-kit.
It does not build or publish a local Python package.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

function Invoke-Step {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Section,

        [Parameter(Mandatory = $true)]
        [string]$Command,

        [Parameter(Mandatory = $true)]
        [scriptblock]$Script,

        [int[]]$AllowedExitCodes = @(0)
    )

    Write-Host ""
    Write-Host "============================================================"
    Write-Host $Section
    Write-Host "============================================================"
    Write-Host $Command

    $oldNativeErrorPreference = $PSNativeCommandUseErrorActionPreference

    try {
        # WHY: Capture and evaluate native exit codes ourselves so selected
        # advisory commands may report findings without stopping the release.
        $PSNativeCommandUseErrorActionPreference = $false

        & $Script
        $exitCode = $LASTEXITCODE
    }
    finally {
        $PSNativeCommandUseErrorActionPreference = $oldNativeErrorPreference
    }

    if ($exitCode -notin $AllowedExitCodes) {
        throw "$Section failed with exit code $exitCode."
    }

    if ($exitCode -ne 0) {
        Write-Host ""
        Write-Host "Command reported findings with allowed exit code $exitCode."
        Write-Host "Release validation will continue."
    }
}

function Get-ReferenceSnapshot {
    $roots = @(
        (Join-Path $PSScriptRoot "reference")
        (Join-Path $PSScriptRoot "data\neutral-substrate")
    )

    $files = Get-ChildItem `
        -LiteralPath $roots `
        -File `
        -Recurse |
        Sort-Object FullName

    foreach ($file in $files) {
        $relativePath = [System.IO.Path]::GetRelativePath(
            $PSScriptRoot,
            $file.FullName
        )

        $hash = (
            Get-FileHash `
                -LiteralPath $file.FullName `
                -Algorithm SHA256
        ).Hash

        "$relativePath`t$hash"
    }
}

# ============================================================
# === A) Update environment ===
# ============================================================

Invoke-Step "A0) Update elan" "elan self update" {
    elan self update
    elan --version
}


Invoke-Step "A1) Update Lean dependencies" "lake update" {
    lake update
}

Invoke-Step "A2) Lean and lake versions" "lean --version; lake --version" {
    lean --version
    lake --version
}

Invoke-Step "A3) Upgrade Python lockfile" "uv lock --upgrade" {
    uv self update
    uv python pin 3.15
    uv lock --upgrade
}

Invoke-Step `
    "A4) Sync upgraded Python environment" `
    "uv sync --locked --extra dev --extra docs" {
    uv sync --locked --extra dev --extra docs
}

Invoke-Step "A5) Update pre-commit hooks" "uvx pre-commit autoupdate" {
    uvx pre-commit install
    uvx pre-commit autoupdate
}

Invoke-Step "A6) Stage dependency and hook updates" "git add -A" {
    git add -A
}

Invoke-Step `
    "A7) Run pre-commit checks after updates" `
    "uvx pre-commit run --all-files" `
    -AllowedExitCodes @(0, 1) {
    uvx pre-commit run --all-files
}

Invoke-Step `
    "A8) Re-run pre-commit checks after autofixes" `
    "uvx pre-commit run --all-files" {
    uvx pre-commit run --all-files
}


Invoke-Step "A9) Verify Python lockfile" "uv lock --check" {
    uv lock --check
}

Invoke-Step `
    "A10) Verify locked Python environment" `
    "uv sync --locked --extra dev --extra docs" {
    uv sync --locked --extra dev --extra docs
}

Invoke-Step `
    "A11) Show locked Python version" `
    "uv run --locked python --version" {
    uv run --locked python --version
}

# ============================================================
# === B) Lean build and tests ===
# ============================================================

Invoke-Step "B1) Build Lean library" "lake build" {
    lake build
}

Invoke-Step "B2) Run Lean tests" "lake test" {
    lake test
}

Invoke-Step "B3) Run Lean linter" "lake lint" {
    lake lint
}

# ============================================================
# === C) Theory-reference generation and validation ===
# ============================================================

Invoke-Step `
    "C1) Inspect resolved theory-reference declarations" `
    "uv run --locked se-theory-reference inspect" {
    uv run --locked se-theory-reference inspect
}

Invoke-Step `
    "C2) Regenerate reference JSON artifacts" `
    "uv run --locked se-theory-reference export" {
    uv run --locked se-theory-reference export
}

Invoke-Step `
    "C3) Build generated reference catalog" `
    "uv run --locked se-theory-reference catalog" {
    uv run --locked se-theory-reference catalog
}

Invoke-Step `
    "C4) Confirm generated JSON artifacts are current" `
    "uv run --locked se-theory-reference export --check" {
    uv run --locked se-theory-reference export --check
}

Invoke-Step `
    "C5) Confirm generated reference catalog is current" `
    "uv run --locked se-theory-reference catalog --check" {
    uv run --locked se-theory-reference catalog --check
}

Invoke-Step `
    "C6) Validate reference artifacts" `
    "uv run --locked se-theory-reference validate" {
    uv run --locked se-theory-reference validate
}

Invoke-Step `
    "C7) Run strict reference validation" `
    "uv run --locked se-theory-reference validate --strict" {
    uv run --locked se-theory-reference validate --strict
}

Invoke-Step `
    "C8) Inspect final resolved declarations" `
    "uv run --locked se-theory-reference inspect" {
    uv run --locked se-theory-reference inspect
}

Invoke-Step `
    "C9) Validate repository manifest" `
    "uvx se-manifest-schema validate-manifest --strict" {
    uvx se-manifest-schema validate-manifest --strict
}

# ============================================================
# === D) Repository checks ===
# ============================================================

Invoke-Step "D1) Stage generated and validated artifacts" "git add -A" {
    git add -A
}

Invoke-Step `
    "D2) Run pre-commit checks" `
    "uvx pre-commit run --all-files" `
    -AllowedExitCodes @(0, 1) {
    uvx pre-commit run --all-files
}

Invoke-Step `
    "D3) Re-run pre-commit checks after autofixes" `
    "uvx pre-commit run --all-files" {
    uvx pre-commit run --all-files
}

# ============================================================
# === E) Documentation ===
# ============================================================

Invoke-Step `
    "E1) Build Zensical documentation" `
    "uv run --locked python -m zensical build" {
    uv run --locked python -m zensical build
}

# Lean API documentation is built on Ubuntu by the GitHub Pages workflow.

# ============================================================
# === F) Final repository status ===
# ============================================================

Invoke-Step "F1) Show repository status" "git status --short" {
    git status --short
}

Write-Host ""
Write-Host "============================================================"
Write-Host "Repository validation completed successfully."
Write-Host "============================================================"
