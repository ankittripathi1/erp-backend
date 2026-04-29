import { Injectable, NotFoundException } from "@nestjs/common";
import { PrismaService } from "src/prisma/prisma.service";

@Injectable()
export class UserService {
  constructor(private readonly prisma: PrismaService) {}

  findMany() {
    return this.prisma.user.findMany({
      take: 50,
      orderBy: { id: "desc" },
      select: {
        id: true,
        username: true,
        email: true,
        phone: true,
        first_name: true,
        middle_name: true,
        last_name: true,
        user_type: true,
        account_status: true,
        is_active: true,
        created_at: true,
      },
    });
  }

  async findOne(id: number) {
    const user = await this.prisma.user.findUnique({
      where: { id: BigInt(id) },
      select: {
        id: true,
        username: true,
        email: true,
        phone: true,
        first_name: true,
        last_name: true,
        user_type: true,
        account_status: true,
        is_active: true,
        created_at: true,
        userrole_user_set: {
          select: {
            role: {
              select: {
                code: true,
                name: true,
              },
            },
          },
        },
      },
    });
    if (!user) {
      throw new NotFoundException("User not found");
    }

    return user;
  }
}
