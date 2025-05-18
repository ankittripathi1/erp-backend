import { Request, Response } from "express";
import prismaClient from "../db";
import { sanatizeUser } from "../helper/hashing&JwtFunctions";
import { Role } from "@prisma/client";
import { ParamsDictionary } from "express-serve-static-core";
import { ParsedQs } from "qs";

export const getUsers = async (req:Request, res:Response)=>{
    const page = parseInt(req.query.page as string) || 1;
    const pageSize = parseInt(req.query.pageSize as string) || 10;

    const search = req.query.search as string || "";
    const role = req.query.role as string || "";
    
    const whereClause:any = {
        AND:[
            search?{
                OR:[
                    { name: { containes: search, mode: "insensitive" } },
                    { email: { containes: search, mode: "insensitive" } },
                ],
            }:
            {},
            role?{
                role:role
            }:{}
        ]
    }

    try{
        const [users, totalUsers] = await Promise.all([
            prismaClient.user.findMany({
                where: whereClause,
                skip: (page - 1) * pageSize,
                take: pageSize,
                orderBy:{
                    createdAt: "desc"
                }
            }),
            prismaClient.user.count({
                where: whereClause
            })
       ]);
       const sanatizedUsers = users.map(sanatizeUser)

       res.status(200).json({
            status: "success",
            data: {
                sanatizedUsers,
                totalUsers,
                page,
                pageSize,
                totalPages: Math.ceil(totalUsers / pageSize),
            },
        });

    }catch(error){
        console.log("Error fetching users", error);
        res.status(500).json({
            status:"error",
            message:"Internal server error",
        })
    }
}

export const getUserById = async (req:Request, res:Response)=>{
    const userId = req.params.id;

    try{
        const user = await prismaClient.user.findUnique({
            where:{
                id:userId
            }
        });

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

export const updateUser = async (req:Request, res:Response)=>{
    const userId = req.params.id;
    const {  permissions_json,firstName, lastName} = req.body;

    try{
        const updatedUser = await prismaClient.user.update({
            where:{id:userId},
            data:{firstName,lastName, permissions_json}
        });

        res.status(200).json({
            status:"success",
            message:"User updated successfully",
            user:sanatizeUser(updatedUser)
        });
    }catch(error){
        console.error(error);
        res.status(500).json({
            status:"error",
            message:"Internal server error",
        })
    }
}

export const deleteUser = async (req:Request, res:Response)=>{
    const userId = req.params.id;
    try{
        const deletedUser = await prismaClient.user.update({
            where:{id:userId},
            data:{isActive:false}
        })
        res.status(200).json({
            status:"success",
            message:"User deleted successfully",
            user:sanatizeUser(deletedUser)
        });
    }catch(error){
        console.error(error);
        res.status(500).json({
            status:"error",
            message:"Internal server error",
        })
    }
}

export const updateUserRole = async(req:Request, res:Response)=>{
    const userId = req.params.id;
    const { role } = req.body;
    try{
        const updatedUser = await prismaClient.user.update({
            where:{id:userId},
            data:{role}
        });
        res.status(200).json({
            status:"success",
            message:"User role updated successfully",
            user:sanatizeUser(updatedUser)
        });
    }catch(error){
        console.error(error);
        res.status(500).json({
            status:"error",
            message:"Internal server error",
        })
    }
}

export const getUserPermissions = async(req:Request, res:Response)=>{
    const userId = req.params.id;
    try{
        const user = await prismaClient.user.findUnique({
            where:{id:userId},
            select:{
                permissions_json:true
            }
        });

        if(!user){
            res.status(404).json({
                status:"error",
                message:"User not found",
            })
            return;
        }

        res.status(200).json({
            status:"success",
            message:"User permissions fetched successfully",
            permissions:user.permissions_json
        });
    }catch(error){
        console.error(error);
        res.status(500).json({
            status:"error",
            message:"Internal server error",
        })
    }
}

export const updateUserPermissions = async(req:Request, res:Response)=>{
    const userId = req.params.id;
    const { permissions_json } = req.body;
    try{
        const updatedUser = await prismaClient.user.update({
            where:{id:userId},
            data:{permissions_json}
        });
        res.status(200).json({
            status:"success",
            message:"User permissions updated successfully",
            user:sanatizeUser(updatedUser)
        });
    }catch(error){
        console.error(error);
        res.status(500).json({
            status:"error",
            message:"Internal server error",
        })
    }
}   