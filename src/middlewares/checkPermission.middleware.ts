import { Request, Response,NextFunction } from "express";
import prismaClient from "../db";
import { Role } from "@prisma/client";

export const hasPermission = (permission: string) => {
    return async (req: Request, res: Response, next: NextFunction) => {
        const userPayload = req.user;
        if (!userPayload) {
             res.status(401).json({
                status: "error",
                message: "Unauthorized",
            });
        }

        if(userPayload.role === Role.SYSTEM_ADMIN){
            console.log("System admin, skipping permission check");
            next();
            return;
        }

        const  dbUser =await  prismaClient.user.findUnique({
            where: {
                id: userPayload.userId,
            },
            select:{
                permissions_json: true,
            }
        });

        if(!dbUser){
            res.status(401).json({
                status: "error",
                message: "Unauthorized",
            });
            return;
        }

        const permissions = dbUser.permissions_json as Record<string, boolean> || {};

        if(!permissions[permission]){
            console.log("User does not have permission", permission);
            res.status(403).json({
                status: "error",
                message: "Forbidden",
            });
            return;
        }

        next();
    };
}