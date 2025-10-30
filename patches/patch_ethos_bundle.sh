#!/usr/bin/env bash
set -euo pipefail
# Patch CMakeLists.txt and Info.plist in the extracted CEF tree to rename the app to ethos.

REPO_ROOT="${1:-$(pwd)}"
CEF_DIR="$REPO_ROOT/third_party/cef"
CEFSIMPLE_DIR="$CEF_DIR/tests/cefsimple"

# Patch CMakeLists.txt
if [[ -f "$CEFSIMPLE_DIR/CMakeLists.txt" ]]; then
  if [[ ! -f "$CEFSIMPLE_DIR/CMakeLists.txt.orig" ]]; then
    cp "$CEFSIMPLE_DIR/CMakeLists.txt" "$CEFSIMPLE_DIR/CMakeLists.txt.orig"
  fi
  patch "$CEFSIMPLE_DIR/CMakeLists.txt" "$REPO_ROOT/patches/CMakeLists.txt.patch"
fi


# Patch mac/Info.plist.in
if [[ -f "$CEFSIMPLE_DIR/mac/Info.plist.in" ]]; then
  if [[ ! -f "$CEFSIMPLE_DIR/mac/Info.plist.in.orig" ]]; then
    cp "$CEFSIMPLE_DIR/mac/Info.plist.in" "$CEFSIMPLE_DIR/mac/Info.plist.in.orig"
  fi
  patch "$CEFSIMPLE_DIR/mac/Info.plist.in" "$REPO_ROOT/patches/Info.plist.in.patch"
fi

echo "Patched CMakeLists.txt and Info.plist for ethos app bundle."
