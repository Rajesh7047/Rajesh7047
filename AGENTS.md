# AGENTS.md

## Cursor Cloud specific instructions

This repository contains a single product: **FitMitra**, a Flutter (Dart) mobile/web app located in `fitmitra/`. There is no separate backend in the repo — persistence is via Firebase (Firestore/Auth/Storage, currently unconfigured) plus on-device storage. All commands below are run from `fitmitra/`.

### Toolchain
- The Flutter SDK (stable, Dart >= 3.6.2 as required by `pubspec.yaml`) is installed at `~/flutter` and added to `PATH` via `~/.bashrc`. New interactive shells pick it up automatically. If `flutter` is not found in a non-interactive context, use the absolute path `~/flutter/bin/flutter`.
- Chrome is available and Flutter web is enabled, so the app can run headlessly via the web target.

### Common commands (run from `fitmitra/`)
- Lint/analyze: `flutter analyze` (config in `analysis_options.yaml`). Note: the feature code under `lib/features/` currently has ~70 pre-existing lint warnings/info (unused imports, deprecated `withOpacity`, etc.) but no errors.
- Test: `flutter test` (single widget test in `test/widget_test.dart`).
- Run (web, headless-friendly): `flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0`, then open `http://localhost:8080`. Or `flutter run -d chrome`.
- Build (verification): `flutter build web`.

### Non-obvious gotchas
- `pubspec.yaml` declares asset directories (`assets/images/`, `assets/icons/`, `assets/animations/`) and bundled Poppins fonts (`assets/fonts/Poppins-*.ttf`). These asset files are committed in this repo — without them, `flutter test`/`flutter build`/`flutter run` fail at the asset-bundling stage ("unable to find directory entry" / "unable to locate asset entry"). Keep them present.
- `lib/main.dart` is still the default Flutter counter template; the feature screens under `lib/features/` exist but are not yet wired into the app entry point or router. So the running app currently shows the counter demo, not the FitMitra feature UI.
- Full end-to-end auth/data/payments require a Firebase project (no `firebase_options.dart` / `google-services.json` committed) and a Razorpay test account. Neither is configured; the app still runs without them because the wired entry point (`main.dart`) does not initialize Firebase.
