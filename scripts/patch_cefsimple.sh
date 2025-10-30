#!/usr/bin/env bash
set -euo pipefail
# Copies our patched simple_app.cc into the extracted CEF tree so that the
# start URL is hardcoded at build time.

REPO_ROOT="${1:-$(pwd)}"
CEF_DIR="$REPO_ROOT/third_party/cef"

# CEF standard dist extracts to $CEF_DIR with 'tests/cefsimple' content.
TARGET="$CEF_DIR/tests/cefsimple/simple_app.cc"
SRC="$REPO_ROOT/patches/simple_app.cc"

if [[ ! -f "$SRC" ]]; then
  echo "Patch source not found: $SRC" >&2
  exit 1
fi

if [[ ! -d "$CEF_DIR/tests/cefsimple" ]]; then
  echo "Destination not found: $CEF_DIR/tests/cefsimple" >&2
  echo "Did the CEF archive extract correctly?" >&2
  exit 1
fi

echo "Patching cefsimple: $TARGET"
cp "$SRC" "$TARGET"
