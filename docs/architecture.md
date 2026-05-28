# FitMitra Clean Architecture Overview

## Layers

- **Presentation**: screens, widgets, view controllers (Riverpod StateNotifiers)
- **Domain**: entities and repository contracts
- **Data**: Firebase-backed repository implementations and DTO mapping
- **Core**: cross-cutting concerns (theme, routing, constants, services)
- **Shared**: reusable models and widgets

## Feature Modules

- `auth`: OTP login with Firebase Auth
- `tracking`: daily calories/water tracker + Firestore persistence
- `diet`: personalized plans by goal
- `chat`: AI health assistant conversation flow
- `media`: yoga, meditation, and recipes video catalog
- `sessions`: mentor live session listing with Zoom links
- `membership`: free/premium entitlement and payment-triggered upgrade
- `recommendations`: goal-based wellness product recommendations

## Scaling Guidelines

1. Add each new capability as a feature module under `lib/features/<name>`.
2. Keep remote DTOs in `data/models`, domain entities in `domain`, and state in `application`.
3. Route backend secrets through a secure API layer, never directly from app.
4. Keep premium entitlements server-authoritative.
