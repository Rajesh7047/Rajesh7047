# FitMitra - AI-Powered Health & Wellness App

**Your AI Health & Wellness Companion**

A premium Flutter application for comprehensive health management with AI-powered features, personalized diet plans, yoga sessions, meditation, and more.

## Features

### Core Features
- **OTP Mobile Login** - Firebase Phone Authentication with SMS verification
- **AI Health Chat** - Intelligent chatbot for diet advice, exercise tips, and health guidance
- **Personalized Diet Plans** - Goal-based plans (Weight Loss, Weight Gain, PCOD/Thyroid, Muscle Building)
- **Calorie & Water Tracking** - Daily tracking with visual progress indicators
- **Yoga & Exercise Videos** - Guided sessions for all fitness levels
- **Meditation & Mindfulness** - Breathing exercises, guided meditations, mood tracking
- **Healthy Recipe Videos** - Indian cuisine recipes with step-by-step instructions
- **Product Recommendations** - Goal-based health product suggestions
- **Live Mentor Sessions** - Zoom-based expert consultations
- **Premium Membership** - Monthly/Yearly subscription plans via Razorpay

### Technical Features
- **Material 3 UI** - Modern design system with dynamic theming
- **Dark Mode** - Full dark/light theme support with persistence
- **Clean Architecture** - Feature-based folder structure with separation of concerns
- **State Management** - Flutter Riverpod for reactive state management
- **Firebase Integration** - Auth, Firestore, Storage
- **Razorpay Payments** - Secure payment processing
- **Responsive UI** - Adaptive layouts for phones and tablets
- **Smooth Animations** - Flutter Animate for polished transitions
- **Reusable Widgets** - CustomButton, CustomCard, PremiumBadge, SectionHeader, etc.

## Project Structure

```
lib/
├── core/
│   ├── constants/       # App constants, asset paths
│   ├── theme/           # Colors, Material 3 theme
│   ├── utils/           # Extensions, validators, responsive helpers
│   ├── widgets/         # Reusable widgets (buttons, cards, loading, etc.)
│   ├── services/        # Firebase, Auth, Firestore, Theme services
│   └── routes/          # App routing and navigation
├── features/
│   ├── auth/            # Login, OTP, Profile setup
│   ├── home/            # Dashboard with quick actions
│   ├── profile/         # User profile and settings
│   ├── membership/      # Premium plans and subscription
│   ├── ai_chat/         # AI health chatbot
│   ├── diet_plan/       # Personalized diet plans
│   ├── yoga/            # Yoga video sessions
│   ├── meditation/      # Meditation and mindfulness
│   ├── recipes/         # Healthy recipe collection
│   ├── products/        # Product recommendations
│   ├── tracking/        # Calorie, water, exercise tracking
│   ├── payments/        # Razorpay payment integration
│   └── mentor/          # Live expert sessions
└── main.dart            # App entry point
```

## Setup Instructions

### Prerequisites
- Flutter SDK 3.27+ (Dart 3.6+)
- Android Studio / VS Code
- Firebase project configured
- Razorpay account (for payments)

### Step 1: Clone and Install Dependencies
```bash
git clone <repository-url>
cd fitmitra
flutter pub get
```

### Step 2: Firebase Configuration
1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add Android app with package name `com.epointdigital.fitmitra`
3. Download `google-services.json` and place in `android/app/`
4. Enable **Phone Authentication** in Firebase Console
5. Set up **Cloud Firestore** database
6. Set up **Firebase Storage**
7. Uncomment the Google Services plugin in `android/app/build.gradle`:
   ```gradle
   id "com.google.gms.google-services"
   ```
8. Uncomment Firebase initialization in `lib/main.dart`:
   ```dart
   await FirebaseService.initialize();
   ```

### Step 3: Razorpay Configuration
1. Create a Razorpay account at [razorpay.com](https://razorpay.com)
2. Get your API Key ID and Secret
3. Update `lib/core/constants/app_constants.dart` with your keys:
   ```dart
   static const String razorpayKeyId = 'rzp_live_YOUR_KEY';
   static const String razorpayKeySecret = 'YOUR_SECRET';
   ```

### Step 4: Add Font Files
Download Poppins font from Google Fonts and place in `assets/fonts/`:
- Poppins-Light.ttf
- Poppins-Regular.ttf
- Poppins-Medium.ttf
- Poppins-SemiBold.ttf
- Poppins-Bold.ttf

### Step 5: Run the App
```bash
flutter run
```

## Build for Production

### Generate APK
```bash
flutter build apk --release
```

### Generate App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### Play Store Release Checklist
1. Create a signing keystore: `keytool -genkey -v -keystore fitmitra-key.jks -alias fitmitra -keyalg RSA -keysize 2048 -validity 10000`
2. Configure signing in `android/app/build.gradle`
3. Update version in `pubspec.yaml`
4. Prepare Play Store listing (screenshots, descriptions, privacy policy)
5. Upload AAB to Google Play Console
6. Complete store listing and submit for review

## Firestore Data Structure

```
users/
  {userId}/
    name, phone, email, age, weight, height, gender, goal
    isPremium, premiumExpiry, createdAt, updatedAt

daily_tracking/
  {userId}_{date}/
    waterIntakeMl, caloriesConsumed, exerciseMinutes
    meals[], weight, mood

ai_chats/
  {userId}/messages/
    text, isUser, timestamp

diet_plans/
  {planId}/
    name, goal, totalCalories, meals[]

mentor_sessions/
  {sessionId}/
    mentorName, userId, dateTime, zoomLink, status

orders/
  {orderId}/
    userId, amount, plan, paymentId, status, createdAt
```

## Health Goals Supported
- **Weight Loss** - Calorie-deficit plans, fat-burning yoga
- **Weight Gain** - High-calorie nutrition, muscle-building exercises
- **PCOD/Thyroid** - Anti-inflammatory diet, hormonal balance yoga
- **Muscle Building** - High-protein plans, strength training
- **General Fitness** - Balanced nutrition, daily wellness
- **Stress Relief** - Meditation, pranayama, calming foods

## Tech Stack
- **Framework**: Flutter 3.27+ (Dart 3.6+)
- **State Management**: Riverpod
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Payments**: Razorpay
- **UI**: Material 3, Google Fonts, Flutter Animate
- **Charts**: FL Chart, Percent Indicator
- **Video**: YouTube Player, URL Launcher

## License
Proprietary - ePoint Digital
