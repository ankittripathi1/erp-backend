import { PrismaClient, Role } from "@prisma/client";
import { hash } from "bcrypt";

const prismaClient = new PrismaClient();

async function main(){
    const adminPassword = await hash("admin123", 10);

    const adminUser = await prismaClient.user.create({
        data:{
            username:"SystemAdmin",
            email:"admin@university.com",
            password: adminPassword,
            firstName: "System",
            lastName: "Admin",
            role: Role.SYSTEM_ADMIN, 
            permissions_json:{
                manageUsers: true,
            }

        }
    });

    console.log("Admin user created : ", adminUser);
}

main().catch((e)=>{
    console.error(e);
    process.exit(1)
}).finally(async()=>{
    await prismaClient.$disconnect();
    console.log("Disconnected from database");
})