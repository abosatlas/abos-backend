import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";

import env from "../config/env";

export interface AuthRequest extends Request {
    user?: any;
}

export const auth = (
    req: AuthRequest,
    res: Response,
    next: NextFunction
): void => {
    const header = req.headers.authorization;

    if (!header) {
        res.status(401).json({
            success: false,
            message: "Authorization token is missing.",
        });

        return;
    }

    const token = header.replace("Bearer ", "");

    try {
        const decoded = jwt.verify(
            token,
            env.JWT_SECRET
        );

        req.user = decoded;

        next();
    } catch {
        res.status(401).json({
            success: false,
            message: "Invalid or expired token.",
        });
    }
};
