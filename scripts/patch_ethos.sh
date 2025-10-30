#!/usr/bin/env bash
set -euo pipefail
# Copies our patched simple_app.cc and simple_app.h into the extracted CEF tree
# so that the start URL is hardcoded at build time and custom schemes/command
# line processing hooks are available.

REPO_ROOT="${1:-$(pwd)}"
CEF_DIR="$REPO_ROOT/third_party/cef"

# CEF standard dist extracts to $CEF_DIR with 'tests/cefsimple' content.
CEFSIMPLE_DIR="$CEF_DIR/tests/cefsimple"

if [[ ! -d "$CEFSIMPLE_DIR" ]]; then
  echo "Destination not found: $CEFSIMPLE_DIR" >&2
  echo "Did the CEF archive extract correctly?" >&2
  exit 1
fi

echo "Patching ethos..."

# Patch simple_app.h
SRC_H="$REPO_ROOT/patches/simple_app.h"
TARGET_H="$CEFSIMPLE_DIR/simple_app.h"
if [[ ! -f "$SRC_H" ]]; then
  echo "Patch source not found: $SRC_H" >&2
  exit 1
fi
echo "  Patching: $TARGET_H"
cp "$SRC_H" "$TARGET_H"

# Patch simple_app.cc
SRC_CC="$REPO_ROOT/patches/simple_app.cc"
TARGET_CC="$CEFSIMPLE_DIR/simple_app.cc"
if [[ ! -f "$SRC_CC" ]]; then
  echo "Patch source not found: $SRC_CC" >&2
  exit 1
fi
echo "  Patching: $TARGET_CC"
cp "$SRC_CC" "$TARGET_CC"

echo "Patching complete!"
