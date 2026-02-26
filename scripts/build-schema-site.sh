#!/usr/bin/env bash
# Build the static site for json-schema.alt.science
# Reads each schema's $id to derive the output directory structure.
set -euo pipefail

OUTDIR="${1:-_site}"
SCHEMA_DIR="$(cd "$(dirname "$0")/../schemas" && pwd)"

rm -rf "$OUTDIR"
mkdir -p "$OUTDIR"

for f in "$SCHEMA_DIR"/*.json; do
    url=$(jq -r '."$id"' "$f")
    if [ "$url" = "null" ] || [ -z "$url" ]; then
        echo "Warning: $f has no \$id field, skipping" >&2
        continue
    fi
    # Strip the base URL to get the relative path
    path=$(echo "$url" | sed 's|https://json-schema.alt.science/||')
    mkdir -p "$OUTDIR/$(dirname "$path")"
    # Copy the schema file — name it index.json for directory-style serving
    # Also copy as the bare version name for direct access
    cp "$f" "$OUTDIR/${path}"
    echo "  Built: $path"
done

echo "Schema site built in $OUTDIR/ ($(find "$OUTDIR" -name '*.json' -o -type f ! -name '.*' | wc -l | tr -d ' ') files)"
