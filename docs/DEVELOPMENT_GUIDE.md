# FitMitra — Development Guide (Setup → Play Store)

Complete step-by-step guide for **FitMitra** (`com.epointdigital.fitmitra`).

---

## Table of contents

1. [Prerequisites](#1-prerequisites)
2. [Project setup](#2-project-setup)
3. [Firebase configuration](#3-firebase-configuration)
4. [Phone OTP authentication](#4-phone-otp-authentication)
5. [Firestore data model](#5-firestore-data-model)
6. [Razorpay payments](#6-razorpay-payments)
7. [AI health chat](#7-ai-health-chat)
8. [Zoom live sessions](#8-zoom-live-sessions)
9. [Running the app](#9-running-the-app)
10. [Testing checklist](#10-testing-checklist)
11. [Android release build](#11-android-release-build)
12. [Play Store submission](#12-play-store-submission)

---

## 1. Prerequisites

| Tool | Version |
|------|---------|
| Flutter | 3.16+ (stable) |
| Dart | 3.2+ |
| Android Studio | Latest |
| Xcode (macOS) | 15+ (for iOS) |
| Node.js | 18+ (Firebase CLI) |
| Java JDK | 17 |

```bash
flutter doctor -v
dart --version
```

Install Firebase & FlutterFire CLI:

```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
firebase login
```

---

## 2. Project setup

```bash
git clone <your-repo>
cd fitmitra
flutter pub get
cp .env.example .env
```

Edit `.env`:

```env
RAZORPAY_KEY_ID=rzp_live_xxxx
OPENAI_API_KEY=sk-xxxx
```

> Never commit `.env`. Add `.env` to `.gitignore` (already included).

---

## 3. Firebase configuration

### 3.1 Create Firebase project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create project **fitmitra-app** (or your name)
3. Enable **Authentication**, **Firestore**, **Storage**

### 3.2 Register apps

| Platform | Package / Bundle ID |
|----------|---------------------|
| Android | `com.epointdigital.fitmitra` |
| iOS | `com.epointdigital.fitmitra` |
| Web | (optional) |

### 3.3 FlutterFire configure

```bash
flutterfire configure \
  --project=fitmitra-app \
  --android-package-name=com.epointdigital.fitmitra \
  --ios-bundle-id=com.epointdigital.fitmitra \
  --out=lib/firebase_options.dart
```

### 3.4 Android Gradle (Kotlin DSL)

1. Download `google-services.json` → `android/app/google-services.json`
2. In `android/settings.gradle.kts`, add:

```kotlin
plugins {
    // ...
    id("com.google.gms.google-services") version "4.4.2" apply false
}
```

3. In `android/app/build.gradle.kts`, uncomment:

```kotlin
id("com.google.gms.google-services")
```

### 3.5 Deploy security rules

```bash
firebase deploy --only firestore:rules,storage
```

Rules are in `firebase/firestore.rules` and `firebase/storage.rules`.

---

## 4. Phone OTP authentication

1. Firebase Console → **Authentication** → **Sign-in method**
2. Enable **Phone**
3. Add test phone numbers for development
4. For production, configure **App Check** and SHA-256 fingerprints:

```bash
cd android && ./gradlew signingReport
```

Add SHA-1 and SHA-256 to Firebase Android app settings.

---

## 5. Firestore data model

```
users/{uid}
  ├── phoneNumber, displayName, healthGoalId
  ├── isPremium, premiumExpiresAt
  ├── dailyCalorieGoal, dailyWaterGoalMl
  ├── daily_tracking/{yyyy-MM-dd}
  │     └── calories, waterMl
  └── ai_chat_history/{messageId}

diet_plans/{id}      → goalId, meals[], title
videos/{id}          → category: yoga|meditation|recipe
products/{id}        → goalIds[], priceInPaise
mentor_sessions/{id} → scheduledAt, zoomJoinUrl
memberships/{id}     → userId, planId, paymentId
```

Seed demo content is in `lib/data/datasources/demo_content_data.dart` until Firestore is populated.

### Sample product document

```json
{
  "name": "Lean Burn Protein",
  "description": "Plant protein for weight loss",
  "priceInPaise": 149900,
  "imageUrl": "https://...",
  "goalIds": ["weight_loss"]
}
```

---

## 6. Razorpay payments

1. Create account at [Razorpay Dashboard](https://dashboard.razorpay.com/)
2. Generate **API Keys** (Test → Live when ready)
3. Set `RAZORPAY_KEY_ID` in `.env`
4. Android: Razorpay SDK is included via `razorpay_flutter`
5. Implement server-side **payment verification** (recommended for production):

   - Cloud Function on `payment.captured` webhook
   - Verify signature before setting `isPremium: true`

Demo mode: placeholder keys auto-complete payment after 1 second.

---

## 7. AI health chat

- Set `OPENAI_API_KEY` in `.env` for GPT-4o-mini responses
- Without a key, the app uses built-in wellness fallback replies
- Free tier: 5 user messages/day (`AppConstants.freeAiMessagesPerDay`)
- Premium: 100/day (configurable)

---

## 8. Zoom live sessions

1. Create [Zoom Server-to-Server OAuth app](https://marketplace.zoom.us/)
2. Schedule meetings via Zoom API or manually
3. Store `zoomJoinUrl` in `mentor_sessions` collection
4. Premium users tap **Join on Zoom** → opens external Zoom app

For embedded meetings, integrate Zoom Meeting SDK (native) in a future release.

---

## 9. Running the app

```bash
# List devices
flutter devices

# Run debug
flutter run

# Run with environment
flutter run --dart-define-from-file=.env
```

**Web:** `flutter run -d chrome` (Firebase web config required)

---

## 10. Testing checklist

- [ ] OTP login with test number
- [ ] Onboarding goal selection persists
- [ ] Home grid navigation to all modules
- [ ] Calorie + water tracking syncs to Firestore
- [ ] AI chat (free limit + premium unlock)
- [ ] Premium paywall on diet plans & Zoom
- [ ] Razorpay test payment completes
- [ ] Video playback (yoga/meditation/recipes)
- [ ] Dark mode toggle in Profile
- [ ] Sign out → login screen

```bash
flutter test
flutter analyze
```

---

## 11. Android release build

### 11.1 Signing keystore

```bash
keytool -genkey -v -keystore fitmitra-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias fitmitra
```

Create `android/key.properties`:

```properties
storePassword=<password>
keyPassword=<password>
keyAlias=fitmitra
storeFile=../fitmitra-release.jks
```

Update `android/app/build.gradle.kts` with `signingConfigs` for release.

### 11.2 Build App Bundle

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## 12. Play Store submission

1. [Google Play Console](https://play.google.com/console) → Create app
2. **App name:** FitMitra
3. **Package:** `com.epointdigital.fitmitra`
4. Complete:
   - Store listing (screenshots, description, icon 512×512)
   - Privacy policy URL (required for health apps)
   - Data safety form (health, personal info, payments)
   - Content rating questionnaire
5. Upload **AAB** to **Production** or **Internal testing**
6. Add testers → roll out

### Recommended store categories

- **Category:** Health & Fitness
- **Tags:** wellness, diet, yoga, meditation, AI coach

---

## Project structure reference

```
lib/
├── main.dart / bootstrap.dart / app.dart
├── firebase_options.dart
├── core/           # theme, router, constants, providers
├── domain/         # entities, repository contracts
├── data/           # Firebase + demo data
├── features/       # auth, home, tracking, ai_chat, …
└── shared/         # widgets, Razorpay service
```

---

## Support

For Epoint Digital internal use. Update `firebase_options.dart` and `.env` before any production release.
