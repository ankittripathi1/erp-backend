import bcrypt from "bcrypt";
import { Injectable, UnauthorizedException } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import { LoginDto } from "./dto/login.dto";
import { PrismaService } from "src/prisma/prisma.service";

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwtService: JwtService,
  ) {}

  async login(dto: LoginDto) {
    const user = await this.prisma.user.findUnique({
      where: { username: dto.username },
      select: {
        id: true,
        username: true,
        password: true,
        email: true,
        is_active: true,
        account_status: true,
        userrole_user_set: {
          where: {
            is_active: true,
            revoked_at: null,
          },
          select: {
            role: {
              select: {
                code: true,
              },
            },
          },
        },
      },
    });

    if (!user || !user.is_active || user.account_status !== "active") {
      throw new UnauthorizedException("Invalid Credentials");
    }

    const passwordValid = await bcrypt.compare(dto.password, user.password);

    if (!passwordValid) {
      throw new UnauthorizedException("Invalid Credentials");
    }

    const roles = user.userrole_user_set.map((userRole) => userRole.role.code);

    const authUser = {
      id: user.id.toString(),
      username: user.username,
      email: user.email,
      roles,
    };

    const secret = process.env.JWT_SECRET;

    if (!secret) {
      throw new UnauthorizedException("JWT_SECRET is required.");
    }

    const accessToken = await this.jwtService.signAsync(authUser, {
      secret,
      expiresIn: "1h",
    });

    return {
      accessToken,
      user: authUser,
    };
  }
}
