import { Request, Response, NextFunction } from "express";

export const requestLogger = (
    req: Request,
    _: Response,
    next: NextFunction
): void => {
    const now = new Date().toISOString();

    console.log(
        `[${now}] ${req.method} ${req.originalUrl} (${req.ip})`
    );

    next();
};
