# atdata-lexicon

Authoritative [ATProto](https://atproto.com/) lexicon definitions for the `ac.foundation.dataset` namespace -- the protocol-level schema for federated scientific datasets.

These lexicons define the record types, queries, and extensible tokens used by the [atdata](https://github.com/forecast-bio/atdata) dataset federation protocol. They are independent of any specific language implementation.

## Lexicon inventory

### Records

| NSID | Key | Description |
|------|-----|-------------|
| `ac.foundation.dataset.record` | `tid` | Dataset index record with storage refs, metadata, and sample schema reference |
| `ac.foundation.dataset.schema` | `any` | Versioned sample type definition (JSON Schema Draft 7, extensible to other formats) |
| `ac.foundation.dataset.lens` | `tid` | Bidirectional schema transformation with code references |
| `ac.foundation.dataset.label` | `tid` | Named label pointing to a dataset record (enables versioned aliases) |

### Queries (XRPC)

| NSID | Description |
|------|-------------|
| `ac.foundation.dataset.resolveSchema` | Resolve a schema by NSID, optionally at a specific version |
| `ac.foundation.dataset.resolveLabel` | Resolve a named label to its underlying dataset record |

### Tokens and extensible types

| NSID | Description |
|------|-------------|
| `ac.foundation.dataset.schemaType` | Schema format identifiers (`jsonSchema`, extensible) |
| `ac.foundation.dataset.arrayFormat` | Array serialization formats (`ndarrayBytes`, extensible) |

### Storage objects (union members of `record.storage`)

| NSID | Description |
|------|-------------|
| `ac.foundation.dataset.storageHttp` | HTTP/HTTPS URL-based storage with optional shard manifest |
| `ac.foundation.dataset.storageS3` | S3-compatible object storage |
| `ac.foundation.dataset.storageBlobs` | ATProto PDS blob storage |
| `ac.foundation.dataset.storageExternal` | *(Deprecated)* External URL storage |

### Non-lexicon schemas

| File | Description |
|------|-------------|
| `schemas/ndarray_shim.json` | JSON Schema Draft 7 definition for NDArray byte format (numpy `.npy` binary) |

## Record relationships

```
schema  <----  record  ---->  storage{Http,S3,Blobs}
  ^            (schemaRef)       (union)
  |
  |--- lens (sourceSchema, targetSchema)

label  ---->  record
       (datasetUri)
```

- A **record** references a **schema** via `schemaRef` (AT-URI) and contains a **storage** union
- A **lens** connects two **schemas** with bidirectional transformation code
- A **label** is a named pointer to a **record**, enabling versioned aliases like `mnist@1.0.0`
- **Storage objects** share the `shardChecksum` type defined in `record#shardChecksum`

## Directory structure

Follows the ATProto convention of mapping NSIDs to directory paths:

```
lexicons/
  ac/
    foundation/
      dataset/
        record.json          # ac.foundation.dataset.record
        schema.json          # ac.foundation.dataset.schema
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
npx @atproto/lex-cli gen-api ./src/client ./lexicons/ac/foundation/dataset/*.json
```

**Python** (via [atdata](https://github.com/forecast-bio/atdata)):
```python
from atdata.lexicons import load_lexicon
schema = load_lexicon("ac.foundation.dataset.record")
```

## Versioning policy

These lexicons follow ATProto evolution conventions:

- **Additive changes only**: new optional fields, new `knownValues` entries, new union members
- **No breaking changes**: required fields are never removed, types are never narrowed
- **Open unions**: storage and schema format unions are open by default, allowing new members without breaking existing consumers
- **Token extensibility**: `schemaType` and `arrayFormat` use `knownValues` (not `enum`), so new formats can be added without schema changes

## Validation

```bash
npm install
npx lex gen-api --yes /tmp/validate-output ./lexicons/ac/foundation/dataset/*.json
```

CI runs this on every push and pull request.

## License

[MIT](LICENSE)
