




#Requires -Version 7.3

<#
Run the repository release-validation sequence.
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

    $allowsNonzeroExit = @(
        $AllowedExitCodes | Where-Object { $_ -ne 0 }
    ).Count -gt 0

    if (-not $allowsNonzeroExit) {
        # WHY: Preserve normal fail-fast behavior for strict steps.
        & $Script
        return
    }

    $oldNativeErrorPreference = $PSNativeCommandUseErrorActionPreference
    $exitCode = 0

    try {
        # WHY: Explicitly advisory steps may report findings without stopping
        # the release-validation sequence.
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
# === C) Theory-reference inspection and initial generation ===
# ============================================================

Invoke-Step `
    "C1) Inspect resolved theory-reference declarations" `
    "uvx se-theory-reference-kit@latest inspect" {
    uvx se-theory-reference-kit@latest inspect
}

Invoke-Step `
    "C2) Regenerate reference JSON artifacts" `
    "uvx se-theory-reference-kit@latest export" {
    uvx se-theory-reference-kit@latest export
}

Invoke-Step `
    "C3) Build generated reference catalog" `
    "uvx se-theory-reference-kit@latest catalog" {
    uvx se-theory-reference-kit@latest catalog
}

# ============================================================
# === E) Final theory-reference generation and validation ===
# ============================================================

Invoke-Step `
    "E1) Regenerate reference JSON artifacts after autofixes" `
    "uvx se-theory-reference-kit@latest export" {
    uvx se-theory-reference-kit@latest export
}

Invoke-Step `
    "E2) Rebuild generated reference catalog after autofixes" `
    "uvx se-theory-reference-kit@latest catalog" {
    uvx se-theory-reference-kit@latest catalog
}

Invoke-Step `
    "E3) Confirm generated JSON artifacts are current" `
    "uvx se-theory-reference-kit@latest export --check" {
    uvx se-theory-reference-kit@latest export --check
}

Invoke-Step `
    "E4) Confirm generated reference catalog is current" `
    "uvx se-theory-reference-kit@latest catalog --check" {
    uvx se-theory-reference-kit@latest catalog --check
}

Invoke-Step `
    "E5) Validate reference artifacts" `
    "uvx se-theory-reference-kit@latest validate" {
    uvx se-theory-reference-kit@latest validate
}

Invoke-Step `
    "E6) Run strict reference validation" `
    "uvx se-theory-reference-kit@latest validate --strict" {
    uvx se-theory-reference-kit@latest validate --strict
}

Invoke-Step `
    "E7) Inspect final resolved declarations" `
    "uvx se-theory-reference-kit@latest inspect" {
    uvx se-theory-reference-kit@latest inspect
}

Invoke-Step `
    "E8) Validate repository manifest" `
    "uvx se-manifest-schema validate-manifest --strict" {
    uvx se-manifest-schema validate-manifest --strict
}

Invoke-Step "E9) Stage final generated artifacts" "git add -A" {
    git add -A
}

# ============================================================
# === G) Final repository status ===
# ============================================================

Invoke-Step "G1) Show repository status" "git status --short" {
    git status --short
}

Write-Host ""
Write-Host "============================================================"
Write-Host "Repository validation completed successfully."
Write-Host "============================================================"
