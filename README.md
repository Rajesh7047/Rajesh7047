# FitMitra

Premium AI-powered health and wellness Flutter app scaffold for **FitMitra** (`com.epointdigital.fitmitra`) with modern Material 3 UI, Firebase-ready backend integration, OTP login, memberships, AI chat, diet plans, yoga and recipe videos, meditation, mentor sessions, trackers, dark mode, and release guidance.

## What is included

- Material 3 Flutter app with responsive layout and dark mode
- Clean, scalable feature-first structure with data, domain, and presentation layers
- OTP mobile login flow ready for Firebase Auth and demo fallback mode
- Firebase bootstrap wiring for Auth, Firestore, and Storage
- Free and premium membership system with Razorpay-ready checkout service
- AI wellness chat module with Firestore persistence hook and local safe fallback replies
- Personalized diet plans for Weight Loss, Weight Gain, and PCOD / Thyroid goals
- Yoga, meditation, and recipe video library with Firebase Storage-ready thumbnails
- Live Zoom mentor session screen
- Calorie and water tracking with persistence and Firestore sync hook
- Goal-based product recommendations
- Web, Android, and iOS scaffolding with Gradle Kotlin DSL support

## Folder structure

```text
lib/
  src/
    app.dart
    bootstrap.dart
    core/
      config/
      constants/
      models/
      providers/
      router/
      theme/
      utils/
      widgets/
    features/
      ai_chat/
      auth/
      diet/
      home/
      media/
      membership/
      mentors/
      profile/
      shop/
      tracking/
    shared/
      data/
```

## Step-by-step development setup

### 1. Install Flutter and verify the toolchain

```bash
flutter --version
flutter doctor
```

Recommended channels and tools:
- Flutter stable
- Android Studio / Xcode
- Java 17+
- CocoaPods for iOS

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Create a Firebase project and enable:
- Authentication -> Phone
- Firestore Database
- Storage

Install FlutterFire CLI if needed:

```bash
dart pub global activate flutterfire_cli
```

Run configuration from the project root:

```bash
flutterfire configure   --project=<your-firebase-project-id>   --android-package-name=com.epointdigital.fitmitra   --ios-bundle-id=com.epointdigital.fitmitra
```

This generates `lib/firebase_options.dart` plus native Firebase files. After that, switch `FirebaseBootstrap.initialize()` to use the generated options if you want strict platform initialization:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### 4. Android Firebase setup checklist

- Place `android/app/google-services.json`
- Add Google Services Gradle plugin if you want full native processing
- Confirm SHA certificates in Firebase for OTP auth
- Add test phone numbers in Firebase Auth while developing

### 5. iOS Firebase setup checklist

- Place `ios/Runner/GoogleService-Info.plist`
- Run `pod install` from `ios/`
- Configure APNs / silent push only if you later add notifications
- Set phone auth test numbers in Firebase Console

### 6. Razorpay setup

Use Dart defines so secrets are not hardcoded:

```bash
flutter run   --dart-define=RAZORPAY_KEY_ID=rzp_test_xxxxxxxx   --dart-define=RAZORPAY_HOSTED_CHECKOUT_URL=https://your-hosted-checkout.example.com
```

Current behavior:
- If a Razorpay key is provided on Android/iOS, the app opens native checkout
- Without keys, the app completes membership activation in guided demo mode so the UI flow stays testable

### 7. Zoom mentor sessions

Replace the placeholder links in `SeedData.mentorSessions` with real Zoom registration or join URLs. In production, this list should come from Firestore or your admin backend.

### 8. Run the app

```bash
flutter run
```

For web:

```bash
flutter run -d chrome
```

## Firebase data model suggestions

### users/{uid}

```json
{
  "displayName": "FitMitra Member",
  "phoneNumber": "+919876543210",
  "goal": "weightLoss",
  "membershipTier": "premium",
  "dailyCalorieTarget": 1800,
  "dailyWaterTargetMl": 3000,
  "streak": 12
}
```

### ai_chats/{uid}/messages/{messageId}

```json
{
  "role": "assistant",
  "text": "Try protein plus fiber at your next snack.",
  "sentAt": 1716912000000
}
```

### diet_plans/{goal}

Store macros, description, meal list, premium add-ons, and coach notes for each goal.

### tracking/{uid}

Persist the latest daily tracker summary and optionally move to a dated subcollection later.

## Production hardening roadmap

1. Replace seeded content with Firestore-driven CMS data.
2. Replace heuristic AI replies with a secure backend endpoint or Firebase Functions layer.
3. Add role-based admin tooling for mentors, products, and video content.
4. Add crash reporting and analytics.
5. Add CI for `flutter test`, `flutter analyze`, and release builds.
6. Add secure server-side payment verification for Razorpay webhooks.
7. Add remote config / feature flags for staged rollouts.
8. Add localization and health data integrations if required.

## Suggested next build phases

### Phase 1: Core product
- OTP auth
- User profile onboarding
- Goal selection
- Trackers
- Diet content from Firestore

### Phase 2: Premium experience
- Server-verified Razorpay subscriptions
- Mentor booking and reminders
- Premium video gating
- Personalized recommendations engine

### Phase 3: AI + scale
- Secure AI backend
- Saved conversations
- Push notifications
- Admin dashboard
- Subscription lifecycle management

## Testing commands

```bash
flutter format lib test
flutter analyze
flutter test
```

## Play Store release checklist

1. Update `version:` in `pubspec.yaml`
2. Replace launcher icons and splash branding
3. Configure signing keys in `android/app/build.gradle.kts`
4. Run a release build:

```bash
flutter build appbundle --release   --dart-define=RAZORPAY_KEY_ID=rzp_live_xxxxxxxx
```

5. Upload the generated `.aab` to Google Play Console
6. Fill store listing assets, privacy policy, and data safety details
7. Verify OTP, payments, mentor links, and backend content on an internal test track
8. Promote to production after QA and policy review

## Notes

- The app intentionally supports a guided demo mode when Firebase or Razorpay are not configured yet.
- For a fully production deployment, move AI and payment verification off-device and into secure backend services.
