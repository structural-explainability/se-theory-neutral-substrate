<#
Adds Research Registry (RR) comments and the one missing Lean docstring
identified by the Neutral Substrate audit.

Repository:
  se-theory-neutral-substrate

Default mode is dry-run. Use -Write to apply changes.

Design:
- RR.DEFINES is the exact fully-qualified Lean declaration name.
- RR.IMPLEMENTS mappings are derived from
  reference/substrate-requirements.toml rather than duplicated here.
- Paper item 25 (reification fragment) is intentionally skipped because the
  current Lean example contains no named declaration to anchor.
- Existing docstrings and RR comments are preserved.
- Two audit OBS comments are added at their relevant declarations.
#>

[CmdletBinding()]
param(
    [switch]$Write
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = $PSScriptRoot
if (-not (Test-Path (Join-Path $Root 'SE/NeutralSubstrate'))) {
    $Root = (Get-Location).Path
}
if (-not (Test-Path (Join-Path $Root 'SE/NeutralSubstrate'))) {
    throw "Run this script from the se-theory-neutral-substrate repository root."
}

$RequirementsPath = Join-Path $Root 'reference/substrate-requirements.toml'
if (-not (Test-Path $RequirementsPath)) {
    throw "Missing reference/substrate-requirements.toml."
}

function Get-Newline {
    param([string]$Text)

    if ($Text.Contains("`r`n")) {
        return "`r`n"
    }

    return "`n"
}

function Get-LineStarts {
    param([string]$Text)

    $starts = [System.Collections.Generic.List[int]]::new()
    $starts.Add(0)

    for ($i = 0; $i -lt $Text.Length; $i++) {
        if ($Text[$i] -eq "`n") {
            $starts.Add($i + 1)
        }
    }

    return $starts
}

function Get-DocStartBefore {
    param(
        [string]$Text,
        [int]$Index
    )

    if ($Index -le 0) {
        return -1
    }

    $prefix = $Text.Substring(0, $Index)
    $m = [regex]::Match($prefix, '(?s)(/--.*?-/)\s*$')

    if ($m.Success) {
        return $m.Index
    }

    return -1
}

function Get-CurrentNamespace {
    param([System.Collections.Generic.List[object]]$Stack)

    $parts = [System.Collections.Generic.List[string]]::new()

    foreach ($item in $Stack) {
        if ($item.Kind -ne 'namespace') {
            continue
        }

        $name = [string]$item.Name

        if ($name.Contains('.')) {
            if ($name.StartsWith('SE.')) {
                $parts.Clear()
                foreach ($piece in $name.Split('.')) {
                    $parts.Add($piece)
                }
            }
            else {
                foreach ($piece in $name.Split('.')) {
                    $parts.Add($piece)
                }
            }
        }
        else {
            $parts.Add($name)
        }
    }

    return ($parts -join '.')
}

function Pop-BareBlock {
    param([System.Collections.Generic.List[object]]$Stack)

    if ($Stack.Count -gt 0) {
        $Stack.RemoveAt($Stack.Count - 1)
    }
}

function Pop-NamedNamespace {
    param(
        [System.Collections.Generic.List[object]]$Stack,
        [string]$Name
    )

    for ($i = $Stack.Count - 1; $i -ge 0; $i--) {
        $item = $Stack[$i]

        if ($item.Kind -eq 'namespace') {
            $short = ([string]$item.Name).Split('.')[-1]

            if ($item.Name -eq $Name -or $short -eq $Name) {
                while ($Stack.Count -gt $i) {
                    $Stack.RemoveAt($Stack.Count - 1)
                }
                return
            }
        }
    }

    throw "Could not match namespace end '$Name'."
}

function Read-RequirementMappings {
    param([string]$Path)

    $text = [IO.File]::ReadAllText($Path)
    $map = @{}

    $blocks = [regex]::Matches(
        $text,
        '(?ms)^\[requirement\.[^\]]+\]\s*(?<body>.*?)(?=^\[requirement\.|\z)'
    )

    foreach ($block in $blocks) {
        $body = $block.Groups['body'].Value

        $citeMatch = [regex]::Match(
            $body,
            '(?m)^cite_id\s*=\s*"(?<v>[^"]+)"\s*$'
        )
        $moduleMatch = [regex]::Match(
            $body,
            '(?m)^target_module\s*=\s*"(?<v>[^"]+)"\s*$'
        )
        $symbolMatch = [regex]::Match(
            $body,
            '(?m)^target_symbol\s*=\s*"(?<v>[^"]+)"\s*$'
        )

        if (-not $citeMatch.Success -or
            -not $moduleMatch.Success -or
            -not $symbolMatch.Success) {
            continue
        }

        $cite = $citeMatch.Groups['v'].Value
        $module = $moduleMatch.Groups['v'].Value
        $symbol = $symbolMatch.Groups['v'].Value

        # Paper item 25 currently has no named Lean declaration.
        if ($cite -eq 'se100.example.ReificationFragment') {
            continue
        }

        $relativePath = ($module -replace '\.', '/') + '.lean'
        $key = "$relativePath|$symbol"

        if ($map.ContainsKey($key)) {
            throw "Duplicate requirement mapping for $key."
        }

        $map[$key] = $cite
    }

    return $map
}

function Get-DeclarationInventory {
    param(
        [string]$RelativePath,
        [string]$Text
    )

    $newline = Get-Newline $Text
    $lines = $Text -split '\r?\n', -1
    $lineStarts = Get-LineStarts $Text
    $stack = [System.Collections.Generic.List[object]]::new()
    $decls = [System.Collections.Generic.List[object]]::new()

    $declPattern =
        '^(?<indent>[ \t]*)(?:@\[[^\r\n]*\][ \t]+)?' +
        '(?<mods>(?:(?:public|private|protected|meta|noncomputable)\s+)*)' +
        '(?<kind>inductive|structure|class|def|theorem|lemma|abbrev|opaque|axiom)\s+' +
        '(?<name>[A-Za-z_][A-Za-z0-9_''\.]*)'

    for ($lineNo = 0; $lineNo -lt $lines.Count; $lineNo++) {
        $line = $lines[$lineNo]
        $trimmed = $line.Trim()

        $namespaceMatch = [regex]::Match(
            $line,
            '^[ \t]*namespace[ \t]+(?<name>[A-Za-z_][A-Za-z0-9_''\.]*)[ \t]*$'
        )

        if ($namespaceMatch.Success) {
            $stack.Add([pscustomobject]@{
                Kind = 'namespace'
                Name = $namespaceMatch.Groups['name'].Value
            })
            continue
        }

        $sectionMatch = [regex]::Match(
            $line,
            '^[ \t]*(?:@\[[^\r\n]*\][ \t]+)?(?:public[ \t]+)?section(?:[ \t]+[A-Za-z_][A-Za-z0-9_'']*)?[ \t]*$'
        )

        if ($sectionMatch.Success) {
            $stack.Add([pscustomobject]@{
                Kind = 'section'
                Name = ''
            })
            continue
        }

        $endMatch = [regex]::Match(
            $line,
            '^[ \t]*end(?:[ \t]+(?<name>[A-Za-z_][A-Za-z0-9_''\.]*))?[ \t]*$'
        )

        if ($endMatch.Success) {
            $name = $endMatch.Groups['name'].Value

            if ([string]::IsNullOrWhiteSpace($name)) {
                Pop-BareBlock $stack
            }
            else {
                Pop-NamedNamespace $stack $name
            }

            continue
        }

        $m = [regex]::Match($line, $declPattern)
        if (-not $m.Success) {
            continue
        }

        $mods = $m.Groups['mods'].Value
        if ($mods -match '\bprivate\b') {
            continue
        }

        $name = $m.Groups['name'].Value
        $namespace = Get-CurrentNamespace $stack

        $fqn = if ([string]::IsNullOrWhiteSpace($namespace)) {
            $name
        }
        else {
            "$namespace.$name"
        }

        # If attributes occur on immediately preceding lines, metadata must
        # be inserted before those attributes so the docstring still attaches
        # to the declaration.
        $anchorLine = $lineNo
        while ($anchorLine -gt 0) {
            $previous = $lines[$anchorLine - 1].Trim()
            if ($previous.StartsWith('@[') -and $previous.EndsWith(']')) {
                $anchorLine--
            }
            else {
                break
            }
        }

        $decls.Add([pscustomobject]@{
            Path = $RelativePath
            Name = $name
            FQN = $fqn
            Kind = $m.Groups['kind'].Value
            Line = $lineNo + 1
            DeclarationIndex = $lineStarts[$lineNo]
            AnchorIndex = $lineStarts[$anchorLine]
            Indent = $m.Groups['indent'].Value
            Newline = $newline
        })
    }

    return $decls
}

$RequirementMappings = Read-RequirementMappings $RequirementsPath

if ($RequirementMappings.Count -ne 24) {
    throw "Expected 24 named paper-to-Lean target mappings; found $($RequirementMappings.Count)."
}

$sourceFiles = Get-ChildItem -Path (Join-Path $Root 'SE') -Recurse -File -Filter '*.lean' |
    Sort-Object FullName

$Inventory = [System.Collections.Generic.List[object]]::new()
$FileText = @{}

foreach ($file in $sourceFiles) {
    $relative = [IO.Path]::GetRelativePath($Root, $file.FullName) -replace '\\', '/'
    $text = [IO.File]::ReadAllText($file.FullName)
    $FileText[$relative] = $text

    foreach ($decl in (Get-DeclarationInventory $relative $text)) {
        $Inventory.Add($decl)
    }
}

$inventoryByTarget = @{}
foreach ($decl in $Inventory) {
    $key = "$($decl.Path)|$($decl.Name)"

    if (-not $inventoryByTarget.ContainsKey($key)) {
        $inventoryByTarget[$key] = [System.Collections.Generic.List[object]]::new()
    }

    $inventoryByTarget[$key].Add($decl)
}

$UnresolvedMappings = [System.Collections.Generic.List[string]]::new()
foreach ($key in $RequirementMappings.Keys) {
    if (-not $inventoryByTarget.ContainsKey($key)) {
        $UnresolvedMappings.Add("$key -> $($RequirementMappings[$key])")
    }
    elseif ($inventoryByTarget[$key].Count -ne 1) {
        $UnresolvedMappings.Add(
            "$key -> $($RequirementMappings[$key]) matched $($inventoryByTarget[$key].Count) declarations"
        )
    }
}

if ($UnresolvedMappings.Count -gt 0) {
    Write-Host ''
    Write-Host 'UNRESOLVED PAPER MAPPINGS:' -ForegroundColor Red

    foreach ($item in $UnresolvedMappings) {
        Write-Host "  - $item"
    }

    Write-Host ''
    Write-Host 'No files were written.' -ForegroundColor Yellow
    exit 1
}

$SpecialDocs = @{
    'SE.NeutralSubstrate.foundationalLayerRestrictedToPermittedClasses_iff' =
        'The foundational-layer restriction holds exactly when every substrate commitment is either referential or a permitted attribution proposition.'
}

$SpecialObs = @{
    'SE.NeutralSubstrate.FrameworkRelative.FrameworkInvariantProposition' =
        'OBS: the paper''s "no admissible framework refutes p" gloss is one-way under the abstract consequence interface; no negation-introduction principle is assumed.'

    'SE.NeutralSubstrate.NeutralityConstraint' =
        'OBS: the necessity direction of the neutrality biconditional is part of the stated constraint for a realization; it is not derived from the minimal consequence-system interfaces.'
}

$ChangesByFile = @{}
$AnnotatedDeclarations = 0
$ImplementEdges = 0

foreach ($decl in $Inventory) {
    $text = $FileText[$decl.Path]

    $rr = [System.Collections.Generic.List[string]]::new()
    $defines = "RR.DEFINES: $($decl.FQN)"

    if (-not $text.Contains("-- $defines")) {
        $rr.Add($defines)
    }

    $targetKey = "$($decl.Path)|$($decl.Name)"
    if ($RequirementMappings.ContainsKey($targetKey)) {
        $implements = "RR.IMPLEMENTS: $($RequirementMappings[$targetKey])"
        $ImplementEdges++

        if (-not $text.Contains("-- $implements")) {
            $rr.Add($implements)
        }
    }

    $obs = $null
    if ($SpecialObs.ContainsKey($decl.FQN)) {
        $candidate = [string]$SpecialObs[$decl.FQN]

        if (-not $text.Contains("-- $candidate")) {
            $obs = $candidate
        }
    }

    $anchorIndex = [int]$decl.AnchorIndex
    $docStart = Get-DocStartBefore $text $anchorIndex
    $hasDoc = $docStart -ge 0

    $doc = $null
    if ($SpecialDocs.ContainsKey($decl.FQN) -and -not $hasDoc) {
        $doc = [string]$SpecialDocs[$decl.FQN]
    }

    if ($rr.Count -eq 0 -and $null -eq $obs -and $null -eq $doc) {
        continue
    }

    $insertAt = if ($hasDoc) {
        $docStart
    }
    else {
        $anchorIndex
    }

    $parts = [System.Collections.Generic.List[string]]::new()

    foreach ($line in $rr) {
        $parts.Add("$($decl.Indent)-- $line")
    }

    if ($null -ne $obs) {
        $parts.Add("$($decl.Indent)-- $obs")
    }

    if ($null -ne $doc) {
        $parts.Add("$($decl.Indent)/-- $doc -/")
    }

    $insert = ($parts -join $decl.Newline) + $decl.Newline

    if (-not $ChangesByFile.ContainsKey($decl.Path)) {
        $ChangesByFile[$decl.Path] = [System.Collections.Generic.List[object]]::new()
    }

    $ChangesByFile[$decl.Path].Add([pscustomobject]@{
        Index = $insertAt
        Text = $insert
        FQN = $decl.FQN
    })

    $AnnotatedDeclarations++
}

Write-Host ''
Write-Host ("Source declarations scanned: {0}" -f $Inventory.Count)
Write-Host ("Named paper mappings verified: {0}" -f $ImplementEdges)

if ($ChangesByFile.Count -eq 0) {
    Write-Host 'No changes needed.'
    exit 0
}

Write-Host ("Files to update: {0}" -f $ChangesByFile.Count)
foreach ($path in ($ChangesByFile.Keys | Sort-Object)) {
    Write-Host "  - $path"
}

Write-Host ("Declarations with pending metadata changes: {0}" -f $AnnotatedDeclarations)

if (-not $Write) {
    Write-Host ''
    Write-Host 'DRY RUN ONLY. Re-run with -Write to apply.' -ForegroundColor Yellow
    Write-Host 'RR.IMPLEMENTS edges come from reference/substrate-requirements.toml.'
    Write-Host 'Paper item 25 is intentionally not attached to a Lean declaration.'
    exit 0
}

$utf8NoBom = [Text.UTF8Encoding]::new($false)

foreach ($path in $ChangesByFile.Keys) {
    $text = $FileText[$path]
    $changes = $ChangesByFile[$path] | Sort-Object Index -Descending

    foreach ($change in $changes) {
        $text = $text.Insert([int]$change.Index, [string]$change.Text)
    }

    $full = Join-Path $Root $path
    [IO.File]::WriteAllText($full, $text, $utf8NoBom)
}

Write-Host ''
Write-Host 'Updated Neutral Substrate Lean RR comments and documentation.' -ForegroundColor Green
Write-Host ''
Write-Host 'Next:'
Write-Host '  lake build'
Write-Host '  lake test'
Write-Host '  lake lint'
Write-Host '  git diff -- SE'
