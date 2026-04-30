import "dotenv/config";
import bcrypt from "bcrypt";
import { PrismaClient } from "../../generated/prisma/client";
import { PrismaPg } from "@prisma/adapter-pg";

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  throw new Error("DATABASE_URL is required.");
}

const prisma = new PrismaClient({
  adapter: new PrismaPg({ connectionString }),
});

const roles = [
  { code: "SUPER_ADMIN", name: "Super Admin" },
  { code: "ADMIN", name: "Admin" },
  { code: "STUDENT", name: "Student" },
  { code: "FACULTY", name: "faculty" },
  { code: "HR", name: "HR" },
  { code: "ACCOUNTANT", name: "Accountant" },
  { code: "LIBRARIAN", name: "Librarian" },
  { code: "WARDEN", name: "Warden" },
  { code: "PLACEMENT_COORDINATOR", name: "Placement Coordinator" },
  { code: "ALUMNI_COORDINATOR", name: "Alumni Coordinator" },
  { code: "STAFF", name: "staff" },
];

async function main() {
  for (const role of roles) {
    await prisma.role.upsert({
      where: { code: role.code },
      update: { name: role.name },
      create: {
        code: role.code,
        name: role.name,
      },
    });
  }

  const password = await bcrypt.hash("admin123", 12);

  const admin = await prisma.user.upsert({
    where: { username: "admin" },
    update: {
      email: "admin@example.com",
      first_name: "System",
      last_name: "Admin",
      user_type: "admin",
      account_status: "active",
      is_staff: true,
      is_superuser: true,
      is_active: true,
    },
    create: {
      username: "admin",
      password,
      email: "admin@example.com",
      first_name: "System",
      last_name: "Admin",
      user_type: "admin",
      account_status: "active",
      is_staff: true,
      is_superuser: true,
      is_active: true,
    },
  });

  const superAdminRole = await prisma.role.findUniqueOrThrow({
    where: { code: "SUPER_ADMIN" },
  });

  const existingUserRole = await prisma.userRole.findFirst({
    where: {
      user_id: admin.id,
      role_id: superAdminRole.id,
    },
  });

  if (existingUserRole) {
    await prisma.userRole.update({
      where: { id: existingUserRole.id },
      data: {
        is_active: true,
        revoked_at: null,
      },
    });
  } else {
    await prisma.userRole.create({
      data: {
        user_id: admin.id,
        role_id: superAdminRole.id,
        assigned_at: new Date(),
        is_active: true,
      },
    });
  }

  console.log("Seed completed");
  console.log("admin user:  admin");
  console.log("admin password: admin123");
}

main()
  .finally(async () => {
    await prisma.$disconnect();
  })
  .catch(async (error) => {
    console.error(error);
    await prisma.$disconnect();
    process.exit(1);
  });
