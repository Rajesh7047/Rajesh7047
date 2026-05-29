import { Router } from "express";
import { z } from "zod";
import { getState, updateGame } from "../data/store.js";
import { requireAdmin, requireAuth } from "../middleware/auth.js";
import { toPublicGame } from "../services/catalog.js";
import { createId } from "../utils/ids.js";
import { HttpError } from "../utils/httpError.js";

const gamePayloadSchema = z.object({
  title: z.string().min(2),
  publisher: z.string().min(2),
  genre: z.string().min(2),
  description: z.string().min(10),
  price: z.number().positive(),
  discountPercent: z.number().min(0).max(90).default(0),
  tags: z.array(z.string().min(2)).min(1),
  heroImage: z.string().url(),
  downloadUrl: z.string().url(),
  minSystemRequirements: z.object({
    os: z.string().min(2),
    cpu: z.string().min(2),
    ram: z.string().min(2),
    gpu: z.string().min(2),
    storage: z.string().min(2)
  })
});

const gamePatchSchema = gamePayloadSchema.partial().extend({
  active: z.boolean().optional()
});

const slugify = (value: string): string =>
  value
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-|-$)+/g, "");

export const adminRouter = Router();
adminRouter.use(requireAuth, requireAdmin);

adminRouter.get("/games", (_req, res) => {
  const games = getState().games.map(toPublicGame);
  res.json({ games });
});

adminRouter.post("/games", (req, res, next) => {
  try {
    const body = gamePayloadSchema.parse(req.body);
    const created = updateGame({
      id: createId("g"),
      slug: slugify(body.title),
      title: body.title,
      publisher: body.publisher,
      genre: body.genre,
      description: body.description,
      price: body.price,
      discountPercent: body.discountPercent,
      tags: body.tags,
      minSystemRequirements: body.minSystemRequirements,
      downloadUrl: body.downloadUrl,
      heroImage: body.heroImage,
      active: true,
      reviews: []
    });
    res.status(201).json({ game: toPublicGame(created) });
  } catch (error) {
    next(error);
  }
});

adminRouter.patch("/games/:gameId", (req, res, next) => {
  try {
    const body = gamePatchSchema.parse(req.body);
    const state = getState();
    const current = state.games.find((item) => item.id === req.params.gameId);
    if (!current) {
      throw new HttpError("Game not found", 404);
    }

    const updated = updateGame({
      ...current,
      ...body,
      slug: body.title ? slugify(body.title) : current.slug,
      minSystemRequirements: {
        ...current.minSystemRequirements,
        ...(body.minSystemRequirements ?? {})
      }
    });

    res.json({ game: toPublicGame(updated) });
  } catch (error) {
    next(error);
  }
});
