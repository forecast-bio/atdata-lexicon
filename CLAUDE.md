# atdata-lexicon

Authoritative ATProto lexicon definitions for the `ac.foundation.dataset` namespace.

## Structure

- `lexicons/ac/foundation/dataset/*.json` -- ATProto Lexicon v1 schema files
- `schemas/ndarray_shim.json` -- JSON Schema (not a lexicon) for ndarray byte format
- `scripts/publish.sh` -- Publish lexicons to a PDS via goat CLI

## Conventions

- Directory structure mirrors NSID: `ac.foundation.dataset.record` -> `lexicons/ac/foundation/dataset/record.json`
- All lexicon files use `"lexicon": 1` and have an `"id"` matching their path-derived NSID

## Validation

```bash
npm install
npx lex gen-api --yes /tmp/out ./lexicons/ac/foundation/dataset/*.json
```

## Related

- Issue: forecast-bio/atdata#69
- Reference implementation: [forecast-bio/atdata](https://github.com/forecast-bio/atdata)
