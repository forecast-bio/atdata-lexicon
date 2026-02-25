# Lexicon Specification

## Lexicon inventory

### Records

| NSID | Key | Description |
|------|-----|-------------|
| `science.alt.dataset.entry` | `tid` | Dataset index entry with storage refs, metadata, and sample schema reference |
| `science.alt.dataset.schema` | `any` | Versioned sample type definition (JSON Schema Draft 7, extensible to other formats) |
| `science.alt.dataset.lens` | `tid` | Bidirectional schema transformation with code references |
| `science.alt.dataset.label` | `tid` | Named label pointing to a dataset entry (enables versioned aliases) |
| `science.alt.dataset.lensVerification` | `tid` | Verification record for a lens transformation, written by the verifier |

### Queries (XRPC)

| NSID | Description |
|------|-------------|
| `science.alt.dataset.resolveSchema` | Resolve a schema by NSID, optionally at a specific version |
| `science.alt.dataset.resolveLabel` | Resolve a named label to its underlying dataset entry |

### Tokens and extensible types

| NSID | Description |
|------|-------------|
| `science.alt.dataset.schemaType` | Schema format identifiers (`jsonSchema`, extensible) |
| `science.alt.dataset.arrayFormat` | Array serialization formats (`ndarrayBytes`, `sparseBytes`, `structuredBytes`, `arrowTensor`, `safetensors`, extensible) |
| `science.alt.dataset.programmingLanguage` | Programming language identifiers (`python`, `typescript`, `javascript`, `rust`, extensible) |
| `science.alt.dataset.verificationMethod` | Verification method identifiers (`codeReview`, `formalProof`, `signedHash`, `automatedTest`, extensible) |

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
| `schemas/ndarray_shim.json` | JSON Schema Draft 7 definition for NDArray byte format v1.0.0 (numpy `.npy` binary) |
| `schemas/ndarray_shim_v1.1.0.json` | NDArray byte format v1.1.0 with optional dtype, shape, and dimension name annotations |
| `schemas/sparse_shim.json` | JSON Schema Draft 7 definition for scipy sparse matrix format (CSR/CSC/COO) |
| `schemas/structured_shim.json` | JSON Schema Draft 7 definition for numpy structured array format (compound dtypes) |
| `schemas/arrow_tensor_shim.json` | JSON Schema Draft 7 definition for Arrow tensor IPC format |
| `schemas/safetensors_shim.json` | JSON Schema Draft 7 definition for HuggingFace safetensors format |
| `schemas/dataframe_shim.json` | JSON Schema Draft 7 definition for tabular data in Parquet format |

## Record relationships

```
schema  <----  entry  ---->  storage{Http,S3,Blobs}
  ^            (schemaRef)      (union)
  |
  |--- lens (sourceSchema, targetSchema)
        ^
        |--- lensVerification (lens, verificationMethod)

label  ---->  entry
       (datasetUri)
```

- An **entry** references a **schema** via `schemaRef` (AT-URI) and contains a **storage** union
- A **lens** connects two **schemas** with bidirectional transformation code
- A **lensVerification** attests to the correctness of a **lens** at a specific version (`lensCommit`)
- A **label** is a named pointer to an **entry**, enabling versioned aliases like `mnist@1.0.0`
- **Storage objects** share the `shardChecksum` type defined in `entry#shardChecksum`

## Trust model

Lens verification follows the pattern established by Bluesky's `app.bsky.graph.verification`: the **verifier** writes a `lensVerification` record into their own PDS. The verifier's identity is implicit — it is the DID of the repo owner. This follows the ATProto golden rule: you can only write records into your own repo.

Key properties:

- **Version-pinned**: Each verification targets a specific lens record version via `lensCommit` (CID). If the lens is updated, existing verifications do not carry over — the new version must be re-verified.
- **Method-tagged**: The `verificationMethod` field declares what kind of verification was performed (code review, formal proof, signed hash, or automated test).
- **Trusted verifier designation is an AppView concern**: The lexicon does not define who is a "trusted" verifier. That policy lives at the application layer, where an AppView can maintain a list of trusted DIDs and surface verification status accordingly.

## Versioning policy

These lexicons follow ATProto evolution conventions:

- **Additive changes only**: new optional fields, new `knownValues` entries, new union members
- **No breaking changes**: required fields are never removed, types are never narrowed
- **Open unions**: storage and schema format unions are open by default, allowing new members without breaking existing consumers
- **Token extensibility**: `schemaType`, `arrayFormat`, and `programmingLanguage` use `knownValues` (not `enum`), so new values can be added without schema changes
- **Deprecated fields**: The top-level `language` field on `science.alt.dataset.lens` is deprecated in favor of per-reference `codeReference.language`, which allows getter and putter to specify different languages
