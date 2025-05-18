import { Jwt } from "jsonwebtoken";

declare global{
    namespace Express{
        interface Request{
            user?:Jwt.JwtPayload;
        }
    }
}