"""reference_tool/config.py - Repository-specific configuration for reference tooling."""

LEAN_PUBLIC_ROOT = "SE.NeutralSubstrate"

REFERENCE_DIR_NAME = "reference"
REFERENCE_INDEX_NAME = "index.toml"

REPO_SLUG = "se-theory-neutral-substrate"
ARTIFACT_SLUG = "neutral-substrate"

GENERATED_DATA_DIR = f"data/{ARTIFACT_SLUG}"
REFERENCE_NAMESPACE = f"se.{ARTIFACT_SLUG.replace('-', '_')}"

CATALOG_ARTIFACT_NAME = f"{ARTIFACT_SLUG}-catalog"
CATALOG_SCHEMA = f"se-{ARTIFACT_SLUG}-catalog-1"

STRICT_WARNING_EXEMPTIONS = {
    "kind mismatch",
}
