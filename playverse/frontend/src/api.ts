import { CartResponse, Game, Order, User } from "./types";

const API_BASE = import.meta.env.VITE_API_BASE_URL ?? "http://localhost:4000";

class ApiError extends Error {
  status: number;
  constructor(message: string, status: number) {
    super(message);
    this.status = status;
  }
}

const request = async <T>(
  path: string,
  options: RequestInit = {},
  token?: string
): Promise<T> => {
  const response = await fetch(`${API_BASE}${path}`, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...(options.headers ?? {})
    }
  });

  const body = (await response.json().catch(() => null)) as { error?: string } | null;
  if (!response.ok) {
    throw new ApiError(body?.error ?? "Request failed", response.status);
  }

  return body as T;
};

export const api = {
  health: () => request<{ status: string }>("/health"),
  register: (payload: {
    name: string;
    email: string;
    password: string;
    favoriteGenres: string[];
  }) =>
    request<{ token: string; user: User }>("/api/auth/register", {
      method: "POST",
      body: JSON.stringify(payload)
    }),
  login: (payload: { email: string; password: string }) =>
    request<{ token: string; user: User }>("/api/auth/login", {
      method: "POST",
      body: JSON.stringify(payload)
    }),
  listGames: (query?: Record<string, string>) => {
    const qs = query ? `?${new URLSearchParams(query).toString()}` : "";
    return request<{ games: Game[] }>(`/api/games${qs}`);
  },
  getGame: (id: string) => request<{ game: Game }>(`/api/games/${id}`),
  listRecommendations: (token: string) =>
    request<{ games: Game[] }>("/api/games/recommendations/me", {}, token),
  addReview: (
    token: string,
    gameId: string,
    payload: {
      rating: number;
      comment: string;
    }
  ) =>
    request<{ game: Game }>(
      `/api/games/${gameId}/reviews`,
      {
        method: "POST",
        body: JSON.stringify(payload)
      },
      token
    ),
  getCart: (token: string) => request<CartResponse>("/api/cart", {}, token),
  addCartItem: (token: string, gameId: string) =>
    request<CartResponse>(
      "/api/cart/items",
      {
        method: "POST",
        body: JSON.stringify({ gameId })
      },
      token
    ),
  removeCartItem: (token: string, gameId: string) =>
    request<CartResponse>(`/api/cart/items/${gameId}`, { method: "DELETE" }, token),
  checkout: (token: string, paymentMethod: "card" | "paypal" | "upi") =>
    request<{ order: Order; message: string }>(
      "/api/cart/checkout",
      {
        method: "POST",
        body: JSON.stringify({ paymentMethod, currency: "USD" })
      },
      token
    ),
  getLibrary: (token: string) =>
    request<{ games: Array<Game & { readyToInstall: boolean }> }>("/api/library", {}, token),
  getOrders: (token: string) => request<{ orders: Order[] }>("/api/library/orders", {}, token),
  getDownload: (token: string, gameId: string) =>
    request<{ installer: string; notes: string }>(`/api/library/downloads/${gameId}`, {}, token),
  checkCompatibility: (
    token: string,
    gameId: string,
    payload: { os: string; ramGb: number; gpuTier: "low" | "mid" | "high" }
  ) =>
    request<{
      compatible: boolean;
      checks: { os: boolean; ram: boolean; gpu: boolean };
    }>(
      `/api/library/compatibility/${gameId}`,
      {
        method: "POST",
        body: JSON.stringify(payload)
      },
      token
    ),
  getWishlist: (token: string) => request<{ games: Game[] }>("/api/wishlist", {}, token),
  addWishlist: (token: string, gameId: string) =>
    request<{ games: Array<{ userId: string; gameId: string }> }>(
      `/api/wishlist/${gameId}`,
      { method: "POST" },
      token
    ),
  removeWishlist: async (token: string, gameId: string) => {
    await request(`/api/wishlist/${gameId}`, { method: "DELETE" }, token);
  },
  listAdminGames: (token: string) => request<{ games: Game[] }>("/api/admin/games", {}, token),
  createAdminGame: (token: string, payload: Record<string, unknown>) =>
    request<{ game: Game }>(
      "/api/admin/games",
      {
        method: "POST",
        body: JSON.stringify(payload)
      },
      token
    ),
  updateAdminGame: (token: string, gameId: string, payload: Record<string, unknown>) =>
    request<{ game: Game }>(
      `/api/admin/games/${gameId}`,
      {
        method: "PATCH",
        body: JSON.stringify(payload)
      },
      token
    )
};
