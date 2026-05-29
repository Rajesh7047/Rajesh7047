import request from "supertest";
import { beforeEach, describe, expect, it } from "vitest";
import { app } from "../app.js";
import { resetState } from "../data/store.js";

describe("PlayVerse API", () => {
  beforeEach(() => {
    resetState();
  });

  it("responds with service health", async () => {
    const response = await request(app).get("/health");
    expect(response.status).toBe(200);
    expect(response.body.status).toBe("ok");
  });

  it("supports user registration and login", async () => {
    const register = await request(app).post("/api/auth/register").send({
      name: "QA User",
      email: "qa.user@playverse.dev",
      password: "StrongPass#123",
      favoriteGenres: ["rpg"]
    });

    expect(register.status).toBe(201);
    expect(register.body.token).toBeTruthy();

    const login = await request(app).post("/api/auth/login").send({
      email: "qa.user@playverse.dev",
      password: "StrongPass#123"
    });

    expect(login.status).toBe(200);
    expect(login.body.user.email).toBe("qa.user@playverse.dev");
  });

  it("lists games with filtering", async () => {
    const response = await request(app)
      .get("/api/games")
      .query({ genre: "rpg", sort: "rating" });

    expect(response.status).toBe(200);
    expect(response.body.games.length).toBeGreaterThan(0);
    expect(response.body.games.every((game: { genre: string }) => game.genre === "rpg")).toBe(
      true
    );
  });

  it("allows checkout and exposes library items", async () => {
    const login = await request(app).post("/api/auth/login").send({
      email: "demo@playverse.dev",
      password: "Demo@1234"
    });
    const token = login.body.token as string;

    const addToCart = await request(app)
      .post("/api/cart/items")
      .set("Authorization", `Bearer ${token}`)
      .send({ gameId: "g-2" });
    expect(addToCart.status).toBe(201);

    const checkout = await request(app)
      .post("/api/cart/checkout")
      .set("Authorization", `Bearer ${token}`)
      .send({ paymentMethod: "card", currency: "USD" });
    expect(checkout.status).toBe(201);

    const library = await request(app)
      .get("/api/library")
      .set("Authorization", `Bearer ${token}`);
    expect(library.status).toBe(200);
    expect(library.body.games.some((game: { id: string }) => game.id === "g-2")).toBe(true);
  });
});
