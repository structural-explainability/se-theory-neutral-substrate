# ============================================================
# scripts/get-basis.ps1
# ============================================================
# Downloads the authoritative SE-100 Lean formalization basis
# from the Paper 100 repository.
#
# Destination:
#   formalization/source/se100-lean-basis.md
#
# Run from anywhere:
#   pwsh .\scripts\get-basis.ps1
# ============================================================

$ErrorActionPreference = "Stop"

$BasisUrl = (
    "https://raw.githubusercontent.com/" +
    "structural-explainability/" +
    "paper-100-neutral-substrate/" +
    "refs/heads/main/" +
    "se100-lean-basis.md"
)

# The script is in:
#
#   <repository-root>/scripts/get-basis.ps1
#
# Therefore, the parent of $PSScriptRoot is the repository root.
$RepositoryRoot = Split-Path -Parent $PSScriptRoot

$DestinationDirectory = Join-Path `
    $RepositoryRoot `
    "formalization/source"

$DestinationPath = Join-Path `
    $DestinationDirectory `
    "se100-lean-basis.md"

$TemporaryPath = Join-Path `
    $DestinationDirectory `
    "se100-lean-basis.download.md"

# ============================================================
# === CREATE DESTINATION DIRECTORY ===
# ============================================================

New-Item `
    -ItemType Directory `
    -Path $DestinationDirectory `
    -Force |
    Out-Null

# Remove any incomplete download left by an earlier failed run.
if (Test-Path -LiteralPath $TemporaryPath) {
    Remove-Item -LiteralPath $TemporaryPath -Force
}

# ============================================================
# === DOWNLOAD ===
# ============================================================

Write-Host ""
Write-Host "Downloading the authoritative SE-100 Lean basis..."
Write-Host ""
Write-Host "Source:"
Write-Host "  $BasisUrl"
Write-Host ""
Write-Host "Temporary file:"
Write-Host "  $TemporaryPath"
Write-Host ""

try {
    Invoke-WebRequest `
        -Uri $BasisUrl `
        -OutFile $TemporaryPath `
        -ErrorAction Stop
}
catch {
    if (Test-Path -LiteralPath $TemporaryPath) {
        Remove-Item -LiteralPath $TemporaryPath -Force
    }

    throw "Unable to download the SE-100 Lean basis. $($_.Exception.Message)"
}

# ============================================================
# === VALIDATE DOWNLOAD ===
# ============================================================

if (-not (Test-Path -LiteralPath $TemporaryPath -PathType Leaf)) {
    throw "The download did not create the expected temporary file."
}

$DownloadedFile = Get-Item -LiteralPath $TemporaryPath

if ($DownloadedFile.Length -eq 0) {
    Remove-Item -LiteralPath $TemporaryPath -Force
    throw "The downloaded basis file is empty."
}

$Content = Get-Content `
    -LiteralPath $TemporaryPath `
    -Raw `
    -Encoding utf8

if ($Content -notmatch '(?m)^# SE-100 Lean Formalization Basis\s*$') {
    Remove-Item -LiteralPath $TemporaryPath -Force

    throw (
        "The downloaded file does not contain the expected " +
        "SE-100 Lean Formalization Basis heading."
    )
}

$PaperIds = @(
    [regex]::Matches(
        $Content,
        'se100\.(?:def|note|assump|remark|constraint|example)\.[A-Za-z0-9]+'
    ) |
        ForEach-Object Value |
        Sort-Object -Unique
)

$ExpectedItemCount = 25

if ($PaperIds.Count -ne $ExpectedItemCount) {
    Remove-Item -LiteralPath $TemporaryPath -Force

    throw (
        "Expected $ExpectedItemCount unique SE-100 paper IDs, " +
        "but found $($PaperIds.Count)."
    )
}

# ============================================================
# === INSTALL LOCAL SNAPSHOT ===
# ============================================================

Move-Item `
    -LiteralPath $TemporaryPath `
    -Destination $DestinationPath `
    -Force

$Hash = Get-FileHash `
    -LiteralPath $DestinationPath `
    -Algorithm SHA256

# ============================================================
# === REPORT ===
# ============================================================

Write-Host ""
Write-Host "SE-100 Lean basis downloaded successfully."
Write-Host ""
Write-Host "Saved to:"
Write-Host "  $DestinationPath"
Write-Host ""
Write-Host "Validated paper IDs:"
Write-Host "  $($PaperIds.Count)"
Write-Host ""
Write-Host "SHA-256:"
Write-Host "  $($Hash.Hash)"
Write-Host ""

Exit 0
