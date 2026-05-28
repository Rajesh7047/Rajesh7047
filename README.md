# FitMitra (com.epointdigital.fitmitra)

FitMitra is a premium AI-powered health and wellness Flutter app with modern Material 3 UI, Firebase backend, OTP login, free/premium memberships, goal-based recommendations, mentor sessions, and monetization via Razorpay.

## Highlights

- Material 3 + Dark Mode + smooth animations
- Clean architecture with scalable feature-first folders
- Firebase Auth (OTP), Firestore, Storage integration points
- AI Health chat module foundation
- Diet plans, yoga/meditation/recipes, and live mentor session flow
- Calorie and water tracking
- Goal-aware product recommendations (Weight Loss, Weight Gain, PCOD/Thyroid)
- Razorpay payment service wrapper
- Android Gradle Kotlin DSL support

## Project Structure

```text
lib/
  app/
  core/
  shared/
  features/
```

See full implementation guide in [`docs/setup_to_play_store.md`](docs/setup_to_play_store.md).

## Quick Start

1. Install Flutter SDK (stable) and Android Studio.
2. Run `flutter create . --org com.epointdigital --platforms=android,ios` in this repo if platform folders are incomplete.
3. Run `flutterfire configure` and replace `lib/firebase_options.dart` with generated file.
4. Set Razorpay key and backend endpoints in `lib/core/constants/app_constants.dart`.
5. Install deps: `flutter pub get`.
6. Run app: `flutter run`.
