# FitMitra: Setup to Play Store Release Guide

## 1) Prerequisites

- Flutter stable channel
- Android Studio + SDK + emulator
- Java 17+
- Firebase project
- Razorpay merchant account
- Zoom OAuth / SDK account for mentor sessions backend

## 2) Local Setup

1. Clone repository.
2. Install packages:
   ```bash
   flutter pub get
   ```
3. Generate Firebase options:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
4. Add environment values:
   - Razorpay key
   - AI API endpoint / key (through secure backend)
   - Zoom session API endpoint

## 3) Firebase Configuration

### Authentication
- Enable **Phone** provider.
- Configure test phone numbers for QA.

### Firestore Suggested Collections

- `users/{uid}`
- `users/{uid}/tracking/{yyyy-mm-dd}`
- `users/{uid}/dietPlans/{planId}`
- `users/{uid}/chatSessions/{sessionId}/messages/{messageId}`
- `mentorSessions/{sessionId}`

### Storage Suggested Buckets

- `yoga/`
- `meditation/`
- `recipes/`
- `profile/`

## 4) Razorpay Integration

- Add Android/iOS platform keys from dashboard.
- Keep secret key server-side only.
- Verify payment signature from backend webhook before granting premium.
- Update user membership status in Firestore from trusted backend.

## 5) OTP Mobile Login Flow

1. User enters mobile number.
2. Firebase sends OTP.
3. User submits OTP.
4. App signs in with credential.
5. User profile doc is initialized/updated in Firestore.

## 6) AI Health Chat (Safe Production Pattern)

- Do not call LLM directly from app with private key.
- Route through secure backend / cloud function.
- Log prompt + response metadata (non-sensitive) in Firestore for observability.
- Add medical disclaimer and emergency redirection.

## 7) Premium Membership System

- Free tier: base tracking and limited content.
- Premium tier: AI deep insights, premium videos, mentor sessions, advanced plans.
- Entitlements source of truth: Firestore user membership doc (written by backend after payment verification).

## 8) Testing Strategy

- Unit tests: repositories, recommendation engine, validators.
- Widget tests: OTP login, dashboard navigation, tracker forms.
- Integration tests: auth + payment + entitlement refresh.
- Manual QA: low-network, OTP timeout, payment failure/retry, dark mode contrast.

## 9) Security Hardening

- App Check for Firebase.
- Firestore security rules by `request.auth.uid`.
- Encrypted local storage for sensitive tokens.
- Block rooted/jailbroken devices in high-risk flows (optional).

## 10) Android Release Pipeline

1. Create keystore:
   ```bash
   keytool -genkey -v -keystore fitmitra-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias fitmitra
   ```
2. Add signing config in `android/key.properties` and `build.gradle.kts`.
3. Build appbundle:
   ```bash
   flutter build appbundle --release
   ```
4. Upload `.aab` to Play Console internal testing.
5. Validate policy compliance:
   - Health content disclaimers
   - Data safety form
   - Permissions disclosure
6. Roll out staged release (5% -> 20% -> 100%).

## 11) Observability and Operations

- Crashlytics + Analytics events for critical funnels:
  - otp_sent / otp_verified
  - premium_checkout_started / success / failed
  - chat_prompt_submitted
  - goal_changed
- Add dashboards for retention, conversion, and active premium users.

## 12) Go-live Checklist

- [ ] Firebase production project and keys set
- [ ] Razorpay webhook validation running
- [ ] Security rules reviewed
- [ ] Privacy policy and Terms linked in app + store listing
- [ ] Performance profile under 16ms frame budget on key screens
- [ ] Internal beta sign-off
