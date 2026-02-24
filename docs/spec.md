# Lexicon Specification

## Lexicon inventory

### Records

| NSID | Key | Description |
|------|-----|-------------|
| `science.alt.dataset.entry` | `tid` | Dataset index entry with storage refs, metadata, and sample schema reference |
| `science.alt.dataset.schema` | `any` | Versioned sample type definition (JSON Schema Draft 7, extensible to other formats) |
| `science.alt.dataset.lens` | `tid` | Bidirectional schema transformation with code references |
| `science.alt.dataset.label` | `tid` | Named label pointing to a dataset entry (enables versioned aliases) |

### Queries (XRPC)

| NSID | Description |
|------|-------------|
| `science.alt.dataset.resolveSchema` | Resolve a schema by NSID, optionally at a specific version |
| `science.alt.dataset.resolveLabel` | Resolve a named label to its underlying dataset entry |

### Tokens and extensible types

| NSID | Description |
|------|-------------|
| `science.alt.dataset.schemaType` | Schema format identifiers (`jsonSchema`, extensible) |
| `science.alt.dataset.arrayFormat` | Array serialization formats (`ndarrayBytes`, extensible) |

### Storage objects (union members of `entry.storage`)

| NSID | Description |
|------|-------------|
| `science.alt.dataset.storageHttp` | HTTP/HTTPS URL-based storage with shard manifest |
| `science.alt.dataset.storageS3` | S3-compatible object storage |
| `science.alt.dataset.storageBlobs` | ATProto PDS blob storage |

### Deprecated types

| NSID | Description |
|------|-------------|
| `science.alt.dataset.storageExternal` | *(Deprecated)* External URL storage; use `storageHttp` or `storageS3` instead. Not included in `entry.storage` union refs. |

### Non-lexicon schemas

| File | Description |
|------|-------------|
| `schemas/ndarray_shim.json` | JSON Schema Draft 7 definition for NDArray byte format (numpy `.npy` binary) |

## Record relationships

```
schema  <----  entry  ---->  storage{Http,S3,Blobs}
  ^            (schemaRef)      (union)
  |
  |--- lens (sourceSchema, targetSchema)

label  ---->  entry
       (datasetUri)
```

- An **entry** references a **schema** via `schemaRef` (AT-URI) and contains a **storage** union
- A **lens** connects two **schemas** with bidirectional transformation code
- A **label** is a named pointer to an **entry**, enabling versioned aliases like `mnist@1.0.0`
- **Storage objects** share the `shardChecksum` type defined in `entry#shardChecksum`

## Versioning policy

These lexicons follow ATProto evolution conventions:

- **Additive changes only**: new optional fields, new `knownValues` entries, new union members
- **No breaking changes**: required fields are never removed, types are never narrowed
- **Open unions**: storage and schema format unions are open by default, allowing new members without breaking existing consumers
- **Token extensibility**: `schemaType` and `arrayFormat` use `knownValues` (not `enum`), so new formats can be added without schema changes
