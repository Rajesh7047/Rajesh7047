# AGENTS.md

## Cursor Cloud specific instructions

This repo contains a single product: **FitMitra**, a Flutter (Dart) health & wellness
client app for Android/iOS/Web. All app code lives in the `fitmitra/` subdirectory.
There is no in-repo backend, database, or Docker; cloud dependencies (Firebase,
Razorpay) are referenced in code but are not configured/wired up yet.

### Toolchain
- Built and verified with **Flutter 3.27.4 (Dart 3.6.2)** — this matches the
  revision pinned in `fitmitra/.metadata`. The SDK is preinstalled at
  `~/flutter` and on `PATH` via `~/.bashrc`.
- The update script runs `flutter pub get` in `fitmitra/` on startup.

### Running, linting, testing, building
Run all commands from the `fitmitra/` directory (or pass `-C fitmitra` from the repo root).
- Run (dev, web): `flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0`
  then open `http://localhost:8080`. There is no GUI display, so use the
  `web-server` device (not `-d chrome`). First load of a debug web build can take
  ~30-90s while it compiles.
- Lint: `flutter analyze` (currently reports ~70 pre-existing info/warnings but
  exits 0 — these are not introduced by setup).
- Test: `flutter test` (only `test/widget_test.dart`, the default counter smoke test).
- Web build: `flutter build web`.

### Non-obvious gotchas
- `pubspec.yaml` declares `assets/images/`, `assets/icons/`, `assets/animations/`
  and `assets/fonts/Poppins-*.ttf`, but these were never committed originally.
  Without them, **`flutter test`, `flutter run`, and `flutter build` all fail**
  with "unable to find directory entry / unable to locate asset entry". The
  missing asset directories (with `.gitkeep`) and the five Poppins font files
  have been added under `fitmitra/assets/` to make the bundle resolve.
- `lib/main.dart` is still the **default Flutter counter boilerplate**; it does
  NOT import the `lib/features/**` screens or initialize Firebase. So the running
  app shows the counter demo, not the FitMitra feature UI. The feature screens
  exist but are not wired into the app entrypoint.
- No Firebase config files (`google-services.json`, `firebase_options.dart`, etc.)
  exist, so real auth/Firestore flows cannot run until a Firebase project is
  configured. Razorpay payment code is a stub with dummy keys.
