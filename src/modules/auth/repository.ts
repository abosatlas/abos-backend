import { db } from "../../config/database";

export class AuthRepository {
    async findUserByEmail(email: string) {
        const result = await db.query(
            `
            SELECT *
            FROM users
            WHERE email = $1
            LIMIT 1
            `,
            [email]
        );

        return result.rows[0] || null;
    }

    async saveRefreshToken(
        userId: string,
        refreshToken: string
    ): Promise<void> {
        await db.query(
            `
            UPDATE users
            SET refresh_token = $1
            WHERE id = $2
            `,
            [refreshToken, userId]
        );
    }
}

export default new AuthRepository();
