import { User } from "@prisma/client";
import bcrypt from "bcrypt";
import Jwt from "jsonwebtoken";

export const generateToken = async(userId:string, role:string):Promise<string>=>{
    const token = Jwt.sign({
        userId,
        role
    }, process.env.JWT_SECRET as string, {
        expiresIn: "1h"
    });

    return token;
}

export const hashPassword = async(password:string):Promise<string>=>{
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);
    return hashedPassword;
}

export const comparePassword = async(password:string, hashedPassword:string):Promise<boolean>=>{
    return await bcrypt.compare(password, hashedPassword);
}

export const sanatizeUser = (user:User)=>{
    const {password, ...sanatizedUser} = user;
    return sanatizedUser;
}