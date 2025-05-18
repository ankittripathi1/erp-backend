import { Request, Response } from "express";
import prismaClient from "../db";
import { Role } from "@prisma/client";
import { hashPassword } from "../helper/hashing&JwtFunctions";
import { date } from "drizzle-orm/mysql-core";

export const getAllStudents = async (req:Request, res:Response)=>{
    const page = parseInt(req.query.page as string)|| 1;
    const pageSize = parseInt(req.query.pageSize as string)  || 10;
    const search = req.query.search as string || "";

    try{

        const whereClause:any = search 
        ?{
            OR:[
                {admissionNumber:{contains:search, mode:"insensitive"}},
                {address:{contains:search, mode:"insensitive"}},
            ]
        }:{};
        
        const [students, totalStudents] = await Promise.all([
            prismaClient.student.findMany({
                where: whereClause,
                skip: (page - 1) * pageSize,
                take: pageSize,
                orderBy:{
                    admissionDate: "desc"
                }
            }),
            prismaClient.student.count({where: whereClause})
        ]);

        res.status(200).json({
            status:"success",
            message:"Students fetched successfully",
           data:{
            students,
            totalStudents,
            page,
            totalpages: Math.ceil(totalStudents / pageSize),
           },
        })
    }catch(error){
        console.error(error);
        res.status(500).json({
            status:"error",
            message:"Internal server error",
        })
    }
}

export const getStudentById = async (req:Request, res:Response)=>{
    const studentId = req.params.id;
    try{
        const student = await prismaClient.student.findUnique({
            where:{
                id:studentId
            },
            include:{
                Attendance:true,
                financeFees:true,
                ExamScores:true,
                HostelFeeCollections:true,
                TransportFeeCollections:true,
            }
        });

        if(!student){
            res.status(404).json({
                status:"error",
                message:"Student not found",
            })
            return;
        }

        res.status(200).json({
            status:"success",
            message:"Student fetched successfully",
            data:{
                student,
            }   
        });

    }catch(error){
        console.error(error);
        res.status(500).json({
            status:"error",
            message:"Internal server error",
        })
        return;
    }
}

export const createStudent = async (req:Request, res:Response)=>{
    const {admissionNumber, firstName, lastName, email, phoneNumber, address, admissionDate, password , dateOfBirth, gender, boolGroup,  nationality} = req.body;

    const hashedPassword = await hashPassword(password);
    const userName = admissionNumber
    
    try{


    const result = await prismaClient.$transaction(async (tx)=>{
        const user = await tx.user.create({
            data:{
                email: email,
                firstName: firstName,
                lastName: lastName,
                username: userName, // or another unique identifier
                password: hashedPassword, // Replace with actual password logic or hash
                role: Role.STUDENT,
                }
            });
        const student = await tx.student.create({
            data:{
                admissionNo:admissionNumber,
                dateOfBirth,
                Gender:gender,
                phoneNumber,
                nationality,
                BloodGroup:boolGroup,
                address,
                admissionDate,
                userId: user.id, // Link to the created user
            }
        });

        return {user, student};
    });
    res.status(201).json({
        status:"success",
        message:"Student created successfully",
        data:{
            student: result.student,
            user: result.user,
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