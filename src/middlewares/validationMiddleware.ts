import { NextFunction, Request, Response } from "express";
import { AnyZodObject, ZodError } from "zod";

export const validate = (schema:AnyZodObject)=>{
    return async(req:Request, res:Response, next:NextFunction)=>{
        try{
            await schema.parseAsync({
                body: req.body,
                query: req.query,
                params: req.params,
            });
            return next();
        }catch(error){
            if(error instanceof ZodError){
                 res.status(400).json({
                    status: "error",
                    message:"Validation Failed",
                    errors: error.errors.map((e)=>({
                        path: e.path.join("."),
                        message: e.message
                    }))
                })
            }
            return next(error);
        }
    }
}

export const validateBody = (schema:AnyZodObject)=>{
    return async(req:Request, res:Response, next:NextFunction)=>{
        try{
            const validatedData = await schema.parseAsync(req.body)
            req.body = validatedData;
            return next();
        }catch(error){
            if(error instanceof ZodError){
                return res.status(400).json({
                    status: "error",
                    message:"Validation Failed",
                    errors: error.errors.map((e)=>({
                        path: e.path.join("."),
                        message: e.message
                    }))
                })
            }
            return next(error);
        }
    }
}