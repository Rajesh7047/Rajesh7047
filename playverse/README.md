# PlayVerse

Production-grade implementation of the PlayVerse project described in the uploaded report.

## What is included

- **Frontend**: React + TypeScript + Vite
- **Backend**: Node.js + Express + TypeScript API
- **Security defaults**: Helmet, CORS, JWT auth, bcrypt password hashing, Zod validation
- **Core product flows**:
  - registration/login
  - game catalog with search/filter/sort
  - cart + checkout flow
  - owned library + simulated installer links
  - compatibility checks
  - wishlist
  - post-purchase reviews and ratings
  - personalized recommendations
  - admin game management panel
- **Testing**: API integration tests with Vitest + Supertest

## Demo credentials

- User: `demo@playverse.dev` / `Demo@1234`
- Admin: `admin@playverse.dev` / `Admin@123`

## Quick start

```bash
cd /workspace/playverse
npm install
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env
```

Run backend:

```bash
npm run dev -w backend
```

Run frontend (new terminal):

```bash
npm run dev -w frontend
```

Open `http://localhost:5173`.

## Scripts

From `playverse/`:

- `npm run test` - run backend tests
- `npm run lint` - lint backend + frontend
- `npm run build` - type-check and build both packages

## API highlights

- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/games`
- `GET /api/games/recommendations/me`
- `POST /api/cart/items`
- `POST /api/cart/checkout`
- `GET /api/library`
- `GET /api/library/downloads/:gameId`
- `POST /api/library/compatibility/:gameId`
- `POST /api/games/:gameId/reviews`
- `GET /api/admin/games`
- `POST /api/admin/games`
- `PATCH /api/admin/games/:gameId`

## Implementation notes

- This build uses a seeded in-memory data store for repeatable demos and tests.
- The architecture is prepared for swapping storage to MongoDB repositories without changing API contracts.
- Payment and installer delivery are simulated at API level for safety in non-production environments.
