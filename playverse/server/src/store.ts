import { nanoid } from "nanoid";
import type { Cart, CartItem, Game, Purchase, Review, User } from "./types.js";
import { buildSeedData, seedGames } from "./data/seed.js";

export interface StoreSnapshot {
  games: Game[];
  users: User[];
  carts: Cart[];
  reviews: Review[];
  purchases: Purchase[];
}

export class PlayVerseStore {
  private games: Game[];
  private users: User[];
  private carts: Cart[];
  private reviews: Review[];
  private purchases: Purchase[];

  private constructor(snapshot: StoreSnapshot) {
    this.games = snapshot.games;
    this.users = snapshot.users;
    this.carts = snapshot.carts;
    this.reviews = snapshot.reviews;
    this.purchases = snapshot.purchases;
  }

  static async create(): Promise<PlayVerseStore> {
    const seed = await buildSeedData();
    return new PlayVerseStore({
      games: structuredClone(seedGames),
      users: seed.users,
      carts: seed.carts,
      reviews: seed.reviews,
      purchases: seed.purchases
    });
  }

  listGames(): Game[] {
    return this.games.filter((game) => game.active);
  }

  findGame(idOrSlug: string): Game | undefined {
    return this.games.find((game) => game.id === idOrSlug || game.slug === idOrSlug);
  }

  createGame(input: Omit<Game, "id" | "slug" | "rating" | "reviewCount" | "popularityScore" | "active">): Game {
    const slug = input.title
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/(^-|-$)/g, "");
    const game: Game = {
      ...input,
      id: `game-${nanoid(10)}`,
      slug,
      rating: 0,
      reviewCount: 0,
      popularityScore: 1,
      active: true
    };
    this.games.push(game);
    return game;
  }

  updateGame(id: string, patch: Partial<Game>): Game | undefined {
    const game = this.findGame(id);
    if (!game) return undefined;
    Object.assign(game, patch, { id: game.id });
    return game;
  }

  findUserById(id: string): User | undefined {
    return this.users.find((user) => user.id === id);
  }

  findUserByEmail(email: string): User | undefined {
    return this.users.find((user) => user.email.toLowerCase() === email.toLowerCase());
  }

  createUser(input: Omit<User, "id" | "ownedGameIds" | "wishlistGameIds" | "createdAt">): User {
    const user: User = {
      ...input,
      id: `user-${nanoid(12)}`,
      ownedGameIds: [],
      wishlistGameIds: [],
      createdAt: new Date().toISOString()
    };
    this.users.push(user);
    this.carts.push({ userId: user.id, items: [], updatedAt: new Date().toISOString() });
    return user;
  }

  getCart(userId: string): Cart {
    let cart = this.carts.find((candidate) => candidate.userId === userId);
    if (!cart) {
      cart = { userId, items: [], updatedAt: new Date().toISOString() };
      this.carts.push(cart);
    }
    return cart;
  }

  addToCart(userId: string, gameId: string): Cart {
    const cart = this.getCart(userId);
    if (!cart.items.some((item) => item.gameId === gameId)) {
      const item: CartItem = { gameId, addedAt: new Date().toISOString() };
      cart.items.push(item);
      cart.updatedAt = item.addedAt;
    }
    return cart;
  }

  removeFromCart(userId: string, gameId: string): Cart {
    const cart = this.getCart(userId);
    cart.items = cart.items.filter((item) => item.gameId !== gameId);
    cart.updatedAt = new Date().toISOString();
    return cart;
  }

  clearCart(userId: string): void {
    const cart = this.getCart(userId);
    cart.items = [];
    cart.updatedAt = new Date().toISOString();
  }

  addWishlist(userId: string, gameId: string): string[] {
    const user = this.findUserById(userId);
    if (!user) return [];
    if (!user.wishlistGameIds.includes(gameId)) user.wishlistGameIds.push(gameId);
    return user.wishlistGameIds;
  }

  removeWishlist(userId: string, gameId: string): string[] {
    const user = this.findUserById(userId);
    if (!user) return [];
    user.wishlistGameIds = user.wishlistGameIds.filter((id) => id !== gameId);
    return user.wishlistGameIds;
  }

  listReviews(gameId: string): Review[] {
    return this.reviews.filter((review) => review.gameId === gameId);
  }

  addReview(input: Omit<Review, "id" | "createdAt">): Review {
    const review: Review = {
      ...input,
      id: `review-${nanoid(12)}`,
      createdAt: new Date().toISOString()
    };
    this.reviews.push(review);
    this.recalculateRating(input.gameId);
    return review;
  }

  createPurchase(input: Omit<Purchase, "id" | "createdAt" | "status">): Purchase {
    const purchase: Purchase = {
      ...input,
      id: `order-${nanoid(12)}`,
      status: "paid",
      createdAt: new Date().toISOString()
    };
    this.purchases.push(purchase);

    const user = this.findUserById(input.userId);
    if (user) {
      for (const gameId of input.gameIds) {
        if (!user.ownedGameIds.includes(gameId)) user.ownedGameIds.push(gameId);
      }
      user.wishlistGameIds = user.wishlistGameIds.filter((id) => !input.gameIds.includes(id));
    }

    return purchase;
  }

  listPurchases(userId?: string): Purchase[] {
    return userId ? this.purchases.filter((purchase) => purchase.userId === userId) : this.purchases;
  }

  listUsers(): User[] {
    return this.users;
  }

  private recalculateRating(gameId: string): void {
    const reviews = this.listReviews(gameId);
    const game = this.findGame(gameId);
    if (!game || reviews.length === 0) return;
    const average = reviews.reduce((total, review) => total + review.rating, 0) / reviews.length;
    game.rating = Number(average.toFixed(1));
    game.reviewCount = reviews.length;
  }
}
