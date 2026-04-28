# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.

The format is based on **[Keep a Changelog](https://keepachangelog.com/en/1.1.0/)**
and this project adheres to **[Semantic Versioning](https://semver.org/spec/v2.0.0.html)**.

## [Unreleased]

---

## [0.1.0] - 2026-04-28

### Added

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
- Sample commands:

```shell
# as needed
git tag -d v0.1.0
git push origin :refs/tags/v0.1.0

# new tag / release
git tag v0.1.0 -m "0.1.0"
git push origin v0.1.0
```

[Unreleased]: https://github.com/structural-explainability/se-theory-neutral-substrate/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/structural-explainability/se-theory-neutral-substrate/releases/tag/v0.1.0
