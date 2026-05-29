import request from "supertest";
import { beforeAll, describe, expect, it } from "vitest";
import { createApp } from "../src/app.js";

let api: ReturnType<typeof request>;

beforeAll(async () => {
  process.env.NODE_ENV = "test";
  const { app } = await createApp();
  api = request(app);
});

async function login(email = "player@playverse.test", password = "PlayerPass123") {
  const response = await api.post("/api/auth/login").send({ email, password }).expect(200);
  return response.body.token as string;
}

describe("PlayVerse API", () => {
  it("serves the game catalog with searchable metadata", async () => {
    const response = await api.get("/api/games?search=neon&sort=rating").expect(200);

    expect(response.body.games).toHaveLength(1);
    expect(response.body.games[0].slug).toBe("neon-odyssey");
    expect(response.body.genres).toContain("Action RPG");
  });

  it("registers users and protects authenticated profile data", async () => {
    const register = await api
      .post("/api/auth/register")
      .send({ name: "Maya Quest", email: "maya@example.com", password: "StrongPass123", favoriteGenres: ["Adventure"] })
      .expect(201);

    expect(register.body.user.email).toBe("maya@example.com");
    expect(register.body.user.passwordHash).toBeUndefined();

    const profile = await api.get("/api/me").set("Authorization", `Bearer ${register.body.token}`).expect(200);
    expect(profile.body.user.favoriteGenres).toEqual(["Adventure"]);
  });

  it("checks out cart items into a licensed game library", async () => {
    const token = await login();

    await api.post("/api/cart").set("Authorization", `Bearer ${token}`).send({ gameId: "game-neon-odyssey" }).expect(201);
    const checkout = await api
      .post("/api/checkout")
      .set("Authorization", `Bearer ${token}`)
      .send({
        paymentProvider: "stripe",
        systemProfile: { os: "Windows 11", processor: "Ryzen 7", memoryGb: 32, gpu: "RTX 4080", storageGb: 200 }
      })
      .expect(201);

    expect(checkout.body.purchase.status).toBe("paid");
    expect(checkout.body.purchase.licenseKeys["game-neon-odyssey"]).toMatch(/^PV-/);

    const library = await api.get("/api/library").set("Authorization", `Bearer ${token}`).expect(200);
    expect(library.body.games.map((game: { id: string }) => game.id)).toContain("game-neon-odyssey");
  });

  it("requires ownership before accepting reviews", async () => {
    const token = await login();

    await api
      .post("/api/games/game-astral-forge/reviews")
      .set("Authorization", `Bearer ${token}`)
      .send({ rating: 5, headline: "Excellent", body: "A thoughtful strategy sandbox." })
      .expect(403);
  });

  it("allows admins to publish catalog entries and inspect analytics", async () => {
    const token = await login("admin@playverse.test", "AdminPass123");
    const game = {
      title: "Shadow Circuit",
      publisher: "Circuit House",
      developer: "Circuit House",
      genre: "Shooter",
      tags: ["Co-op", "Tactical"],
      platforms: ["Windows"],
      price: 34.99,
      discountPercent: 5,
      heroImage: "https://images.unsplash.com/photo-1493711662062-fa541adb3fc8?auto=format&fit=crop&w=1200&q=80",
      trailerUrl: "https://example.com/trailers/shadow-circuit",
      description: "Squad-based tactical action with destructible arenas.",
      longDescription: "Shadow Circuit rewards careful planning, synchronized breaches, and adaptive AI counter-play.",
      releaseDate: "2026-08-10",
      ageRating: "16+",
      requirements: {
        minimum: { os: "Windows 10", processor: "Intel i5", memoryGb: 8, gpu: "GTX 1060", storageGb: 55 },
        recommended: { os: "Windows 11", processor: "Ryzen 7", memoryGb: 16, gpu: "RTX 3060", storageGb: 55 }
      },
      downloadSizeGb: 51,
      featured: false
    };

    const created = await api.post("/api/admin/games").set("Authorization", `Bearer ${token}`).send(game).expect(201);
    expect(created.body.game.slug).toBe("shadow-circuit");

    const analytics = await api.get("/api/admin/analytics").set("Authorization", `Bearer ${token}`).expect(200);
    expect(analytics.body.activeGames).toBeGreaterThanOrEqual(6);
  });
});
