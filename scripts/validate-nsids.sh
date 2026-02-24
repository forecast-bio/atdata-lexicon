#!/usr/bin/env bash
# Validate that each lexicon file's "id" field matches the NSID derived from its path.
# This catches drift after namespace renames (which have occurred twice already).
#
# Usage:
#   ./scripts/validate-nsids.sh

set -euo pipefail

LEXICON_DIR="$(cd "$(dirname "$0")/../lexicons" && pwd)"
errors=0

for file in "$LEXICON_DIR"/science/alt/dataset/*.json; do
    # Derive expected NSID from path: lexicons/science/alt/dataset/foo.json -> science.alt.dataset.foo
    relative="${file#"$LEXICON_DIR"/}"
    expected_nsid="${relative%.json}"
    expected_nsid="${expected_nsid//\//.}"

    # Extract actual id from the lexicon file
    actual_nsid=$(node -e "process.stdout.write(JSON.parse(require('fs').readFileSync('$file','utf8')).id)")

    if [ "$actual_nsid" != "$expected_nsid" ]; then
        echo "MISMATCH: $file" >&2
        echo "  expected id: $expected_nsid" >&2
        echo "  actual id:   $actual_nsid" >&2
        errors=$((errors + 1))
    fi
done

if [ "$errors" -gt 0 ]; then
    echo "$errors NSID mismatch(es) found." >&2
    exit 1
fi

echo "All lexicon IDs match their file paths."
