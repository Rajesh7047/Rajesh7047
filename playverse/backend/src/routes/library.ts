import { Router } from "express";
import { z } from "zod";
import { getState } from "../data/store.js";
import { requireAuth } from "../middleware/auth.js";
import { toPublicGame } from "../services/catalog.js";
import { HttpError } from "../utils/httpError.js";

const compatibilityBodySchema = z.object({
  os: z.string().min(2),
  ramGb: z.number().int().positive(),
  gpuTier: z.enum(["low", "mid", "high"])
});

const parseRam = (value: string): number => Number(value.replace("GB", "").trim());

export const libraryRouter = Router();

libraryRouter.use(requireAuth);

libraryRouter.get("/", (req, res) => {
  const state = getState();
  const ownedIds = new Set(
    state.library.filter((item) => item.userId === req.user!.id).map((item) => item.gameId)
  );
  const games = state.games
    .filter((game) => ownedIds.has(game.id))
    .map((game) => ({
      ...toPublicGame(game),
      readyToInstall: true
    }));
  res.json({ games });
});

libraryRouter.get("/orders", (req, res) => {
  const state = getState();
  const orders = state.orders.filter((order) => order.userId === req.user!.id);
  res.json({ orders });
});

libraryRouter.get("/downloads/:gameId", (req, res, next) => {
  try {
    const state = getState();
    const ownsGame = state.library.some(
      (item) => item.userId === req.user!.id && item.gameId === req.params.gameId
    );
    if (!ownsGame) {
      throw new HttpError("Game is not available in your library", 403);
    }
    const game = state.games.find((record) => record.id === req.params.gameId && record.active);
    if (!game) {
      throw new HttpError("Game not found", 404);
    }

    res.json({
      gameId: game.id,
      title: game.title,
      installer: game.downloadUrl,
      checksum: `${game.id}-sha256`,
      notes:
        "Installer is simulated for this academic build. Integrate signed binaries in production."
    });
  } catch (error) {
    next(error);
  }
});

libraryRouter.post("/compatibility/:gameId", (req, res, next) => {
  try {
    const body = compatibilityBodySchema.parse(req.body);
    const state = getState();
    const game = state.games.find((record) => record.id === req.params.gameId && record.active);
    if (!game) {
      throw new HttpError("Game not found", 404);
    }

    const requiredRam = parseRam(game.minSystemRequirements.ram);
    const supportsOs = body.os.toLowerCase().includes("windows");
    const enoughRam = body.ramGb >= requiredRam;
    const gpuRank: Record<string, number> = { low: 1, mid: 2, high: 3 };
    const recommendedTier = game.minSystemRequirements.gpu.includes("RTX")
      ? "high"
      : game.minSystemRequirements.gpu.includes("GTX 16")
      ? "mid"
      : "low";
    const enoughGpu = gpuRank[body.gpuTier] >= gpuRank[recommendedTier];

    res.json({
      gameId: game.id,
      compatible: supportsOs && enoughRam && enoughGpu,
      checks: {
        os: supportsOs,
        ram: enoughRam,
        gpu: enoughGpu
      },
      minimumRequirements: game.minSystemRequirements
    });
  } catch (error) {
    next(error);
  }
});
