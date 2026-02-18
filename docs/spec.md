# Lexicon Specification

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

## Versioning policy

These lexicons follow ATProto evolution conventions:

- **Additive changes only**: new optional fields, new `knownValues` entries, new union members
- **No breaking changes**: required fields are never removed, types are never narrowed
- **Open unions**: storage and schema format unions are open by default, allowing new members without breaking existing consumers
- **Token extensibility**: `schemaType` and `arrayFormat` use `knownValues` (not `enum`), so new formats can be added without schema changes
