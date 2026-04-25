import { Controller, Get, Param, UseGuards } from "@nestjs/common";
import { UserService } from "./users.service";
import { JwtAuthGuard } from "src/common/guards/jwt-auth.guard";
import { RolesGuard } from "src/common/guards/roles.guard";
import { Roles } from "src/common/decorators/roles.decorator";

@UseGuards(JwtAuthGuard, RolesGuard)
@Roles("SUPER_ADMIN", "ADMIN")
@Controller("users")
export class UsersController {
  constructor(private readonly usersService: UserService) {}

  @Get()
  findMany() {
    return this.usersService.findMany();
  }

  @Get(":id")
  findOne(@Param("id") id: string) {
    return this.usersService.findOne(id);
  }
}
