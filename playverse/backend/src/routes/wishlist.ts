import { Router } from "express";
import { getState, saveWishlist } from "../data/store.js";
import { requireAuth } from "../middleware/auth.js";
import { toPublicGame } from "../services/catalog.js";
import { HttpError } from "../utils/httpError.js";

export const wishlistRouter = Router();
wishlistRouter.use(requireAuth);

wishlistRouter.get("/", (req, res) => {
  const state = getState();
  const gameIds = new Set(
    state.wishlists.filter((item) => item.userId === req.user!.id).map((item) => item.gameId)
  );
  const games = state.games
    .filter((game) => game.active && gameIds.has(game.id))
    .map(toPublicGame);
  res.json({ games });
});

wishlistRouter.post("/:gameId", (req, res, next) => {
  try {
    const state = getState();
    const game = state.games.find((record) => record.id === req.params.gameId && record.active);
    if (!game) {
      throw new HttpError("Game not found", 404);
    }

    const current = state.wishlists.filter((item) => item.userId === req.user!.id);
    if (!current.some((item) => item.gameId === req.params.gameId)) {
      current.push({
        userId: req.user!.id,
        gameId: req.params.gameId,
        addedAt: new Date().toISOString()
      });
    }
    saveWishlist(req.user!.id, current);
    res.status(201).json({ games: current });
  } catch (error) {
    next(error);
  }
});

wishlistRouter.delete("/:gameId", (req, res) => {
  const state = getState();
  const current = state.wishlists
    .filter((item) => item.userId === req.user!.id)
    .filter((item) => item.gameId !== req.params.gameId);
  saveWishlist(req.user!.id, current);
  res.status(204).send();
});
