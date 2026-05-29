import { NextFunction, Request, Response } from "express";
import { ZodType } from "zod";

export const validateBody =
  (schema: ZodType) =>
  (req: Request, _res: Response, next: NextFunction): void => {
    req.body = schema.parse(req.body);
    next();
  };
