# CEF Starter (macOS ARM64) — GitHub Actions

This repository builds a **Chromium Embedded Framework (CEF)** sample app (`cefsimple`) for **Apple Silicon (arm64)** on a macOS runner, with a **hardcoded start URL**.

## Quick start

1) **Set your URL** (optional)
- Edit `.github/workflows/macos-cef.yml` and change `START_URL` (default: `https://example.com`).

2) **Pick a CEF build**
- Visit the official builds page and copy the **macOS ARM64** download URL:  
  https://cef-builds.spotifycdn.com/index.html  (click **MacOS ARM64**, pick a row’s **Standard Distribution** link)
- Paste that URL into `CEF_DOWNLOAD` in `.github/workflows/macos-cef.yml`.

> Tip: The URL ends with something like `cef_binary_134.0.6998.44+g<hash>_macos_arm64.tar.bz2`.

3) **Push to GitHub**
- Commit and push. The workflow will run on **macOS 14** and upload a build artifact named `cefsimple-macos`.

4) **Download & run on your Mac**
- From GitHub Actions, download the artifact. Inside you’ll find `cefsimple.app`.
- To open on first run (unsigned app): right-click the app → **Open** (Gatekeeper prompt) → **Open** again.
- You should see a native window rendering your **hardcoded** URL.

## Files

- `.github/workflows/macos-cef.yml` — CI pipeline: downloads CEF, patches the sample to hardcode your URL, builds, and uploads the app.
- `patches/simple_app.cc` — Replacement for CEF’s `tests/cefsimple/simple_app.cc` that hardcodes the start URL (reads `START_URL` env; defaults to `https://example.com`).
- `scripts/patch_cefsimple.sh` — Copies the patched file into the extracted CEF tree before building.

## Customize

- **Change window title, size, handlers**: Modify other files under `tests/cefsimple` after the extract step (add copy statements like in `patch_cefsimple.sh`).
- **Universal binary**: You can duplicate the job with `_macos_x86_64` CEF and `-DPROJECT_ARCH=x86_64`, then `lipo` them together.
- **Codesign / Notarize**: Add steps after build to sign with your Developer ID and notarize via `xcrun notarytool`.

## Why not Linux→macOS cross-compile?

CEF apps depend on Apple frameworks and codesigning. Building the macOS app on a macOS runner is the reliable route.

---

**Enjoy!**
