# FitMitra

FitMitra (`com.epointdigital.fitmitra`) is a premium AI-powered health and wellness Flutter app scaffold with Material 3 UI, Firebase integration, OTP mobile login, free and premium membership flows, AI health chat, personalized diet plans, yoga and meditation videos, recipe videos, Zoom mentor sessions, calorie and water tracking, goal-based product recommendations, Razorpay payments, dark mode, responsive layouts, and Android Gradle Kotlin DSL support.

## What is included

- Modern Flutter app structure under `lib/src` with app, core, data, domain, state, and presentation layers.
- Material 3 light and dark themes with responsive mobile/tablet/desktop navigation.
- Firebase-ready repositories for Auth, Firestore, and Storage.
- Phone OTP login using Firebase Auth.
- Firestore-backed user profile, content, products, sessions, tracker, and payment collections.
- Demo/offline fallback data so the UI can run before production credentials are added.
- AI health chat via `google_generative_ai` with safe fallback guidance and medical disclaimers.
- Razorpay checkout integration with demo unlock fallback when no Razorpay key is provided.
- Yoga, meditation, and recipe video library using `video_player`.
- Live Zoom mentor session launch via `url_launcher`.
- Firebase Firestore and Storage security rules plus Firestore indexes.
- Android Kotlin DSL Gradle files for package `com.epointdigital.fitmitra`.
- Focused model tests.

## Prerequisites

Install these locally or in CI:

1. Flutter SDK compatible with the package constraints in `pubspec.yaml`.
2. Android Studio or command-line Android SDK.
3. Firebase CLI.
4. FlutterFire CLI.
5. A Firebase project with Phone Auth, Firestore, and Storage enabled.
6. Razorpay account and key ID.
7. Gemini API key or a secure backend proxy for AI chat.

## First run

```bash
flutter pub get
flutter test
flutter run --dart-define=FITMITRA_FIREBASE_CONFIGURED=false
```

The app opens in demo mode without Firebase. Use this for UI review and local iteration.

## Firebase setup

1. Create a Firebase project, for example `fitmitra-prod`.
2. Enable Authentication > Phone provider.
3. Create Firestore in production mode.
4. Create Firebase Storage.
5. Configure Android app package `com.epointdigital.fitmitra`.
6. Download `google-services.json` to `android/app/google-services.json`.
7. Generate live Flutter options:

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project fitmitra-prod --out lib/firebase_options.dart
```

8. Deploy rules and indexes:

```bash
firebase use fitmitra-prod
firebase deploy --only firestore:rules,firestore:indexes,storage
```

Run with Firebase enabled:

```bash
flutter run \
  --dart-define=FITMITRA_FIREBASE_CONFIGURED=true \
  --dart-define=GEMINI_API_KEY=YOUR_GEMINI_KEY \
  --dart-define=RAZORPAY_KEY_ID=YOUR_RAZORPAY_KEY_ID
```

## Suggested Firestore collections

### `users/{uid}`

```json
{
  "phoneNumber": "+919876543210",
  "displayName": "FitMitra Member",
  "goal": "weight_loss",
  "membershipTier": "free",
  "premiumExpiresAt": null,
  "photoUrl": null,
  "createdAt": "serverTimestamp",
  "updatedAt": "serverTimestamp"
}
```

### `content/{contentId}`

```json
{
  "title": "Sunrise Fat-Burn Yoga Flow",
  "type": "yoga",
  "durationMinutes": 24,
  "imageUrl": "https://...",
  "videoUrl": "https://...mp4",
  "isPremium": false,
  "goals": ["weight_loss", "pcod_thyroid"],
  "description": "...",
  "status": "published",
  "createdAt": "serverTimestamp"
}
```

### `products/{productId}`

```json
{
  "name": "Clean Plant Protein",
  "goals": ["weight_loss"],
  "reason": "Keeps meals protein-rich without excess calories.",
  "imageUrl": "https://...",
  "priceInr": 1499,
  "productUrl": "https://...",
  "priority": 100
}
```

### `sessions/{sessionId}`

```json
{
  "title": "Ask a Dietitian",
  "mentorName": "Dr. Meera Kapoor",
  "startsAt": "timestamp",
  "zoomUrl": "https://zoom.us/j/...",
  "isPremium": true,
  "isLive": true
}
```

### `users/{uid}/tracker/{yyyy-mm-dd}`

```json
{
  "calories": 1450,
  "waterMl": 2200,
  "updatedAt": "serverTimestamp"
}
```

## Razorpay production notes

The app can open Razorpay Checkout from Flutter. For production, do not trust client-side payment success alone.

Recommended production flow:

1. Create an order from a Firebase Cloud Function or other backend.
2. Open Razorpay Checkout with the backend order ID.
3. On payment success, send `razorpay_payment_id`, `razorpay_order_id`, and `razorpay_signature` to the backend.
4. Verify the signature server-side with the Razorpay secret.
5. Only then update `users/{uid}.membershipTier` and `premiumExpiresAt`.

The current client marks payments as `captured_client_pending_server_verification` to make that production requirement explicit.

## AI health chat production notes

For fastest prototyping, pass `GEMINI_API_KEY` with `--dart-define`. For production, prefer a secure backend proxy so the API key is never embedded in the app bundle. Keep the existing AI repository interface and replace the direct Gemini call with an HTTPS Cloud Function call.

AI safety requirements already reflected in the prompt:

- No diagnosis.
- No medication prescriptions.
- Escalation for red-flag symptoms.
- Clear educational disclaimer.

## Android release and Play Store guide

1. Update app version in `pubspec.yaml` and `android/app/build.gradle.kts`.
2. Create a release keystore:

```bash
keytool -genkey -v -keystore ~/fitmitra-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias fitmitra
```

3. Create `android/key.properties`:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=fitmitra
storeFile=/absolute/path/to/fitmitra-release.jks
```

4. Build an Android App Bundle:

```bash
flutter build appbundle --release \
  --dart-define=FITMITRA_FIREBASE_CONFIGURED=true \
  --dart-define=GEMINI_API_KEY=YOUR_GEMINI_KEY \
  --dart-define=RAZORPAY_KEY_ID=YOUR_RAZORPAY_KEY_ID
```

5. Test the bundle using Play Internal Testing before production.
6. In Play Console, complete app access, data safety, content rating, privacy policy, screenshots, feature graphic, and health app disclaimers.
7. Upload `build/app/outputs/bundle/release/app-release.aab`.
8. Monitor Firebase Crashlytics and Play vitals after release. Crashlytics is not wired in this scaffold; add `firebase_crashlytics` before public launch if desired.

## Development checklist

- Replace placeholder Firebase options with `flutterfire configure` output.
- Seed Firestore `content`, `products`, and `sessions` collections.
- Add backend Razorpay order creation and signature verification.
- Move Gemini calls behind a backend proxy before public release.
- Add real assets, launcher icons, splash art, screenshots, and privacy policy.
- Add integration tests for OTP, premium purchase, and tracker sync.
- Run `flutter analyze`, `flutter test`, and `flutter build appbundle` in a Flutter-enabled environment.
