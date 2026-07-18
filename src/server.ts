import app from "./app";
import { connectDatabase } from "./config/database";
import env from "./config/env";

const startServer = async (): Promise<void> => {
    try {
        await connectDatabase();

        app.listen(env.PORT, () => {
            console.log("======================================");
            console.log("🚀 ABOS API Started Successfully");
            console.log(`🌐 Server : http://localhost:${env.PORT}`);
            console.log(`📦 Environment : ${env.NODE_ENV}`);
            console.log("======================================");
        });
    } catch (error) {
        console.error("❌ Failed to start server");
        console.error(error);
        process.exit(1);
    }
};

startServer();
