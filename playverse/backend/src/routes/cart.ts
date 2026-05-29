import { Router } from "express";
import { z } from "zod";
import { addLibraryItems, addOrder, getState, saveCart } from "../data/store.js";
import { requireAuth } from "../middleware/auth.js";
import { computeFinalPrice, toPublicGame } from "../services/catalog.js";
import { createId } from "../utils/ids.js";
import { HttpError } from "../utils/httpError.js";

const cartBodySchema = z.object({
  gameId: z.string().min(1),
  quantity: z.number().int().min(1).max(1).default(1)
});

const checkoutBodySchema = z.object({
  paymentMethod: z.enum(["card", "paypal", "upi"]),
  currency: z.literal("USD").default("USD")
});

const calculateCart = (userId: string) => {
  const state = getState();
  const cart = state.carts[userId] ?? [];
  const items = cart
    .map((item) => {
      const game = state.games.find((record) => record.id === item.gameId && record.active);
      if (!game) {
        return null;
      }
      return {
        game: toPublicGame(game),
        quantity: item.quantity,
        lineTotal: Number((computeFinalPrice(game) * item.quantity).toFixed(2))
      };
    })
    .filter((item): item is NonNullable<typeof item> => item !== null);

  const total = Number(items.reduce((acc, item) => acc + item.lineTotal, 0).toFixed(2));
  return { items, total };
};

export const cartRouter = Router();

cartRouter.use(requireAuth);

cartRouter.get("/", (req, res) => {
  res.json(calculateCart(req.user!.id));
});

cartRouter.post("/items", (req, res, next) => {
  try {
    const body = cartBodySchema.parse(req.body);
    const state = getState();
    const game = state.games.find((record) => record.id === body.gameId && record.active);
    if (!game) {
      throw new HttpError("Game not found", 404);
    }

    const alreadyOwned = state.library.some(
      (item) => item.userId === req.user!.id && item.gameId === body.gameId
    );
    if (alreadyOwned) {
      throw new HttpError("Game already present in your library", 409);
    }

    const current = state.carts[req.user!.id] ?? [];
    if (!current.some((item) => item.gameId === body.gameId)) {
      current.push({ gameId: body.gameId, quantity: body.quantity });
    }
    saveCart(req.user!.id, current);

    res.status(201).json(calculateCart(req.user!.id));
  } catch (error) {
    next(error);
  }
});

cartRouter.delete("/items/:gameId", (req, res) => {
  const state = getState();
  const filtered = (state.carts[req.user!.id] ?? []).filter(
    (item) => item.gameId !== req.params.gameId
  );
  saveCart(req.user!.id, filtered);
  res.json(calculateCart(req.user!.id));
});

cartRouter.post("/checkout", (req, res, next) => {
  try {
    const body = checkoutBodySchema.parse(req.body);
    const state = getState();
    const cart = state.carts[req.user!.id] ?? [];
    if (cart.length === 0) {
      throw new HttpError("Cart is empty", 400);
    }

    const gameIds = cart.map((item) => item.gameId);
    const totalAmount = Number(
      gameIds
        .map((gameId) => state.games.find((item) => item.id === gameId))
        .filter((item): item is NonNullable<typeof item> => Boolean(item))
        .reduce((acc, game) => acc + computeFinalPrice(game), 0)
        .toFixed(2)
    );

    const order = addOrder({
      id: createId("order"),
      userId: req.user!.id,
      gameIds,
      amountPaid: totalAmount,
      paymentMethod: body.paymentMethod,
      status: "paid",
      createdAt: new Date().toISOString()
    });

    addLibraryItems(
      gameIds.map((gameId) => ({
        userId: req.user!.id,
        gameId,
        orderId: order.id,
        addedAt: new Date().toISOString()
      }))
    );
    saveCart(req.user!.id, []);

    res.status(201).json({
      order,
      message:
        "Payment successful. Download links and installer setup are now available in your library."
    });
  } catch (error) {
    next(error);
  }
});
