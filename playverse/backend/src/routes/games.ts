import { Router } from "express";
import { z } from "zod";
import { appendGameReview, getState } from "../data/store.js";
import { requireAuth } from "../middleware/auth.js";
import { normalize, toPublicGame } from "../services/catalog.js";
import { createId } from "../utils/ids.js";
import { HttpError } from "../utils/httpError.js";

const querySchema = z.object({
  q: z.string().optional(),
  genre: z.string().optional(),
  sort: z.enum(["popular", "price-low", "price-high", "rating"]).optional()
});

const reviewBodySchema = z.object({
  rating: z.number().int().min(1).max(5),
  comment: z.string().min(4).max(800)
});

export const gamesRouter = Router();

gamesRouter.get("/", (req, res, next) => {
  try {
    const query = querySchema.parse(req.query);
    const state = getState();

    const filtered = state.games
      .filter((game) => game.active)
      .filter((game) => {
        if (!query.q) {
          return true;
        }
        const term = normalize(query.q);
        return (
          normalize(game.title).includes(term) ||
          normalize(game.publisher).includes(term) ||
          game.tags.some((tag) => normalize(tag).includes(term))
        );
      })
      .filter((game) => {
        if (!query.genre) {
          return true;
        }
        return normalize(game.genre) === normalize(query.genre);
      })
      .map(toPublicGame);

    const sorted = [...filtered];
    switch (query.sort) {
      case "price-low":
        sorted.sort((a, b) => a.finalPrice - b.finalPrice);
        break;
      case "price-high":
        sorted.sort((a, b) => b.finalPrice - a.finalPrice);
        break;
      case "rating":
        sorted.sort((a, b) => b.averageRating - a.averageRating);
        break;
      default:
        sorted.sort((a, b) => b.totalReviews - a.totalReviews);
        break;
    }

    res.json({ games: sorted });
  } catch (error) {
    next(error);
  }
});

gamesRouter.get("/:gameId", (req, res, next) => {
  try {
    const state = getState();
    const game = state.games.find((record) => record.id === req.params.gameId && record.active);
    if (!game) {
      throw new HttpError("Game not found", 404);
    }
    res.json({ game: toPublicGame(game) });
  } catch (error) {
    next(error);
  }
});

gamesRouter.get("/recommendations/me", requireAuth, (req, res, next) => {
  try {
    const state = getState();
    const user = state.users.find((record) => record.id === req.user?.id);
    if (!user) {
      throw new HttpError("User not found", 404);
    }

    const ownedIds = new Set(
      state.library.filter((item) => item.userId === user.id).map((item) => item.gameId)
    );
    const ownedGenres = new Set(
      state.games
        .filter((game) => ownedIds.has(game.id))
        .map((game) => normalize(game.genre))
    );
    const preferredGenres = new Set([
      ...user.favoriteGenres.map(normalize),
      ...Array.from(ownedGenres)
    ]);

    const recommended = state.games
      .filter((game) => game.active && !ownedIds.has(game.id))
      .filter((game) => preferredGenres.has(normalize(game.genre)))
      .map(toPublicGame)
      .sort((a, b) => b.averageRating - a.averageRating || b.discountPercent - a.discountPercent)
      .slice(0, 6);

    res.json({ games: recommended });
  } catch (error) {
    next(error);
  }
});

gamesRouter.post("/:gameId/reviews", requireAuth, (req, res, next) => {
  try {
    const body = reviewBodySchema.parse(req.body);
    const state = getState();
    const game = state.games.find((record) => record.id === req.params.gameId);
    if (!game || !game.active) {
      throw new HttpError("Game not found", 404);
    }

    const hasPurchased = state.library.some(
      (item) => item.userId === req.user?.id && item.gameId === req.params.gameId
    );
    if (!hasPurchased) {
      throw new HttpError("Only owners can review this game", 403);
    }

    const alreadyReviewed = game.reviews.some((review) => review.userId === req.user?.id);
    if (alreadyReviewed) {
      throw new HttpError("You have already reviewed this game", 409);
    }

    const review = {
      id: createId("r"),
      userId: req.user!.id,
      userName: req.user!.name,
      rating: body.rating,
      comment: body.comment,
      createdAt: new Date().toISOString()
    };
    const updatedGame = appendGameReview(game.id, review);
    if (!updatedGame) {
      throw new HttpError("Failed to append review", 500);
    }

    res.status(201).json({
      game: toPublicGame(updatedGame)
    });
  } catch (error) {
    next(error);
  }
});
