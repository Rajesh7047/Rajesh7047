# PlayVerse

PlayVerse is a professional full-stack build of the gaming marketplace described in the uploaded project report. It includes a polished React storefront, an Express API, seeded game data, JWT authentication, cart and wishlist flows, checkout/license generation, system compatibility checks, reviews, recommendations, and an admin dashboard.

## Stack

- Client: React, TypeScript, Vite, responsive CSS, Lucide icons
- API: Node.js, Express, TypeScript, Zod validation, JWT, bcrypt, Helmet, rate limiting
- Testing: Vitest and Supertest for core API workflows

The local implementation uses an in-memory data store seeded at API startup so reviewers can run the project without external infrastructure. The domain boundaries mirror the report's intended MongoDB collections: users, admins, games, carts, purchases, and reviews.

## Run locally

```bash
cd playverse
npm install
cp .env.example .env
npm run dev:server
```

In a second terminal:

```bash
cd playverse
npm run dev:client
```

- Client: http://localhost:5173
- API health: http://localhost:4000/api/health

## Build as an installable application

PlayVerse is also configured as a Progressive Web App (PWA), so the production client can be installed from Chrome, Edge, or other supported browsers as a desktop/mobile application.

```bash
cd playverse
npm run build
npm run preview --workspace client
```

Then open the preview URL, use the **Install app** button in the PlayVerse header, or choose the browser's install option from the address bar/menu.

Application features included:

- `manifest.webmanifest` with app identity, shortcuts, theme color, and icons
- SVG application icons, including a maskable icon
- Production service worker registration
- Cached app shell and offline fallback screen
- Standalone display mode for desktop/mobile launchers

## Seeded accounts

| Role | Email | Password |
| --- | --- | --- |
| Customer | `player@playverse.test` | `PlayerPass123` |
| Admin | `admin@playverse.test` | `AdminPass123` |

## Available scripts

```bash
npm run dev:server   # Start the Express API with hot reload
npm run dev:client   # Start the Vite client
npm run build        # Type-check and build both workspaces
npm run test         # Run API tests
npm run typecheck    # Type-check both workspaces
```

## API coverage

- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/me`
- `GET /api/games`
- `GET /api/games/:idOrSlug`
- `GET /api/recommendations`
- `GET /api/cart`
- `POST /api/cart`
- `DELETE /api/cart/:gameId`
- `GET /api/wishlist`
- `POST /api/wishlist`
- `DELETE /api/wishlist/:gameId`
- `POST /api/checkout`
- `GET /api/library`
- `POST /api/games/:gameId/reviews`
- `GET /api/admin/analytics`
- `POST /api/admin/games`
- `PATCH /api/admin/games/:gameId`

## Professional enhancements over the report prototype

- Role-based admin controls and protected operations
- Validation on auth, checkout, reviews, and catalog creation
- Password hashing and signed JWT sessions
- Secure HTTP headers and rate limiting
- Checkout compatibility checks using supplied PC requirements
- License key and installer-link generation after payment
- Test coverage for catalog, auth, checkout, review authorization, and admin publishing
- Responsive storefront with fallbacks for demo browsing if the API is offline
- Installable PWA shell with offline fallback behavior

## Production next steps

1. Replace the in-memory store with MongoDB repositories using the same domain models.
2. Wire the payment boundary to Stripe/PayPal webhooks.
3. Store installer assets in object storage behind signed URLs.
4. Add moderation queues for reviews and admin audit logs.
5. Add end-to-end browser tests for checkout and library workflows.
