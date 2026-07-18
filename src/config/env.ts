import dotenv from "dotenv";

dotenv.config();

const env = {
    PORT: Number(process.env.PORT) || 3000,

    NODE_ENV: process.env.NODE_ENV || "development",

    DATABASE_URL: process.env.DATABASE_URL || "",

    JWT_SECRET: process.env.JWT_SECRET || "",

    JWT_EXPIRES_IN: process.env.JWT_EXPIRES_IN || "1d",

    REFRESH_TOKEN_SECRET:
        process.env.REFRESH_TOKEN_SECRET || "",

    REFRESH_TOKEN_EXPIRES_IN:
        process.env.REFRESH_TOKEN_EXPIRES_IN || "7d",

    CORS_ORIGIN: process.env.CORS_ORIGIN || "*",

    LOG_LEVEL: process.env.LOG_LEVEL || "info",
};

export default env;
