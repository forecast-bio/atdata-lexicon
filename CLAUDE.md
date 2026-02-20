# atdata-lexicon

Authoritative ATProto lexicon definitions for the `science.alt.dataset` namespace.

## Structure

- `lexicons/science/alt/dataset/*.json` -- ATProto Lexicon v1 schema files
- `schemas/ndarray_shim.json` -- JSON Schema (not a lexicon) for ndarray byte format
- `scripts/publish.sh` -- Publish lexicons to a PDS via goat CLI

## Conventions

- Directory structure mirrors NSID: `science.alt.dataset.entry` -> `lexicons/science/alt/dataset/entry.json`
- All lexicon files use `"lexicon": 1` and have an `"id"` matching their path-derived NSID

## Validation

```bash
npm install
npx lex gen-api --yes /tmp/out ./lexicons/science/alt/dataset/*.json
```

## Related

- Issue: forecast-bio/atdata#69
- Reference implementation: [forecast-bio/atdata](https://github.com/forecast-bio/atdata)
