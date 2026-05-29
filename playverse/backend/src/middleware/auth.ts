import { NextFunction, Request, Response } from "express";
import { verifyAccessToken } from "../utils/jwt.js";
import { HttpError } from "../utils/httpError.js";

declare global {
  namespace Express {
    interface Request {
      user?: {
        id: string;
        role: "user" | "admin";
        email: string;
        name: string;
      };
    }
  }
}

export const requireAuth = (req: Request, _res: Response, next: NextFunction): void => {
  const authorization = req.headers.authorization;
  if (!authorization || !authorization.startsWith("Bearer ")) {
    next(new HttpError("Authentication required", 401));
    return;
  }

  const token = authorization.replace("Bearer ", "").trim();
  try {
    req.user = verifyAccessToken(token);
    next();
  } catch {
    next(new HttpError("Invalid or expired session", 401));
  }
};

export const requireAdmin = (req: Request, _res: Response, next: NextFunction): void => {
  if (!req.user) {
    next(new HttpError("Authentication required", 401));
    return;
  }
  if (req.user.role !== "admin") {
    next(new HttpError("Admin access required", 403));
    return;
  }
  next();
};
