# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.

The format is based on **[Keep a Changelog](https://keepachangelog.com/en/1.1.0/)**
and this project adheres to **[Semantic Versioning](https://semver.org/spec/v2.0.0.html)**.

---

## [Unreleased]

---

## [0.8.0] - 2026-07-29

### Added

- Added concept-focused Lean modules under `SE/NeutralSubstrate/`:
  - `Primitive.lean`
  - `InterpretiveFramework.lean`
  - `ExtensionStability.lean`
  - `InterpretiveNonCommitment.lean`
  - `OntologicalNeutrality.lean`
  - `FrameworkContestability.lean`
  - `SeparateStability.lean`

- Added an explicit `Admissibility` predicate type so admissible frameworks are
  supplied as domain parameters rather than declared globally.
- Added named domain assumptions for:
  - framework relativity;
  - neutral-primitives-undisputed;
  - causal-and-normative affirmation.

- Added propositional and executable forms of the causal-or-normative membership
  test.
- Added elementary results connecting the executable ontology test to its
  propositional meaning.
- Added `stable_under_admissible_framework` as the general one-framework
  consequence of extension stability.
- Added `stable_under_each_framework` as the general two-framework stability
  result underlying `separate_stability`.
- Added a symmetric framework-contradiction relation and its commutativity
  theorem.
- Added a theorem deriving framework variance for non-neutral primitives from
  framework relativity and non-neutral affirmation.
- Added a theorem excluding non-neutral primitives from a neutral substrate
  under the required domain assumptions.
- Added the internal `SETest` Lean library, following the Mathlib-style
  separation between public theory modules and test modules.
- Added a pinned `lean-toolchain` declaration matching the selected Mathlib and
  Lean release.

### Changed

- Reorganized the Lean formalization by named mathematical concept rather than
  by generic artifact type.
- Replaced the monolithic `SE/NeutralSubstrate/Core.lean` organization with
  concept-focused modules.
- Changed `Ontology` from a finite list of primitives to a `Finset Primitive`,
  making finite-set semantics and duplicate elimination explicit.
- Changed ontological-neutrality definitions and theorems to accept an explicit
  admissibility regime.
- Changed framework relativity, neutral-primitives-undisputed, and
  causal-and-normative affirmation from global axioms to explicit theorem
  premises.
- Changed `FrameworkVariant` so its witnesses must satisfy the supplied
  admissibility regime.
- Changed `ExtensionStable`, `InterpretivelyNonCommitted`, and `Neutral` so
  their meanings are relative to an explicit admissibility regime.
- Changed the Ontological Neutrality Theorem to expose the asymmetric premises
  used by its two directions:
  - framework relativity for the lower bound;
  - neutral-primitives-undisputed for the upper bound.

- Changed `separate_stability` to be a paper-framed corollary of the stronger
  `stable_under_each_framework` theorem.
- Changed the Lake test-library name from the earlier test target to `SETest`.
- Changed the Mathlib dependency declaration to the scoped
  `leanprover-community` package form with an explicitly pinned revision.
- Changed `SE_MANIFEST.toml` to describe the actual paper-100 theory concepts,
  scope, and module organization.
- Changed repository scope descriptions to cover primitives, interpretive
  frameworks, admissibility, extension stability, interpretive
  non-commitment, ontological neutrality, framework contestability, and
  separate stability.
- Changed test and verification examples so they reside outside the public
  production modules.
- Updated reference-artifact descriptions to treat Lean source as the
  authoritative formalization and the concept modules as the public theorem
  implementation.

### Removed

- Removed the monolithic `SE/NeutralSubstrate/Core.lean` module after its
  declarations were assigned to concept-focused modules.
- Removed global axiom declarations for framework relativity,
  neutral-primitives-undisputed, and causal-and-normative affirmation.
- Removed list-specific ontology semantics.
- Removed the helper lemmas `any_false_implies_none` and
  `any_true_implies_exists`; their roles are provided by standard finite-set,
  decidability, and simplification results.
- Removed helper-lemma citation and registry entries that no longer correspond
  to public theory declarations.
- Removed production-module `#check` commands and concrete verification
  examples.
- Removed the implication that contradiction between two frameworks is needed
  to prove stability under each framework; contradiction remains part of the
  named paper result but is not used by the stronger general theorem.
- Removed obsolete manifest language describing the repository primarily in
  terms of regime application, identity-regime encoding, and generic substrate
  invariants.

### Fixed

- Fixed the Lake workspace configuration by aligning `lean-toolchain` with the
  pinned Mathlib release.
- Fixed missing-manifest startup failures by regenerating
  `lake-manifest.json` through `lake update`.
- Fixed stale or interrupted Mathlib dependency state by allowing the generated
  `.lake` dependency directory to be recreated cleanly.
- Fixed the public theorem-set declaration so it no longer points to the
  removed `Core.lean` file.
- Fixed the formal dependency structure so foundational definitions do not
  depend on later theorem modules.
- Fixed the separation between general mathematical results and theorem
  statements retaining paper-specific hypotheses.

---

## [0.7.0] - 2026-06-03

### Added

- Added `reference/theory-reference.toml` as the declarative configuration
  file consumed by `se-theory-reference-kit`.
- Added shared theory-reference workflow commands using `se-theory-reference`.
- Added `catalog` and `inspect` command usage to the release validation flow.
- Added authority manifest linkage through `.accountability/surfaces.toml`.

### Changed

- Reworked this repository as a thin Lean/reference repository that depends on
  `se-theory-reference-kit` for generic Python tooling.
- Replaced repo-local reference-tool command usage with shared
  `se-theory-reference` commands.
- Updated release validation to run Lean builds, shared reference validation,
  export freshness checks, catalog checks, manifest validation, pre-commit, and
  documentation build.
- Updated README command guidance to use `uv run se-theory-reference ...`
  directly.
- Simplified Python project configuration so this repository uses Python tooling
  as a consumer rather than publishing a repo-local Python package.
- Clarified that Lean source is authoritative for formal declarations,
  `reference/*.toml` owns classification, traceability, and export intent, and
  generated JSON under `data/neutral-substrate/` is output.

### Removed

- Removed repo-local Python package build assumptions from release validation.
- Removed repo-local Python test, type-check, dead-code, complexity, wheel, and
  distribution checks from the client-repository release flow.
- Removed obsolete command references for `se-ref-validate`, `se-ref-export`,
  and `se-validate`.
- Removed dependence on the old `reference/index.toml` workflow.

### Fixed

- Fixed release validation commands so they match the shared
  `se-theory-reference-kit` command surface.
- Fixed documentation and command guidance after moving theory-reference
  machinery out of the client repository.

---

## [0.6.0] - 2026-05-31

### Changed

- Moved Lean public modules under the `SE.NeutralSubstrate` namespace.
- Updated Lake configuration, Lean imports, tests, and reference metadata for the new module layout.
- Reworked reference tooling into a structured `reference_tool` package.
- Moved generated reference export logic under `reference_tool/export.py`.
- Updated generated neutral-substrate JSON artifacts from the refreshed reference TOML registries.
- Replaced manifest-sync command surface with reference validation and export commands.
- Added `rel.ps1` release validation script with explicit staged checks.
- Updated CI, pre-commit, markdownlint, documentation, manifest, citation,
  and agent guidance for the updated structure.
- Expanded Python tests for reference tooling, path handling, export freshness, and validation behavior.

### Removed

- Removed obsolete manifest-sync command module.
- Removed legacy top-level Lean module paths.
- Removed obsolete top-level `lean_surface.py` and `ref_utils.py` modules.

---

## [0.5.2] - 2026-05-14

### Changed

- Updated index.md to use the standard theory-repository documentation sections.
- Updated `ci-python-zensical.yml` required documentation sections to match
  the standard theory-repository structure.
- Updated README.md

---

## [0.5.1] - 2026-05-14

### Added

- Added `test/TestAll.lean` as the top-level Lean test entry point.
- Added generated neutral-substrate contract artifacts under `data/neutral-substrate/`.
- Added `reference/substrate-requirements.toml`
  to map stable `Spec.lean` citation IDs to implemented Lean symbols.
- Added `se-ref-export` support for generated reference JSON artifacts.
- Added split command modules under `src/se_theory_neutral_substrate/commands/`.
- Added shared reference utility module `src/se_theory_neutral_substrate/ref_utils.py`.
- Added export tests for generated neutral-substrate data artifacts.

### Changed

- Updated `lean-toolchain` to `leanprover/lean4:stable`.
- Replaced `.markdownlint.yml` with `.markdownlint-cli2.yaml`.
- Updated `.pre-commit-config.yaml`.
- Updated `lakefile.toml`.
- Updated `NeutralSubstrate.Spec` with stable uppercase citation identifiers for tracked helper theorems.
- Updated `NeutralSubstrate.Surface` to align with the current public surface.
- Updated reference TOML files to use uppercase `Spec.lean` citation IDs.
- Updated `reference/index.toml` to declare hand-authored reference artifacts
  and generated `data/neutral-substrate/` artifacts.
- Updated CLI organization so public entry points remain in `cli.py`
  while command implementations live under `commands/`.
- Updated reference validation to check citation IDs against `Spec.lean`.
- Updated README build and reference-artifact guidance.

### Removed

- Removed hand-authored `reference/proof-registry.json`.
- Removed obsolete `.markdownlint.yml`.

### Fixed

- Fixed neutral-substrate reference export so generated JSON artifacts
  are written under `data/neutral-substrate/`.
- Fixed reference validation hygiene by extracting shared Lean/TOML
  utilities into `ref_utils.py`.
- Fixed mixed-case `cite_id` values in reference artifacts.

---

## [0.5.0] - 2026-05-02

### Added

- `reference/index.toml` declaring all machine-readable reference artifacts
- `reference/substrate-types.toml` - type registry for PrimitiveKind, Primitive, Ontology, Framework
- `reference/substrate-predicates.toml` - predicate registry for all eight NS predicates
- `reference/substrate-axioms.toml` - axiom registry for framework_relativity,
  neutral_primitives_undisputed, causal_normative_affirmed
- `reference/substrate-theorems.toml` - theorem registry including helper lemmas
  any_false_implies_none and any_true_implies_exists
- `reference/proof-registry.json` - proof status for all eight theorems
- `reference/dependency-registry.toml` - inter-repo dependency constraints
- `reference/traceability-registry.toml` - proof-term dependency traces for
  all theorems
- `reference.py` - scaffold and validate reference artifacts against Lean 4 source
- `se-ref-scaffold` CLI command - adds stubs for new Lean symbols,
  preserves existing descriptions and cite_ids
- `se-ref-validate` CLI command - validates reference artifacts
  against Lean source, writes nothing
- `se-manifest-validate` and `se-manifest-version-sync` CLI entry points

### Changed

- `run_validate()` extended to include reference artifact validation as final step
- Release procedure simplified and updated to use CLI entry points

---

## [0.4.0] - 2026-05-01

### Added

- `InterpretivelyNonCommitted` predicate; no primitive in the substrate
  is framework-variant; the second neutrality requirement (INC) from
  Case (2025) alongside extension stability (EXT)
- `only_neutral_primitives_implies_INC` theorem; only-neutral substrates
  satisfy INC under existing axioms; no additional axiom required
- `NS.DEF.INTERPRETIVELY_NON_COMMITTED` citation ID
- `NS.THEOREM.ONLY_NEUTRAL_IMPLIES_INC` citation ID

### Changed

- `Neutral` updated from EXT alone to the full `EXT ∧ INC` conjunction.

  **Breaking change**: all proofs unfolding `Neutral` updated accordingly.

- `framework_contestability_lemma` now proves both EXT and INC violations;
- "deferred to 0.4.0" note removed
- `NeutralSubstrate.lean` Section 2.2 updated with `InterpretivelyNonCommitted`
- `NeutralSubstrate.lean` Section 2.4 updated with `only_neutral_primitives_implies_INC`

### Exports Added

- `InterpretivelyNonCommitted`
- `only_neutral_primitives_implies_INC`

## [0.3.0] - 2026-05-01

### Added

- `FrameworkVariant` predicate - a primitive is framework-variant if
  admissible frameworks disagree about it
- `FrameworksContradict` predicate - one framework affirms what another denies
- `causal_normative_affirmed` axiom - companion to `framework_relativity`;
  establishes that non-neutral primitives are affirmed by some admissible framework
- `framework_contestability_lemma` theorem - framework-variant primitives
  cannot appear in neutral substrates; proves the extension stability
  violation; the interpretive non-commitment violation is deferred to 0.4.0
  when interpretive non-commitment (INC) is formalized
- `separate_stability` theorem - a neutral substrate is separately consistent
  with each of two mutually contradicting frameworks
- Incident substrate example in `TestRegime` instantiating `separate_stability`
  on the 2026 NS paper Section 4.3 engineering/legal framework pair
- `NS.THEOREM.LOWER_BOUND_ONLY` citation ID for domains where only the
  lower bound applies

### Changed

- Namespace changed to SE.NeutralSubstrate
- Split into Core / Spec / Surface / entry point
- ISO-structured doc block on NeutralSubstrate.lean
- Test library with TestBasic and TestRegime
- lakefile.toml with separate Test lib target
- `neutral_primitives_undisputed` doc strengthened with upper-bound warning
- `ontological_neutrality_theorem` doc updated with asymmetry note on
  differing axiom dependencies of the two directions
- `NeutralSubstrate.lean` Section 2.5 added normative asymmetry note to public surface

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
  - \*_MAJOR_- – breaking changes
  - \*_MINOR_- – backward-compatible additions
  - \*_PATCH_- – fixes, documentation, tooling
- Versions are driven by git tags. Tag `vX.Y.Z` to release.
- Docs are deployed per version tag and aliased to **latest**.

## Release Procedure (Required)

Follow these steps exactly when creating a new release.

### Task 1. Update release metadata (manual edits)

1.1. CITATION.cff: update version and date-released
1.2. lakefile.toml: update version
1.3. CHANGELOG.md: add section, move unreleased entries, update links
1.4. pyproject.toml: update version (near top of the file)

### Task 2. Validate

Run:

```powershell
.\rel.ps1
```

Review all generated and modified files before committing.

### Task 3. Commit and Push

```shell
git add -A
git commit -m "Prep X.Y.Z"
git push -u origin main
```

Verify that all required GitHub Actions complete successfully,
including the combined Zensical and Lean API documentation deployment.

### Task 4. Tag and Push the Release

After the required GitHub Actions succeed:

```shell
git tag vX.Y.Z -m "X.Y.Z"
git push origin vX.Y.Z
```

### Task 5. After tagging, verify tag consistency

```shell
uvx se-manifest-schema check-version --require-tag
```

Confirms CITATION.cff version matches the pushed git tag.
Run this after `git push origin vX.Y.Z`; it will fail before that point.

## Only As Needed (delete a tag)

```shell
git tag -d vX.Z.Y
git push origin :refs/tags/vX.Z.Y
```

## Links

[Unreleased]: https://github.com/structural-explainability/se-theory-neutral-substrate/compare/v0.8.0...HEAD
[0.8.0]: https://github.com/structural-explainability/se-theory-neutral-substrate/releases/tag/v0.8.0
[0.7.0]: https://github.com/structural-explainability/se-theory-neutral-substrate/releases/tag/v0.7.0
[0.5.2]: https://github.com/structural-explainability/se-theory-neutral-substrate/releases/tag/v0.5.2
[0.5.1]: https://github.com/structural-explainability/se-theory-neutral-substrate/releases/tag/v0.5.1
[0.5.0]: https://github.com/structural-explainability/se-theory-neutral-substrate/releases/tag/v0.5.0
[0.4.0]: https://github.com/structural-explainability/se-theory-neutral-substrate/releases/tag/v0.4.0
[0.3.0]: https://github.com/structural-explainability/se-theory-neutral-substrate/releases/tag/v0.3.0
[0.1.0]: https://github.com/structural-explainability/se-theory-neutral-substrate/releases/tag/v0.1.0

<!-- markdownlint-enable MD024 -->
