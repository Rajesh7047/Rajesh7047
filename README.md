# FitMitra

**FitMitra** (`com.epointdigital.fitmitra`) is a premium AI-powered health & wellness Flutter app by Epoint Digital. It includes OTP mobile login, Firebase backend, free & premium membership, AI health chat, personalized diet plans, yoga/meditation/recipe videos, live Zoom mentor sessions, calorie & water tracking, goal-based product recommendations, Razorpay payments, Material 3 UI, and dark mode.

## Quick start

```bash
# 1. Install Flutter 3.16+ and Firebase CLI
# 2. Clone and install dependencies
flutter pub get

# 3. Configure Firebase (see docs/DEVELOPMENT_GUIDE.md)
flutterfire configure
cp .env.example .env   # Add Razorpay & OpenAI keys

# 4. Run on device/emulator
flutter run
```

## Architecture

Clean architecture with feature-first folders:

```
lib/
├── core/          # Theme, router, constants, providers
├── domain/        # Entities & repository interfaces
├── data/          # Firebase implementations & demo seed data
├── features/      # UI per feature (auth, home, tracking, …)
└── shared/        # Reusable widgets & services
```

## Features

| Feature | Free | Premium |
|---------|------|---------|
| OTP login | ✓ | ✓ |
| Calorie & water tracking | ✓ | ✓ |
| AI health chat | 5 msgs/day | Unlimited |
| Yoga / meditation / recipes | Previews | Full library |
| Personalized diet plans | — | ✓ |
| Live Zoom mentors | — | ✓ |
| Goal-based products | ✓ | ✓ |

## Documentation

Full setup → Play Store guide: **[docs/DEVELOPMENT_GUIDE.md](docs/DEVELOPMENT_GUIDE.md)**

## Package ID

`com.epointdigital.fitmitra`

## License

Proprietary — Epoint Digital.
