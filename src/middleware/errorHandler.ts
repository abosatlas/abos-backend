import { Request, Response, NextFunction } from "express";

export const errorHandler = (
    err: any,
    _: Request,
    res: Response,
    __: NextFunction
): void => {
    console.error(err);

    res.status(err.status || 500).json({
        success: false,
        message:
            err.message || "Internal Server Error",
    });
};
