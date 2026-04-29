import { Controller, Get, UseGuards } from "@nestjs/common";
import { RolesService } from "./roles.service";
import { JwtAuthGuard } from "src/common/guards/jwt-auth.guard";
import { RolesGuard } from "src/common/guards/roles.guard";
import { Roles } from "src/common/decorators/roles.decorator";
import { AppRole } from "src/common/constants/role.constants";

@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(AppRole.SUPER_ADMIN, AppRole.ADMIN)
@Controller("roles")
export class RolesController {
  constructor(private readonly rolesService: RolesService) {}

  @Get()
  findMany() {
    return this.rolesService.findMany();
  }
}
