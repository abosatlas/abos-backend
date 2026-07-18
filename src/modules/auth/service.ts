import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

import repository from "./repository";
import env from "../../config/env";

class AuthService {
    async login(email: string, password: string) {
        const user = await repository.findUserByEmail(email);

        if (!user) {
            throw new Error("Invalid email or password.");
        }

        const valid = await bcrypt.compare(
            password,
            user.password_hash
        );

        if (!valid) {
            throw new Error("Invalid email or password.");
        }

        const accessToken = jwt.sign(
            {
                id: user.id,
                email: user.email,
                role: user.role,
            },
            env.JWT_SECRET,
            {
                expiresIn: env.JWT_EXPIRES_IN,
            }
        );

        const refreshToken = jwt.sign(
            {
                id: user.id,
            },
            env.REFRESH_TOKEN_SECRET,
            {
                expiresIn: env.REFRESH_TOKEN_EXPIRES_IN,
            }
        );

        await repository.saveRefreshToken(
            user.id,
            refreshToken
        );

        return {
            accessToken,
            refreshToken,
            user,
        };
    }
}

export default new AuthService();
