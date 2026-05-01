# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.

The format is based on **[Keep a Changelog](https://keepachangelog.com/en/1.1.0/)**
and this project adheres to **[Semantic Versioning](https://semver.org/spec/v2.0.0.html)**.

## [Unreleased]

---

## [0.1.0] - 2026-04-28

### Added

- Imports se-manifest-schema from PyPi.
- Neutral substrate layer (`NeutralSubstrate.*`)
- `Basic`: `Substrate` and `Locus` primitives
- `Structure`: `WellFormed` typeclass and `WellFormedSubstrate`
- `Admissibility`: `Admissible` typeclass and `Candidate` predicate
- `Separation`: `Separated` typeclass and `Neutral` typeclass
- `Invariants`: `Invariant` predicate and `invariant_of_neutral` theorem
- `Theorems`: `admissible_of_neutral`, `separated_of_neutral`, `invariant_holds_of_neutral`
- `Witness`: `unitSubstrate` canonical satisfiability witness
- Single import surface via root `NeutralSubstrate.lean`

---

## Notes on versioning and releases

- We use **SemVer**:
  - **MAJOR** – breaking changes to artifact structure or validation semantics
  - **MINOR** – backward-compatible additions to schema or validation rules
  - **PATCH** – fixes, documentation, tooling
- Versions are driven by git tags. Tag `vX.Y.Z` to release.
- Docs are deployed per version tag and aliased to **latest**.

## Release Procedure (Required)

Follow these steps exactly when creating a new release.

### Task 1. Update release metadata (manual edits)

1.1. CITATION.cff: update version and date-released
1.2. CHANGELOG.md: add section, move unreleased entries, update links

### Task 2. Sync

```shell
uv run python -m se_theory_neutral_substrate sync
```

Reads `CITATION.cff` version and `date-released`
and updates `pyproject.toml` fallback-version.

### Task 3. Validate

```shell
uv run python -m se_theory_neutral_substrate validate --strict
git add -A
uvx pre-commit run --all-files
uv run python -m pyright
uv run python -m pytest
uv run python -m zensical build
```

### Task 4. Commit, tag, push

```shell
git add -A
git commit -m "Release X.Y.Z"
git push -u origin main
```

Verify actions run on GitHub. After success:

```shell
git tag vX.Y.Z -m "X.Y.Z"
git push origin vX.Y.Z
```

### Task 5. Verify tag consistency

```shell
uv run python -m se_theory_neutral_substrate validate --strict --require-tag
```

Confirms CITATION.cff version matches the pushed git tag.
Run this after `git push origin vX.Y.Z`; it will fail before that point.

## Only As Needed (delete a tag)

```shell
git tag -d vX.Z.Y
git push origin :refs/tags/vX.Z.Y
```

[Unreleased]: https://github.com/structural-explainability/se-theory-neutral-substrate/compare/v0.1.1...HEAD
[0.1.0]: https://github.com/structural-explainability/se-theory-neutral-substrate/releases/tag/v0.1.0
