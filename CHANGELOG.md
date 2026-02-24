# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Added

- `science.alt.dataset.programmingLanguage` token type with extensible known values: `python`, `typescript`, `javascript`, `rust`
- Optional `language` field on `science.alt.dataset.lens#codeReference` for per-function programming language granularity

### Deprecated

- Top-level `language` field on `science.alt.dataset.lens` records — use `codeReference.language` instead for per-function granularity

## [0.3.0b1] - 2026-02-24

### Added

- `science.alt.dataset.lensVerification` record type for attesting to the correctness of a lens at a specific version, following the Bluesky verification pattern
- `science.alt.dataset.verificationMethod` token type with extensible known values: `codeReview`, `formalProof`, `signedHash`, `automatedTest`
- Optional `sourceSchemaVersion` and `targetSchemaVersion` fields on `science.alt.dataset.lens` for semver-based schema compatibility matching
- Trust model documentation in `docs/spec.md`

### Fixed

- `resolveLabel.json` missing `LabelNotFound` error definition (inconsistent with `resolveSchema`'s `SchemaNotFound`)
- `resolveLabel.json` redundant `#main` suffix on label ref (ATProto convention: bare NSID for main definitions)

## [0.2.2b1] - 2026-02-23

### Added

- NSID-to-path validation script (`scripts/validate-nsids.sh`) and CI step to catch drift after namespace renames
- Environment variable validation in `publish.sh` (fail fast if `GOAT_PDS_HOST`/`GOAT_AUTH` unset)

### Fixed

- `resolveLabel.json` query parameters now have `maxLength` constraints matching their record field counterparts (name: 200, version: 50)
- Stale "Foundation.ac" reference in `schema.json` `arrayFormatVersions` description
- `spec.md` incorrectly listed `storageExternal` as a member of `entry.storage` union; moved to new "Deprecated types" section
- CI push trigger now includes `develop` branch

## [0.2.1b1] - 2026-02-20

### Changed

- **Breaking**: Renamed `science.alt.dataset.record` to `science.alt.dataset.entry` to avoid ambiguity with ATProto's "record" concept
- Updated all cross-references (`#shardChecksum` refs in storage types) and documentation

## [0.2.0b1] - 2026-02-17

### Changed

- **Breaking**: Renamed entire lexicon namespace from `ac.foundation.dataset.*` to `science.alt.dataset.*`
- Moved directory structure from `lexicons/ac/foundation/dataset/` to `lexicons/science/alt/dataset/`
- Updated all internal cross-references, documentation, CI workflow, and publish script

## [0.1.0b1] - 2026-02-17

### Added

- 12 ATProto lexicon files for the `ac.foundation.dataset` namespace, migrated from [forecast-bio/atdata](https://github.com/forecast-bio/atdata) into NSID-to-path directory structure (`lexicons/ac/foundation/dataset/`)
  - Record types: `record`, `schema`, `lens`, `label`
  - Query types: `resolveSchema`, `resolveLabel`
  - Token/string types: `schemaType`, `arrayFormat`
  - Storage objects: `storageHttp`, `storageS3`, `storageBlobs`, `storageExternal` (deprecated)
- NDArray shim JSON Schema in `schemas/ndarray_shim.json`
- CI validation workflow using `@atproto/lex-cli`
- PDS publish script (`scripts/publish.sh`) for protocol-level lexicon discovery
- Lexicon specification docs (`docs/spec.md`)

### Fixed

- Invalid `"type": "object"` property usages in `lens.json` and `schema.json` replaced with proper `#lensMetadata` and `#schemaMetadata` open object defs for lex-cli compatibility
