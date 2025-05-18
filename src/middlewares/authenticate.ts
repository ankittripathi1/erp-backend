import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";

export const authenticate = (req:Request, res:Response, next:NextFunction)=>{
    const token = req.cookies.token || req.headers.authorization?.split(" ")[1];
    if(!token){
        console.log("No token found");
         res.status(401).json({
            message: "Unauthorized"
        });
        return;
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET as string);
        req.user = decoded;
        console.log("Decoded user", decoded);
        next();
    } catch (error) {
        console.error("Invalid token", error);
         res.status(401).json({
            message: "Unauthorized"
        });
    }
}