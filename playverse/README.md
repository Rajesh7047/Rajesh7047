# PlayVerse

A full-stack PC game store built from the BCA project specification: browse, purchase, and manage games with a modern gaming-themed UI.

## Stack

- **Frontend:** React 19, Vite, React Bootstrap, React Router
- **Backend:** Node.js, Express 5, MongoDB (Mongoose)
- **Auth:** JWT, bcrypt password hashing

## Features

- User registration and login
- Game catalog with search, genre filters, and sorting
- Shopping cart and simulated Stripe/PayPal checkout
- Personal library with download/install links
- Wishlist and personalized recommendations
- Reviews and ratings (library owners only)
- Admin dashboard: analytics, add games, deactivate listings

## Quick start

### Prerequisites

- Node.js 18+
- MongoDB running locally (or set `MONGODB_URI`)

### Setup

```bash
cd playverse
npm run install:all
cp server/.env.example server/.env   # if needed
npm run seed --prefix server
npm run dev
```

- **Web app:** http://localhost:5173  
- **API:** http://localhost:5000/api/health  

### Demo accounts

| Role  | Email                 | Password  |
|-------|-----------------------|-----------|
| Admin | admin@playverse.com   | admin123  |
| User  | demo@playverse.com    | demo1234  |

### Production build

```bash
npm run build --prefix client
npm run start --prefix server
```

The API serves the built client from `client/dist`.

## Project structure

```
playverse/
├── client/     React SPA
├── server/     Express API + MongoDB
└── package.json
```

## API overview

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register |
| POST | `/api/auth/login` | Login |
| GET | `/api/games` | List games |
| GET | `/api/games/:slug` | Game detail |
| GET/POST | `/api/cart` | Cart |
| POST | `/api/orders/checkout` | Checkout |
| GET | `/api/admin/stats` | Admin analytics |

## License

Educational project — Mohanlal Sukhadia University BCA.
