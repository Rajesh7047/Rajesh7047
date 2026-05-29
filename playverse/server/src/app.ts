import bcrypt from "bcryptjs";
import cors from "cors";
import dotenv from "dotenv";
import express, { type NextFunction, type Request, type Response } from "express";
import rateLimit from "express-rate-limit";
import helmet from "helmet";
import jwt from "jsonwebtoken";
import { nanoid } from "nanoid";
import pinoHttp from "pino-http";
import { z } from "zod";
import { PlayVerseStore } from "./store.js";
import type { CompatibilityReport, Game, Purchase, SystemRequirements, User } from "./types.js";

dotenv.config();

const jwtSecret = process.env.JWT_SECRET ?? "playverse-local-development-secret";
const clientOrigin = process.env.CLIENT_ORIGIN ?? "http://localhost:5173";

interface AuthenticatedRequest extends Request {
  user?: User;
}

const registerSchema = z.object({
  name: z.string().min(2).max(80),
  email: z.string().email(),
  password: z.string().min(8).max(128),
  favoriteGenres: z.array(z.string()).default([])
});

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1)
});

const reviewSchema = z.object({
  rating: z.number().int().min(1).max(5),
  headline: z.string().min(3).max(120),
  body: z.string().min(10).max(1000)
});

const requirementsSchema = z.object({
  os: z.string().min(2),
  processor: z.string().min(2),
  memoryGb: z.number().positive(),
  gpu: z.string().min(2),
  storageGb: z.number().positive()
});

const gameSchema = z.object({
  title: z.string().min(2).max(120),
  publisher: z.string().min(2),
  developer: z.string().min(2),
  genre: z.string().min(2),
  tags: z.array(z.string()).min(1),
  platforms: z.array(z.string()).min(1),
  price: z.number().nonnegative(),
  discountPercent: z.number().min(0).max(95).default(0),
  heroImage: z.string().url(),
  trailerUrl: z.string().url(),
  description: z.string().min(10),
  longDescription: z.string().min(20),
  releaseDate: z.string().min(4),
  ageRating: z.string().min(1),
  requirements: z.object({
    minimum: requirementsSchema,
    recommended: requirementsSchema
  }),
  downloadSizeGb: z.number().positive(),
  featured: z.boolean().default(false)
});

const checkoutSchema = z.object({
  paymentProvider: z.enum(["card", "paypal", "stripe"]).default("card"),
  systemProfile: requirementsSchema.optional()
});

function signToken(user: User): string {
  return jwt.sign({ sub: user.id, role: user.role }, jwtSecret, { expiresIn: "8h" });
}

function safeUser(user: User) {
  const { passwordHash: _passwordHash, ...rest } = user;
  return rest;
}

function gamePrice(game: Game): number {
  return Number((game.price * (1 - game.discountPercent / 100)).toFixed(2));
}

function cartPayload(store: PlayVerseStore, userId: string) {
  const cart = store.getCart(userId);
  const games = cart.items
    .map((item) => store.findGame(item.gameId))
    .filter((game): game is Game => Boolean(game));
  const subtotal = games.reduce((total, game) => total + game.price, 0);
  const total = games.reduce((total, game) => total + gamePrice(game), 0);
  return {
    items: games.map((game) => ({ game, finalPrice: gamePrice(game) })),
    subtotal: Number(subtotal.toFixed(2)),
    discount: Number((subtotal - total).toFixed(2)),
    total: Number(total.toFixed(2))
  };
}

function compatibilityReport(game: Game, profile?: SystemRequirements): CompatibilityReport {
  if (!profile) {
    return { gameId: game.id, compatible: true, warnings: [] };
  }

  const warnings: string[] = [];
  if (profile.memoryGb < game.requirements.minimum.memoryGb) {
    warnings.push(`Requires at least ${game.requirements.minimum.memoryGb}GB RAM.`);
  }
  if (profile.storageGb < game.requirements.minimum.storageGb) {
    warnings.push(`Requires at least ${game.requirements.minimum.storageGb}GB free storage.`);
  }
  return { gameId: game.id, compatible: warnings.length === 0, warnings };
}

function buildPurchase(store: PlayVerseStore, userId: string, provider: Purchase["paymentProvider"], profile?: SystemRequirements) {
  const cart = cartPayload(store, userId);
  if (cart.items.length === 0) {
    throw Object.assign(new Error("Cart is empty"), { statusCode: 400 });
  }

  const reports = cart.items.map(({ game }) => compatibilityReport(game, profile));
  const incompatible = reports.filter((report) => !report.compatible);
  if (incompatible.length > 0) {
    throw Object.assign(new Error("One or more games do not meet the supplied system profile"), {
      statusCode: 422,
      details: incompatible
    });
  }

  const tax = Number((cart.total * 0.08).toFixed(2));
  const total = Number((cart.total + tax).toFixed(2));
  const gameIds = cart.items.map(({ game }) => game.id);
  const licenseKeys = Object.fromEntries(gameIds.map((gameId) => [gameId, `PV-${nanoid(4).toUpperCase()}-${nanoid(4).toUpperCase()}`]));
  const downloadLinks = Object.fromEntries(gameIds.map((gameId) => [gameId, `/downloads/${gameId}/${nanoid(16)}`]));

  const purchase = store.createPurchase({
    userId,
    gameIds,
    subtotal: cart.subtotal,
    discount: cart.discount,
    tax,
    total,
    paymentProvider: provider,
    licenseKeys,
    downloadLinks
  });
  store.clearCart(userId);
  return { purchase, compatibility: reports };
}

function requireAuth(store: PlayVerseStore) {
  return (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    const header = req.headers.authorization;
    const token = header?.startsWith("Bearer ") ? header.slice(7) : undefined;
    if (!token) {
      res.status(401).json({ error: "Authentication required" });
      return;
    }

    try {
      const payload = jwt.verify(token, jwtSecret) as { sub: string };
      const user = store.findUserById(payload.sub);
      if (!user) {
        res.status(401).json({ error: "Invalid session" });
        return;
      }
      req.user = user;
      next();
    } catch {
      res.status(401).json({ error: "Invalid session" });
    }
  };
}

function requireAdmin(req: AuthenticatedRequest, res: Response, next: NextFunction) {
  if (req.user?.role !== "admin") {
    res.status(403).json({ error: "Admin access required" });
    return;
  }
  next();
}

export async function createApp() {
  const store = await PlayVerseStore.create();
  const app = express();
  const auth = requireAuth(store);

  app.use(helmet());
  app.use(cors({ origin: clientOrigin, credentials: true }));
  app.use(express.json({ limit: "1mb" }));
  app.use(pinoHttp({ enabled: process.env.NODE_ENV !== "test" }));
  app.use(rateLimit({ windowMs: 60_000, limit: 180, standardHeaders: "draft-8", legacyHeaders: false }));

  app.get("/api/health", (_req, res) => {
    res.json({ status: "ok", service: "playverse-api" });
  });

  app.post("/api/auth/register", async (req, res, next) => {
    try {
      const input = registerSchema.parse(req.body);
      if (store.findUserByEmail(input.email)) {
        res.status(409).json({ error: "An account already exists for this email" });
        return;
      }

      const passwordHash = await bcrypt.hash(input.password, 12);
      const initials = input.name
        .split(" ")
        .map((part) => part[0])
        .join("")
        .slice(0, 2)
        .toUpperCase();
      const user = store.createUser({
        name: input.name,
        email: input.email,
        passwordHash,
        role: "customer",
        avatar: initials,
        favoriteGenres: input.favoriteGenres
      });
      res.status(201).json({ user: safeUser(user), token: signToken(user) });
    } catch (error) {
      next(error);
    }
  });

  app.post("/api/auth/login", async (req, res, next) => {
    try {
      const input = loginSchema.parse(req.body);
      const user = store.findUserByEmail(input.email);
      if (!user || !(await bcrypt.compare(input.password, user.passwordHash))) {
        res.status(401).json({ error: "Invalid email or password" });
        return;
      }
      res.json({ user: safeUser(user), token: signToken(user) });
    } catch (error) {
      next(error);
    }
  });

  app.get("/api/me", auth, (req: AuthenticatedRequest, res) => {
    res.json({ user: safeUser(req.user!) });
  });

  app.get("/api/games", (req, res) => {
    const { search, genre, tag, sort = "popular" } = req.query;
    let games = store.listGames();
    if (typeof search === "string" && search.trim()) {
      const query = search.toLowerCase();
      games = games.filter((game) =>
        [game.title, game.publisher, game.developer, game.genre, ...game.tags].some((value) => value.toLowerCase().includes(query))
      );
    }
    if (typeof genre === "string" && genre !== "All") {
      games = games.filter((game) => game.genre === genre);
    }
    if (typeof tag === "string") {
      games = games.filter((game) => game.tags.includes(tag));
    }

    games = [...games].sort((a, b) => {
      if (sort === "price") return gamePrice(a) - gamePrice(b);
      if (sort === "rating") return b.rating - a.rating;
      if (sort === "new") return new Date(b.releaseDate).getTime() - new Date(a.releaseDate).getTime();
      return b.popularityScore - a.popularityScore;
    });

    res.json({
      games: games.map((game) => ({ ...game, finalPrice: gamePrice(game) })),
      genres: Array.from(new Set(store.listGames().map((game) => game.genre)))
    });
  });

  app.get("/api/games/:idOrSlug", (req, res) => {
    const game = store.findGame(req.params.idOrSlug);
    if (!game || !game.active) {
      res.status(404).json({ error: "Game not found" });
      return;
    }
    res.json({
      game: { ...game, finalPrice: gamePrice(game) },
      reviews: store.listReviews(game.id).map((review) => ({
        ...review,
        user: safeUser(store.findUserById(review.userId)!)
      }))
    });
  });

  app.get("/api/recommendations", auth, (req: AuthenticatedRequest, res) => {
    const user = req.user!;
    const owned = new Set(user.ownedGameIds);
    const recommendations = store
      .listGames()
      .filter((game) => !owned.has(game.id))
      .map((game) => ({
        ...game,
        finalPrice: gamePrice(game),
        recommendationScore:
          game.popularityScore + (user.favoriteGenres.includes(game.genre) ? 20 : 0) + (game.discountPercent > 0 ? 8 : 0)
      }))
      .sort((a, b) => b.recommendationScore - a.recommendationScore)
      .slice(0, 4);
    res.json({ recommendations });
  });

  app.get("/api/cart", auth, (req: AuthenticatedRequest, res) => {
    res.json(cartPayload(store, req.user!.id));
  });

  app.post("/api/cart", auth, (req: AuthenticatedRequest, res) => {
    const gameId = z.object({ gameId: z.string() }).parse(req.body).gameId;
    const game = store.findGame(gameId);
    if (!game || !game.active) {
      res.status(404).json({ error: "Game not found" });
      return;
    }
    if (req.user!.ownedGameIds.includes(game.id)) {
      res.status(409).json({ error: "Game already exists in your library" });
      return;
    }
    store.addToCart(req.user!.id, game.id);
    res.status(201).json(cartPayload(store, req.user!.id));
  });

  app.delete("/api/cart/:gameId", auth, (req: AuthenticatedRequest, res) => {
    store.removeFromCart(req.user!.id, req.params.gameId);
    res.json(cartPayload(store, req.user!.id));
  });

  app.get("/api/wishlist", auth, (req: AuthenticatedRequest, res) => {
    const games = req.user!.wishlistGameIds.map((id) => store.findGame(id)).filter((game): game is Game => Boolean(game));
    res.json({ games });
  });

  app.post("/api/wishlist", auth, (req: AuthenticatedRequest, res) => {
    const gameId = z.object({ gameId: z.string() }).parse(req.body).gameId;
    const game = store.findGame(gameId);
    if (!game || !game.active) {
      res.status(404).json({ error: "Game not found" });
      return;
    }
    const wishlistGameIds = store.addWishlist(req.user!.id, game.id);
    res.status(201).json({ wishlistGameIds });
  });

  app.delete("/api/wishlist/:gameId", auth, (req: AuthenticatedRequest, res) => {
    const wishlistGameIds = store.removeWishlist(req.user!.id, req.params.gameId);
    res.json({ wishlistGameIds });
  });

  app.post("/api/checkout", auth, (req: AuthenticatedRequest, res, next) => {
    try {
      const input = checkoutSchema.parse(req.body);
      res.status(201).json(buildPurchase(store, req.user!.id, input.paymentProvider, input.systemProfile));
    } catch (error) {
      next(error);
    }
  });

  app.get("/api/library", auth, (req: AuthenticatedRequest, res) => {
    const games = req.user!.ownedGameIds.map((id) => store.findGame(id)).filter((game): game is Game => Boolean(game));
    const purchases = store.listPurchases(req.user!.id);
    res.json({ games, purchases });
  });

  app.post("/api/games/:gameId/reviews", auth, (req: AuthenticatedRequest, res, next) => {
    try {
      if (!req.user!.ownedGameIds.includes(req.params.gameId)) {
        res.status(403).json({ error: "Only owners can review this game" });
        return;
      }
      const input = reviewSchema.parse(req.body);
      const review = store.addReview({ ...input, gameId: req.params.gameId, userId: req.user!.id });
      res.status(201).json({ review });
    } catch (error) {
      next(error);
    }
  });

  app.get("/api/admin/analytics", auth, requireAdmin, (_req, res) => {
    const purchases = store.listPurchases();
    const revenue = purchases.reduce((total, purchase) => total + purchase.total, 0);
    const unitsByGame = new Map<string, number>();
    for (const purchase of purchases) {
      for (const gameId of purchase.gameIds) unitsByGame.set(gameId, (unitsByGame.get(gameId) ?? 0) + 1);
    }
    res.json({
      totalRevenue: Number(revenue.toFixed(2)),
      totalOrders: purchases.length,
      totalUsers: store.listUsers().length,
      activeGames: store.listGames().length,
      bestSellers: Array.from(unitsByGame.entries()).map(([gameId, units]) => ({ game: store.findGame(gameId), units }))
    });
  });

  app.post("/api/admin/games", auth, requireAdmin, (req, res, next) => {
    try {
      const input = gameSchema.parse(req.body);
      res.status(201).json({ game: store.createGame(input) });
    } catch (error) {
      next(error);
    }
  });

  app.patch("/api/admin/games/:gameId", auth, requireAdmin, (req, res) => {
    const game = store.updateGame(req.params.gameId, req.body);
    if (!game) {
      res.status(404).json({ error: "Game not found" });
      return;
    }
    res.json({ game });
  });

  app.use((error: unknown, _req: Request, res: Response, _next: NextFunction) => {
    if (error instanceof z.ZodError) {
      res.status(400).json({ error: "Validation failed", issues: error.flatten() });
      return;
    }
    const statusCode = typeof error === "object" && error && "statusCode" in error ? Number(error.statusCode) : 500;
    const details = typeof error === "object" && error && "details" in error ? error.details : undefined;
    const message = error instanceof Error ? error.message : "Unexpected server error";
    res.status(statusCode).json({ error: message, details });
  });

  return { app, store };
}
