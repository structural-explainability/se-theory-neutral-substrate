# ============================================================
# scripts/init-audit.ps1
# ============================================================
# Creates a Lean formalization audit scaffold from an extracted
# paper basis.
#
# The script:
#
# - reads the downloaded basis;
# - verifies the expected number of labeled items;
# - retrieves the source repository commit SHA;
# - computes the local basis SHA-256;
# - preserves the paper order;
# - includes each exact LaTeX basis block;
# - creates auxiliary foundation records;
# - refuses to overwrite an existing audit.
#
# Run from the repository root:
#
#   pwsh .\scripts\init-audit.ps1
#
# The parameters make this script reusable for later papers.
# ============================================================

param(
    [string] $Paper = "SE-100 Neutral Substrates",

    [string] $BasisUrl = (
        "https://raw.githubusercontent.com/" +
        "structural-explainability/" +
        "paper-100-neutral-substrate/" +
        "refs/heads/main/" +
        "se100-lean-basis.md"
    ),

    [string] $PaperRepository = (
        "structural-explainability/" +
        "paper-100-neutral-substrate"
    ),

    [string] $Branch = "main",

    [string] $BasisRelativePath = (
        "formalization/source/" +
        "se100-lean-basis.md"
    ),

    [string] $AuditRelativePath = (
        "formalization/" +
        "se100-lean-audit.md"
    ),

    [int] $ExpectedItemCount = 25
)

$ErrorActionPreference = "Stop"

# ============================================================
# === CURRENT PAPER AUXILIARY FOUNDATION RECORDS ===
# ============================================================
# These are not separately labeled paper contributions.
#
# They are the minimal logical infrastructure needed to state
# the labeled Paper 100 definitions in Lean.
#
# For later papers, replace this array with the auxiliary
# records required by that paper.

$AuxiliaryItems = @(
    [pscustomobject]@{
        Id   = "AUX-001"
        Name = "Proposition Carrier"
    }
    [pscustomobject]@{
        Id   = "AUX-002"
        Name = "Negation"
    }
    [pscustomobject]@{
        Id   = "AUX-003"
        Name = "Contradiction / Bottom"
    }
    [pscustomobject]@{
        Id   = "AUX-004"
        Name = "Commitment Theory"
    }
    [pscustomobject]@{
        Id   = "AUX-005"
        Name = "Entailment"
    }
    [pscustomobject]@{
        Id   = "AUX-006"
        Name = "Consistency"
    }
    [pscustomobject]@{
        Id   = "AUX-007"
        Name = "Theory Extension"
    }
    [pscustomobject]@{
        Id   = "AUX-008"
        Name = "Framework"
    }
)

# ============================================================
# === RESOLVE REPOSITORY PATHS ===
# ============================================================

# This script is stored at:
#
#   <repository-root>/scripts/init-audit.ps1
#
# Therefore, the parent of $PSScriptRoot is the repository root.

$RepositoryRoot = Split-Path -Parent $PSScriptRoot

$BasisPath = Join-Path `
    $RepositoryRoot `
    $BasisRelativePath

$AuditPath = Join-Path `
    $RepositoryRoot `
    $AuditRelativePath

$AuditDirectory = Split-Path -Parent $AuditPath

if (-not (Test-Path -LiteralPath $BasisPath -PathType Leaf)) {
    throw (
        "The local formalization basis was not found:`n" +
        "  $BasisPath`n`n" +
        "Run scripts/get-basis.ps1 first."
    )
}

if (Test-Path -LiteralPath $AuditPath) {
    throw (
        "The audit file already exists and will not be overwritten:`n" +
        "  $AuditPath"
    )
}

New-Item `
    -ItemType Directory `
    -Path $AuditDirectory `
    -Force |
    Out-Null

# ============================================================
# === READ AND PARSE THE BASIS ===
# ============================================================

$BasisContent = Get-Content `
    -LiteralPath $BasisPath `
    -Raw `
    -Encoding utf8

if (
    $BasisContent -notmatch
    '(?m)^# SE-100 Lean Formalization Basis\s*$'
) {
    throw (
        "The local basis does not contain the expected " +
        "formalization-basis heading."
    )
}

# Expected basis item shape:
#
# ## 01. `se100.def.Substrate` — Substrate
#
# - Kind: `definition`
# - Source lines: `502-508`
#
# ```latex
# ...
# ```

$ItemPattern = (
    '(?ms)' +
    '^##\s+(?<number>\d+)\.\s+' +
    '`(?<id>[^`]+)`\s+—\s+' +
    '(?<title>[^\r\n]+)\r?\n' +
    '\r?\n' +
    '- Kind:\s+`(?<kind>[^`]+)`\r?\n' +
    '- Source lines:\s+`(?<lines>[^`]+)`\r?\n' +
    '\r?\n' +
    '```latex\r?\n' +
    '(?<latex>.*?)' +
    '\r?\n```'
)

$Matches = [regex]::Matches(
    $BasisContent,
    $ItemPattern
)

if ($Matches.Count -ne $ExpectedItemCount) {
    throw (
        "Expected $ExpectedItemCount basis items, " +
        "but parsed $($Matches.Count)."
    )
}

$Items = [System.Collections.Generic.List[object]]::new()

foreach ($Match in $Matches) {
    $Items.Add(
        [pscustomobject]@{
            Number      = [int] $Match.Groups["number"].Value
            PaperId     = $Match.Groups["id"].Value.Trim()
            Title       = $Match.Groups["title"].Value.Trim()
            Kind        = $Match.Groups["kind"].Value.Trim()
            SourceLines = $Match.Groups["lines"].Value.Trim()
            Latex       = $Match.Groups["latex"].Value.TrimEnd()
        }
    )
}

# ============================================================
# === VALIDATE ITEM ORDER AND IDENTITIES ===
# ============================================================

$DuplicatePaperIds = @(
    $Items |
        Group-Object -Property PaperId |
        Where-Object Count -gt 1
)

if ($DuplicatePaperIds.Count -gt 0) {
    $Names = (
        $DuplicatePaperIds |
            ForEach-Object Name
    ) -join ", "

    throw "Duplicate paper IDs found in the basis: $Names"
}

for (
    $Index = 0;
    $Index -lt $Items.Count;
    $Index++
) {
    $ExpectedNumber = $Index + 1
    $ActualNumber = $Items[$Index].Number

    if ($ActualNumber -ne $ExpectedNumber) {
        throw (
            "Basis item order is invalid. " +
            "Expected item $ExpectedNumber but found item " +
            "$ActualNumber."
        )
    }
}

# ============================================================
# === READ SOURCE PROVENANCE ===
# ============================================================

$BasisFile = Get-Item -LiteralPath $BasisPath

$BasisHash = (
    Get-FileHash `
        -LiteralPath $BasisPath `
        -Algorithm SHA256
).Hash

$RetrievedUtc = $BasisFile.LastWriteTimeUtc.ToString(
    "yyyy-MM-ddTHH:mm:ssZ"
)

$CommitApiUrl = (
    "https://api.github.com/repos/" +
    $PaperRepository +
    "/commits/" +
    $Branch
)

$Headers = @{
    "Accept"     = "application/vnd.github+json"
    "User-Agent" = "structural-explainability-lean-audit"
}

try {
    $CommitResult = Invoke-RestMethod `
        -Uri $CommitApiUrl `
        -Headers $Headers `
        -Method Get `
        -ErrorAction Stop

    $CommitSha = $CommitResult.sha
}
catch {
    throw (
        "Unable to retrieve the paper repository commit SHA. " +
        $_.Exception.Message
    )
}

if ([string]::IsNullOrWhiteSpace($CommitSha)) {
    throw "The GitHub response did not contain a commit SHA."
}

# ============================================================
# === BUILD THE AUDIT ===
# ============================================================

$Audit = [System.Collections.Generic.List[string]]::new()

# ============================================================
# === HEADER ===
# ============================================================

$Audit.Add("# Lean Formalization Audit")
$Audit.Add("")
$Audit.Add("## Authoritative Basis")
$Audit.Add("")
$Audit.Add(("- Paper: {0}" -f $Paper))
$Audit.Add(('- Basis URL: {0}' -f $BasisUrl))
$Audit.Add(
    ('- Paper repository commit: {0}' -f $CommitSha)
)
$Audit.Add(
    ('- Basis SHA-256: {0}' -f $BasisHash)
)
$Audit.Add(
    ('- Retrieved: {0}' -f $RetrievedUtc)
)
$Audit.Add(
    ("- Labeled paper items: {0}" -f $Items.Count)
)
$Audit.Add("")

$Audit.Add("## Exactness Rule")
$Audit.Add("")
$Audit.Add("The paper basis is authoritative.")
$Audit.Add("")
$Audit.Add("Each labeled paper item must have:")
$Audit.Add("")
$Audit.Add("- an exact canonical Lean representation;")
$Audit.Add(
    "- an exact representation through a proved encoding; or"
)
$Audit.Add("- an explicit unresolved audit verdict.")
$Audit.Add("")
$Audit.Add(
    "No Lean implementation convenience may silently weaken, " +
    "strengthen,"
)
$Audit.Add(
    "specialize, or replace the paper statement."
)
$Audit.Add("")

# ============================================================
# === STATUS VOCABULARY ===
# ============================================================

$Audit.Add("## Audit Verdicts")
$Audit.Add("")
$Audit.Add("Each completed record receives one verdict:")
$Audit.Add("")
$Audit.Add("- Exact")
$Audit.Add("- Exact via proved encoding")
$Audit.Add("- Stronger than paper")
$Audit.Add("- Weaker than paper")
$Audit.Add("- Special case only")
$Audit.Add("- Executable refinement only")
$Audit.Add("- Missing")
$Audit.Add("- Misclassified")
$Audit.Add("- Terminology mismatch")
$Audit.Add("- Dependency mismatch")
$Audit.Add("- Boundary condition missing")
$Audit.Add("- Unresolved")
$Audit.Add("")

# ============================================================
# === AUXILIARY INFRASTRUCTURE ===
# ============================================================

$Audit.Add("## Auxiliary Formal Infrastructure")
$Audit.Add("")
$Audit.Add(
    "These records cover logical infrastructure required to " +
    "state the paper."
)
$Audit.Add("")
$Audit.Add(
    "They are not additional paper contributions. Each must be " +
    "justified by"
)
$Audit.Add(
    "one or more labeled paper items."
)
$Audit.Add("")

foreach ($AuxiliaryItem in $AuxiliaryItems) {
    $Audit.Add(
        (
            "### {0} — {1}" -f
                $AuxiliaryItem.Id,
                $AuxiliaryItem.Name
        )
    )
    $Audit.Add("")
    $Audit.Add(("- Auxiliary ID: {0}" -f $AuxiliaryItem.Id))
    $Audit.Add(("- Name: {0}" -f $AuxiliaryItem.Name))
    $Audit.Add("- Needed by paper items:")
    $Audit.Add("- Mathematical role:")
    $Audit.Add("- Required carrier:")
    $Audit.Add("- Required operations:")
    $Audit.Add("- Required laws:")
    $Audit.Add("- Lean Core candidates:")
    $Audit.Add("- Mathlib candidates:")
    $Audit.Add("- CSLib candidates:")
    $Audit.Add("- Reuse decision:")
    $Audit.Add("- Additional assumptions introduced:")
    $Audit.Add("- Proposed module:")
    $Audit.Add("- Proposed declaration:")
    $Audit.Add("- Proposed signature:")
    $Audit.Add("- Exactness justification:")
    $Audit.Add("- Proof obligations:")
    $Audit.Add("- Test obligations:")
    $Audit.Add("- Audit verdict: Unresolved")
    $Audit.Add("- Status: Not started")
    $Audit.Add("- Reviewer notes:")
    $Audit.Add("")
}

# ============================================================
# === PAPER-ORDER INDEX ===
# ============================================================

$Audit.Add("## Labeled Paper Items")
$Audit.Add("")
$Audit.Add("| # | Paper ID | Kind | Title | Source lines |")
$Audit.Add("| ---: | --- | --- | --- | ---: |")

foreach ($Item in $Items) {
    $SafeTitle = $Item.Title.Replace("|", "\|")

    $Audit.Add(
        (
            '| {0} | `{1}` | {2} | {3} | {4} |' -f
                $Item.Number,
                $Item.PaperId,
                $Item.Kind,
                $SafeTitle,
                $Item.SourceLines
        )
    )
}

$Audit.Add("")

# ============================================================
# === PAPER AUDIT RECORDS ===
# ============================================================

foreach ($Item in $Items) {
    $Audit.Add(
        (
            '## {0:D2}. `{1}` — {2}' -f
                $Item.Number,
                $Item.PaperId,
                $Item.Title
        )
    )
    $Audit.Add("")
    $Audit.Add(("- Paper ID: {0}" -f $Item.PaperId))
    $Audit.Add(("- Paper name: {0}" -f $Item.Title))
    $Audit.Add(
        ("- Paper classification: {0}" -f $Item.Kind)
    )
    $Audit.Add(
        ("- Source lines: {0}" -f $Item.SourceLines)
    )
    $Audit.Add("")
    $Audit.Add("### Exact Paper Statement")
    $Audit.Add("")
    $Audit.Add('```latex')

    foreach ($Line in ($Item.Latex -split "\r?\n")) {
        $Audit.Add($Line)
    }

    $Audit.Add('```')
    $Audit.Add("")
    $Audit.Add("### Formalization Audit")
    $Audit.Add("")
    $Audit.Add("- Paper dependencies:")
    $Audit.Add("- Auxiliary dependencies:")
    $Audit.Add("- Parameters:")
    $Audit.Add("- Quantifiers:")
    $Audit.Add("- Required mathematical carrier:")
    $Audit.Add("- Required operations:")
    $Audit.Add("- Required laws:")
    $Audit.Add("- Required Lean construct:")
    $Audit.Add("- Lean Core candidates:")
    $Audit.Add("- Mathlib candidates:")
    $Audit.Add("- CSLib candidates:")
    $Audit.Add("- Reuse decision:")
    $Audit.Add("- Additional assumptions introduced:")
    $Audit.Add("- Proposed module:")
    $Audit.Add("- Proposed canonical declaration:")
    $Audit.Add("- Proposed signature:")
    $Audit.Add("- Current Lean declaration:")
    $Audit.Add("- Current Lean statement:")
    $Audit.Add("- Semantic comparison:")
    $Audit.Add("- Exactness justification:")
    $Audit.Add("- Proof obligations:")
    $Audit.Add("- Test obligations:")
    $Audit.Add("- Boundary conditions:")
    $Audit.Add("- Downstream dependencies:")
    $Audit.Add("- Audit verdict: Unresolved")
    $Audit.Add("- Status: Not started")
    $Audit.Add("- Reviewer notes:")
    $Audit.Add("")
}

# ============================================================
# === WRITE THE AUDIT ===
# ============================================================

Set-Content `
    -LiteralPath $AuditPath `
    -Value $Audit `
    -Encoding utf8

# ============================================================
# === REPORT ===
# ============================================================

Write-Host ""
Write-Host "Lean formalization audit initialized successfully."
Write-Host ""
Write-Host "Basis:"
Write-Host "  $BasisPath"
Write-Host ""
Write-Host "Audit:"
Write-Host "  $AuditPath"
Write-Host ""
Write-Host "Paper repository commit:"
Write-Host "  $CommitSha"
Write-Host ""
Write-Host "Basis SHA-256:"
Write-Host "  $BasisHash"
Write-Host ""
Write-Host "Auxiliary records:"
Write-Host "  $($AuxiliaryItems.Count)"
Write-Host ""
Write-Host "Labeled paper records:"
Write-Host "  $($Items.Count)"
Write-Host ""

Exit 0
