#!/usr/bin/env bash
# Publish lexicon schemas to a PDS as com.atproto.lexicon.schema records.
#
# Prerequisites:
#   - goat CLI (https://github.com/bluesky-social/goat)
#   - GOAT_USERNAME and GOAT_PASSWORD environment variables set
#   - DNS _lexicon.dataset.alt.science TXT record pointing to the publishing DID
#
# Usage:
#   GOAT_USERNAME="handle-or-did" GOAT_PASSWORD="app-password" ./scripts/publish.sh

set -euo pipefail

LEXICON_DIR="$(cd "$(dirname "$0")/../lexicons" && pwd)"

if ! command -v goat &> /dev/null; then
    echo "Error: goat CLI not found. Install from https://github.com/bluesky-social/goat" >&2
    exit 1
fi

if [ -z "${GOAT_USERNAME:-}" ] || [ -z "${GOAT_PASSWORD:-}" ]; then
    echo "Error: GOAT_USERNAME and GOAT_PASSWORD environment variables must be set" >&2
    exit 1
fi

# goat lex publish scans the lexicons directory, extracts NSIDs from each
# file's "id" field, and publishes them as com.atproto.lexicon.schema records.
# --update overwrites existing records if the schema has changed.
goat lex publish --update --lexicons-dir "$LEXICON_DIR" "$LEXICON_DIR/science/alt/dataset/"
