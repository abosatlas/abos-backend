export interface LoginRequest {
    email: string;
    password: string;
}

export interface RegisterRequest {
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    companyId: string;
}

export interface JwtPayload {
    id: string;
    email: string;
    role: string;
}

export interface AuthResponse {
    accessToken: string;
    refreshToken: string;
}
