#!/usr/bin/env bash
# Publish lexicon schemas to a PDS as com.atproto.lexicon.schema records.
#
# Prerequisites:
#   - goat CLI (https://github.com/bluesky-social/indigo/tree/main/cmd/goat)
#   - GOAT_PDS_HOST and GOAT_AUTH environment variables set
#   - DNS _lexicon.dataset.alt.science TXT record pointing to the publishing DID
#
# Usage:
#   ./scripts/publish.sh

set -euo pipefail

LEXICON_DIR="$(cd "$(dirname "$0")/../lexicons/science/alt/dataset" && pwd)"

if ! command -v goat &> /dev/null; then
    echo "Error: goat CLI not found. Install from https://github.com/bluesky-social/indigo" >&2
    exit 1
fi

if [ -z "${GOAT_PDS_HOST:-}" ] || [ -z "${GOAT_AUTH:-}" ]; then
    echo "Error: GOAT_PDS_HOST and GOAT_AUTH environment variables must be set" >&2
    exit 1
fi

for lexicon_file in "$LEXICON_DIR"/*.json; do
    nsid=$(basename "$lexicon_file" .json)
    full_nsid="science.alt.dataset.$nsid"

    echo "Publishing $full_nsid..."

    # Parse the lexicon file and wrap it as a com.atproto.lexicon.schema record,
    # then publish it to the PDS.
    goat lex parse "$lexicon_file" \
        | goat lex publish --nsid "$full_nsid" -

    echo "  Published $full_nsid"
done

echo "All lexicons published."
