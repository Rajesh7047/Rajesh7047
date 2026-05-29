import cors from "cors";
import express from "express";
import helmet from "helmet";
import morgan from "morgan";
import { adminRouter } from "./routes/admin.js";
import { authRouter } from "./routes/auth.js";
import { cartRouter } from "./routes/cart.js";
import { gamesRouter } from "./routes/games.js";
import { libraryRouter } from "./routes/library.js";
import { wishlistRouter } from "./routes/wishlist.js";
import { errorHandler, notFoundHandler } from "./middleware/error.js";

export const app = express();

app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE"]
  })
);
app.use(helmet());
app.use(express.json({ limit: "1mb" }));
app.use(morgan("dev"));

app.get("/health", (_req, res) => {
  res.json({
    status: "ok",
    service: "playverse-api"
  });
});

app.use("/api/auth", authRouter);
app.use("/api/games", gamesRouter);
app.use("/api/cart", cartRouter);
app.use("/api/library", libraryRouter);
app.use("/api/wishlist", wishlistRouter);
app.use("/api/admin", adminRouter);

app.use(notFoundHandler);
app.use(errorHandler);
