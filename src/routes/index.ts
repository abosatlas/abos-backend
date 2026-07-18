import { Router } from "express";

import authRoutes from "./auth.routes";
import companyRoutes from "./companies.routes";
import userRoutes from "./users.routes";
import branchRoutes from "./branches.routes";

const router = Router();

router.get("/", (_, res) => {
    res.status(200).json({
        success: true,
        application: "ABOS API",
        version: "1.0.0",
        message: "API is running successfully.",
    });
});

router.use("/auth", authRoutes);
router.use("/companies", companyRoutes);
router.use("/users", userRoutes);
router.use("/branches", branchRoutes);

export default router;
