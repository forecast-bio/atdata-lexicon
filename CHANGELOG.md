# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

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
