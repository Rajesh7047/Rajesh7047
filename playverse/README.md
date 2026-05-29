# PlayVerse 🎮

**PlayVerse** is a full-stack gaming e-commerce platform — a feature-rich digital game store similar to Steam — built with React, Node.js, and MongoDB.

## Features

### User Features
- **Game Store** – Browse 12+ games by genre, search, sort by rating/price/popularity
- **Game Details** – Full pages with screenshots, system requirements, and user reviews
- **Shopping Cart** – Add/remove games, view totals, instant checkout
- **Wishlist** – Save games for later across sessions
- **Game Library** – Access all purchased games after checkout
- **User Auth** – Register/login with JWT, profile settings, password management
- **Order History** – View past purchases with full order details

### Admin Features
- **Dashboard** – Live stats: total users, games, orders, revenue; top games and recent orders
- **Game Management** – Full CRUD: create, edit, remove game listings with cover images, genres, system requirements, pricing
- **User Management** – View all users, activate/deactivate accounts
- **Order Management** – Full order history with buyer info

### Technical Highlights
- React 18 + Vite for fast frontend development
- Tailwind CSS v3 with custom gaming-inspired theme
- Node.js + Express REST API with JWT auth
- MongoDB + Mongoose with proper indexing
- Rate limiting, CORS, Helmet security
- Responsive design across all screen sizes

## Tech Stack

| Layer      | Technology                          |
|------------|--------------------------------------|
| Frontend   | React 18, Vite, Tailwind CSS, React Router v6 |
| Backend    | Node.js, Express.js                 |
| Database   | MongoDB, Mongoose                   |
| Auth       | JWT (JSON Web Tokens), bcryptjs     |
| HTTP       | Axios, express-rate-limit, helmet   |

## Getting Started

### Prerequisites
- Node.js 18+
- MongoDB (local or Atlas)

### Installation

```bash
# Install all dependencies
npm run install:all

# Seed the database with sample games and users
npm run seed

# Start development (both servers)
npm run dev
```

The app will be available at:
- Frontend: http://localhost:5173
- Backend API: http://localhost:5000

### Demo Credentials
| Role  | Email                   | Password   |
|-------|-------------------------|------------|
| User  | demo@playverse.com      | User@123   |
| Admin | admin@playverse.com     | Admin@123  |

## Project Structure

```
playverse/
├── client/                    # React + Vite frontend
│   └── src/
│       ├── components/
│       │   ├── game/          # GameCard, GameGrid
│       │   ├── layout/        # Navbar, Footer
│       │   └── ui/            # StarRating, Badge, LoadingSpinner
│       ├── context/           # AuthContext, CartContext
│       ├── pages/             # Home, Store, GameDetail, Cart, etc.
│       ├── services/          # Axios API service layer
│       └── utils/             # Helpers, constants
└── server/                    # Node.js + Express backend
    ├── controllers/           # Business logic
    ├── middleware/            # Auth, error handling
    ├── models/                # User, Game, Order, Cart
    ├── routes/                # API route definitions
    └── config/                # DB connection, seed data
```

## API Endpoints

### Auth
| Method | Endpoint              | Description           |
|--------|-----------------------|-----------------------|
| POST   | /api/auth/register    | Register new user     |
| POST   | /api/auth/login       | Login                 |
| GET    | /api/auth/me          | Get current user      |
| PUT    | /api/auth/profile     | Update profile        |

### Games
| Method | Endpoint              | Description              |
|--------|-----------------------|--------------------------|
| GET    | /api/games            | List/filter games        |
| GET    | /api/games/featured   | Featured games           |
| GET    | /api/games/top-rated  | Top rated games          |
| GET    | /api/games/search     | Search games             |
| GET    | /api/games/:slug      | Game details             |
| POST   | /api/games/:id/reviews| Add review (auth)        |
| POST   | /api/games            | Create game (admin)      |
| PUT    | /api/games/:id        | Update game (admin)      |
| DELETE | /api/games/:id        | Soft-delete game (admin) |

### Cart
| Method | Endpoint              | Description           |
|--------|-----------------------|-----------------------|
| GET    | /api/cart             | Get cart              |
| POST   | /api/cart/add         | Add game to cart      |
| DELETE | /api/cart/item/:id    | Remove from cart      |

### Orders
| Method | Endpoint              | Description           |
|--------|-----------------------|-----------------------|
| POST   | /api/orders           | Checkout cart         |
| GET    | /api/orders/my        | User's order history  |
| GET    | /api/orders/:id       | Order details         |

### Wishlist
| Method | Endpoint              | Description           |
|--------|-----------------------|-----------------------|
| GET    | /api/wishlist         | Get wishlist          |
| POST   | /api/wishlist/toggle  | Toggle game in wishlist|
