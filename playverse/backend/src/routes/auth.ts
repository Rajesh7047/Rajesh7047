import bcrypt from "bcryptjs";
import { Router } from "express";
import { z } from "zod";
import { createUser, getState } from "../data/store.js";
import { createId } from "../utils/ids.js";
import { HttpError } from "../utils/httpError.js";
import { signAccessToken } from "../utils/jwt.js";

const AuthBodySchema = z.object({
  email: z.string().email(),
  password: z.string().min(8)
});

const RegisterBodySchema = AuthBodySchema.extend({
  name: z.string().min(2),
  favoriteGenres: z.array(z.string().min(2)).max(5).optional()
});

const sanitizeUser = (user: { id: string; name: string; email: string; role: string }) => ({
  id: user.id,
  name: user.name,
  email: user.email,
  role: user.role
});

export const authRouter = Router();

authRouter.post("/register", async (req, res, next) => {
  try {
    const body = RegisterBodySchema.parse(req.body);
    const state = getState();
    const email = body.email.toLowerCase();

    const alreadyExists = state.users.some((user) => user.email === email);
    if (alreadyExists) {
      throw new HttpError("An account with this email already exists", 409);
    }

    const passwordHash = await bcrypt.hash(body.password, 10);
    const user = createUser({
      id: createId("u"),
      name: body.name.trim(),
      email,
      passwordHash,
      role: "user",
      favoriteGenres: body.favoriteGenres ?? [],
      createdAt: new Date().toISOString()
    });

    const token = signAccessToken({
      id: user.id,
      role: user.role,
      email: user.email,
      name: user.name
    });

    res.status(201).json({
      token,
      user: sanitizeUser(user)
    });
  } catch (error) {
    next(error);
  }
});

authRouter.post("/login", async (req, res, next) => {
  try {
    const body = AuthBodySchema.parse(req.body);
    const state = getState();
    const email = body.email.toLowerCase();

    const user = state.users.find((record) => record.email === email);
    if (!user) {
      throw new HttpError("Invalid email or password", 401);
    }

    const isValidPassword = await bcrypt.compare(body.password, user.passwordHash);
    if (!isValidPassword) {
      throw new HttpError("Invalid email or password", 401);
    }

    const token = signAccessToken({
      id: user.id,
      role: user.role,
      email: user.email,
      name: user.name
    });

    res.json({
      token,
      user: sanitizeUser(user)
    });
  } catch (error) {
    next(error);
  }
});
