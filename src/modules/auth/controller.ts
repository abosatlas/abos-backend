import { Request, Response } from "express";

import authService from "./service";

export class AuthController {
    async login(
        req: Request,
        res: Response
    ): Promise<void> {
        const { email, password } = req.body;

        const result = await authService.login(
            email,
            password
        );

        res.json({
            success: true,
            data: result,
        });
    }
}

export default new AuthController();
