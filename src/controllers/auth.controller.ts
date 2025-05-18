import { Request, Response } from "express";
import prismaClient from "../db";
import { Role } from "@prisma/client";
import { comparePassword, generateToken, hashPassword, sanatizeUser } from "../helper/hashing&JwtFunctions";


export const loginController = async( req:Request, res:Response)=>{

    const {email, password} = req.body;

    if(!email || !password){
         res.status(400).json({
            message: "Email and password are required"
        });
        return;
    }

    const user = await prismaClient.user.findUnique({
        where:{
            email:email
        },
    })

    if(!user){
         res.status(401).json({
            message: "Invalid email or password"
        });
        return;
    }

    const isPasswordValid = await comparePassword(password, user.password);
    if(!isPasswordValid){
         res.status(401).json({
            message: "Invalid email or password"
        });
        return;
    }

    const generatedToken = await generateToken(user.id, user.role);

    res.cookie('token', generatedToken,{
        httpOnly:true,
        maxAge: 7*24*60*60*1000, // 7 days
    })

    res.status(200).json({
        message: "Login successful",
        token: generatedToken,
        user:sanatizeUser(user),
    });
    return;

}

export const register = async(req:Request, res:Response)=>{

    try{

    const {
        username,
        email,
        password,
        firstName,
        lastName,
        role,
        permissions_json
    } = req.body;

    const existingUser = await prismaClient.user.findFirst({
        where:{
            OR:[{email},{username}]
        }
    })

    if(existingUser){
        res.status(409).json({
            status:"error",
            message:"User already exists",
        })
        return;
    }

    const hashedPassword = await hashPassword(password);

    const newUser = await prismaClient.user.create({
        data:{
            username,
            email,
            password:hashedPassword,
            firstName,
            lastName,
            role,
        }
    })

    const token = await generateToken(newUser.id, newUser.role);

    res.cookie('token', token,{
        httpOnly:true,
        maxAge: 7*24*60*60*1000, // 7 days
    })

    res.status(201).json({
        status:"success",
        message:"User created successfully",
        data:{
            user: sanatizeUser(newUser),
            token
        }
    })


    }catch(error){
        console.error(error);
        res.status(500).json({
            status:"error",
            message:"Internal server error",
        })
        return;
    }
}

export const logout = async(req:Request, res:Response)=>{
    res.clearCookie('token');
    res.status(200).json({
        status:"success",
        message:"Logged out successfully",
    })
}

export const getMe = async(req:Request, res:Response)=>{
    const userId = req.user.userId;

    try{

        const user = await prismaClient.user.findUnique({
            where:{
                id:userId
            }
        })

        if(!user){
            res.status(404).json({
                status:"error",
                message:"User not found",
            })
            return;
        }

        res.status(200).json({
            status:"success",
            message:"User fetched successfully",
            user:sanatizeUser(user)
        })
    }catch(error){
        console.error(error);
        res.status(500).json({
            status:"error",
            message:"Internal server error",
        })
        return;
    }
}
