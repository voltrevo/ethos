#!/usr/bin/env bash
set -euo pipefail
# Test patching workflow for ethos CEF integration.
# 1. Create .gitignore in third_party
# 2. Download CEF if not present
# 3. Run patch_ethos.sh

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Always keep the downloaded archive, extract a fresh copy each run
CEF_ARCHIVE="$REPO_ROOT/third_party/cef.tar.bz2"
CEF_DOWNLOAD="${CEF_DOWNLOAD:-https://cef-builds.spotifycdn.com/cef_binary_141.0.11+g7e73ac4+chromium-141.0.7390.123_macosarm64.tar.bz2}"
CEF_SHA1="${CEF_SHA1:-25191857fe1faf6862f395ffe593a84709ccf07d}"

mkdir -p "$REPO_ROOT/third_party"
cd "$REPO_ROOT/third_party"

# 1. Create .gitignore in third_party
GITIGNORE="$REPO_ROOT/third_party/.gitignore"
echo '*' > "$GITIGNORE"
echo ".gitignore created in third_party."

# 2. Download archive if missing
if [[ ! -f "$CEF_ARCHIVE" ]]; then
  echo "Downloading CEF archive..."
  curl -L -o cef.tar.bz2 "$CEF_DOWNLOAD"
  echo "$CEF_SHA1  cef.tar.bz2" | shasum -c -
else
  echo "CEF archive already present at $CEF_ARCHIVE"
fi

# Remove any previous extraction
rm -rf "$REPO_ROOT/third_party/cef"

# Extract fresh copy
tar -xjf cef.tar.bz2
mv cef_binary_* cef
cd "$REPO_ROOT"

# 3. Run patch_ethos.sh
bash "$REPO_ROOT/scripts/patch_ethos.sh" "$REPO_ROOT"
