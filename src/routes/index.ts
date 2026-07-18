import { Router } from "express";

import authRoutes from "../modules/auth/routes";

const router = Router();

/*
|--------------------------------------------------------------------------
| API Status
|--------------------------------------------------------------------------
*/

router.get("/", (_, res) => {
    res.status(200).json({
        success: true,
        application: "ABOS API",
        version: "1.0.0",
        status: "Running",
    });
});

/*
|--------------------------------------------------------------------------
| Modules
|--------------------------------------------------------------------------
*/

router.use("/auth", authRoutes);

export default router;
