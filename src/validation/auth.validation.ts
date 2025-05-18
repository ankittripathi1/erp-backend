import { Role } from "@prisma/client";
import { z } from "zod";


export const loginSchema = z.object({
    body:z.object({
        email:z.string().email(),
        password:z.string().min(8, 'password must be at least 8 characters long')
    })
})

export const registerSchema = z.object({
    body:z.object({
        username: z.string().min(3, 'username must be at least 3 characters long'),
        email: z.string().email("invalid email address"),
        password:z.string().min(8, 'password must be at least 8 characters long'),
        firstName:z.string().min(3, 'first name must be at least 3 characters long').optional(),
        lastName:z.string().min(3, 'last name must be at least 3 characters long').optional(),
        role:z.nativeEnum(Role)
    })
})