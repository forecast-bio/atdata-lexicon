# atdata-lexicon

Authoritative [ATProto](https://atproto.com/) lexicon definitions for the `science.alt.dataset` namespace -- the protocol-level schema for federated scientific datasets.

These lexicons define the record types, queries, and extensible tokens used by the [atdata](https://github.com/forecast-bio/atdata) dataset federation protocol. They are independent of any specific language implementation.

See [docs/spec.md](docs/spec.md) for the full lexicon inventory, record relationships, and versioning policy.

## Directory structure

Follows the ATProto convention of mapping NSIDs to directory paths:

```
lexicons/
  science/
    alt/
      dataset/
        record.json          # science.alt.dataset.record
        schema.json          # science.alt.dataset.schema
        ...
schemas/
  ndarray_shim.json          # JSON Schema (not an ATProto lexicon)
```

## Consuming these lexicons

**Raw git reference** (recommended for most consumers):
```bash
git clone https://github.com/forecast-bio/atdata-lexicon.git
```

**TypeScript codegen** with [lex-cli](https://github.com/bluesky-social/atproto/tree/main/packages/lex-cli):
```bash
npx @atproto/lex-cli gen-api ./src/client ./lexicons/science/alt/dataset/*.json
```

**Python** (via [atdata](https://github.com/forecast-bio/atdata)):
```python
from atdata.lexicons import load_lexicon
schema = load_lexicon("science.alt.dataset.record")
```

## Validation

```bash
npm install
npx lex gen-api --yes /tmp/validate-output ./lexicons/science/alt/dataset/*.json
```

CI runs this on every push and pull request.

## License

[MIT](LICENSE)
