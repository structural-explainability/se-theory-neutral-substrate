# ============================================================
# ONE-TIME: Add or update Lean source license headers
# ============================================================

$ErrorActionPreference = "Stop"

$root = (git rev-parse --show-toplevel).Trim()
if ($LASTEXITCODE -ne 0) {
    throw "Not inside a Git repository."
}

$files = @(git -C $root ls-files -- "*.lean")
if ($LASTEXITCODE -ne 0) {
    throw "Could not enumerate tracked Lean files."
}

$encoding = [System.Text.UTF8Encoding]::new($false)

$added = 0
$updated = 0
$skipped = 0

foreach ($relativePath in $files) {

    $path = Join-Path $root $relativePath
    $content = [System.IO.File]::ReadAllText($path)

    # Preserve existing line endings.
    $eol = if ($content.Contains("`r`n")) { "`r`n" } else { "`n" }

    $header = @(
        "/-"
        "Copyright (c) 2026 Denise M. Case. All rights reserved."
        "Released under Apache 2.0 license as described in the file LICENSE."
        "Authors: Denise M. Case"
        "-/"
        ""
    ) -join $eol

    $header += $eol

    # Inspect the existing file header.
    $opening = $content.Substring(0, [Math]::Min(800, $content.Length))

    $hasLicenseHeader = $opening -match '(?m)^\s*(Copyright \(c\)|Authors:|SPDX-License-Identifier:|Released under .* license)'

    if ($hasLicenseHeader) {

        # Only automatically modify headers identifying this copyright holder.
        if ($opening -notmatch 'Copyright \(c\) [^\r\n]*Denise M\. Case') {
            Write-Host "REVIEW   $relativePath"
            $skipped++
            continue
        }

        $revised = $content.Replace(
            "Released under MIT license as described in the file LICENSE.",
            "Released under Apache 2.0 license as described in the file LICENSE."
        )

        $revised = $revised.Replace(
            "SPDX-License-Identifier: MIT",
            "SPDX-License-Identifier: Apache-2.0"
        )

        if ($revised -ne $content) {
            [System.IO.File]::WriteAllText($path, $revised, $encoding)
            Write-Host "UPDATED  $relativePath"
            $updated++
        }

    } else {

        # Add the header before the existing file content.
        [System.IO.File]::WriteAllText(
            $path,
            ($header + $content),
            $encoding
        )

        Write-Host "ADDED    $relativePath"
        $added++
    }
}

Write-Host ""
Write-Host "Added:   $added"
Write-Host "Updated: $updated"
Write-Host "Review:  $skipped"

# Inspect the resulting changes.
git diff --stat -- "*.lean"
git diff --check
