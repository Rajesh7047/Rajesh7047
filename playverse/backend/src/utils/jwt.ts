import jwt from "jsonwebtoken";
import { env } from "../config/env.js";
import { AuthenticatedRequestContext } from "../types.js";

interface JwtPayload extends AuthenticatedRequestContext {
  iat: number;
  exp: number;
}

export const signAccessToken = (payload: AuthenticatedRequestContext): string =>
  jwt.sign(payload, env.JWT_SECRET, { expiresIn: "24h" });

export const verifyAccessToken = (token: string): AuthenticatedRequestContext => {
  const decoded = jwt.verify(token, env.JWT_SECRET) as JwtPayload;
  return {
    id: decoded.id,
    role: decoded.role,
    email: decoded.email,
    name: decoded.name
  };
};
