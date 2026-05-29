import { emptyCart, fallbackGames, fallbackPurchase, fallbackUser } from "../data/fallback";
import type { CartView, Game, Purchase, User } from "../types";

const apiBase = import.meta.env.VITE_API_URL ?? "";

async function request<T>(path: string, options: RequestInit = {}): Promise<T> {
  const token = localStorage.getItem("playverse.token");
  const response = await fetch(`${apiBase}${path}`, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers
    }
  });

  if (!response.ok) {
    const body = await response.json().catch(() => ({}));
    throw new Error(body.error ?? `Request failed with ${response.status}`);
  }

  return response.json() as Promise<T>;
}

export async function getCatalog(search = "", genre = "All", sort = "popular"): Promise<{ games: Game[]; genres: string[] }> {
  try {
    const params = new URLSearchParams({ search, genre, sort });
    return await request<{ games: Game[]; genres: string[] }>(`/api/games?${params.toString()}`);
  } catch {
    const query = search.toLowerCase();
    const games = fallbackGames.filter((game) => {
      const matchesSearch = !query || [game.title, game.publisher, game.genre, ...game.tags].some((value) => value.toLowerCase().includes(query));
      const matchesGenre = genre === "All" || game.genre === genre;
      return matchesSearch && matchesGenre;
    });
    return { games, genres: Array.from(new Set(fallbackGames.map((game) => game.genre))) };
  }
}

export async function loginDemo(kind: "customer" | "admin" = "customer"): Promise<{ user: User; token: string }> {
  try {
    const email = kind === "admin" ? "admin@playverse.test" : "player@playverse.test";
    const password = kind === "admin" ? "AdminPass123" : "PlayerPass123";
    return await request<{ user: User; token: string }>("/api/auth/login", {
      method: "POST",
      body: JSON.stringify({ email, password })
    });
  } catch {
    return { user: { ...fallbackUser, role: kind === "admin" ? "admin" : "customer" }, token: "demo-token" };
  }
}

export async function getCart(): Promise<CartView> {
  try {
    return await request<CartView>("/api/cart");
  } catch {
    return emptyCart;
  }
}

export async function addToCart(gameId: string): Promise<CartView> {
  try {
    return await request<CartView>("/api/cart", { method: "POST", body: JSON.stringify({ gameId }) });
  } catch {
    const game = fallbackGames.find((candidate) => candidate.id === gameId);
    if (!game) return emptyCart;
    return {
      items: [{ game, finalPrice: game.finalPrice ?? game.price }],
      subtotal: game.price,
      discount: Number((game.price - (game.finalPrice ?? game.price)).toFixed(2)),
      total: game.finalPrice ?? game.price
    };
  }
}

export async function checkout(): Promise<{ purchase: Purchase }> {
  try {
    return await request<{ purchase: Purchase }>("/api/checkout", {
      method: "POST",
      body: JSON.stringify({
        paymentProvider: "stripe",
        systemProfile: { os: "Windows 11", processor: "Ryzen 7", memoryGb: 32, gpu: "RTX 4070", storageGb: 200 }
      })
    });
  } catch {
    return { purchase: fallbackPurchase };
  }
}

export async function getLibrary(): Promise<{ games: Game[]; purchases: Purchase[] }> {
  try {
    return await request<{ games: Game[]; purchases: Purchase[] }>("/api/library");
  } catch {
    return { games: fallbackGames.filter((game) => fallbackUser.ownedGameIds.includes(game.id)), purchases: [fallbackPurchase] };
  }
}

export async function getRecommendations(): Promise<Game[]> {
  try {
    const response = await request<{ recommendations: Game[] }>("/api/recommendations");
    return response.recommendations;
  } catch {
    return fallbackGames.filter((game) => !fallbackUser.ownedGameIds.includes(game.id)).slice(0, 3);
  }
}

export async function getAnalytics(): Promise<{ totalRevenue: number; totalOrders: number; totalUsers: number; activeGames: number }> {
  try {
    return await request("/api/admin/analytics");
  } catch {
    return { totalRevenue: 128420, totalOrders: 2841, totalUsers: 18340, activeGames: fallbackGames.length };
  }
}
