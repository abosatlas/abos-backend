import { Pool } from "pg";
import env from "./env";

const pool = new Pool({
    connectionString: env.DATABASE_URL,
});

export const connectDatabase = async (): Promise<void> => {
    const client = await pool.connect();

    try {
        await client.query("SELECT NOW()");
        console.log("✅ PostgreSQL Connected");
    } finally {
        client.release();
    }
};

export const db = pool;
