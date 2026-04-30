import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from "@nestjs/common";
import { AppRole } from "src/common/constants/role.constants";
import { Roles } from "src/common/decorators/roles.decorator";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import { JwtAuthGuard } from "src/common/guards/jwt-auth.guard";
import { RolesGuard } from "src/common/guards/roles.guard";
import { CreateEmployeeDto } from "./dto/create-employee.dto";
import { OnboardEmployeeDto } from "./dto/onboard-employee.dto";
import { UpdateEmployeeDto } from "./dto/update-employee.dto";
import { EmployeesService } from "./employees.service";
import { CurrentUser } from "src/common/decorators/current-user.decorator";
import { AuthUser } from "src/common/types/auth-user.type";

@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(AppRole.SUPER_ADMIN, AppRole.ADMIN, AppRole.HR)
@Controller("employees")
export class EmployeesController {
  constructor(private readonly service: EmployeesService) {}

  @Post("onboard")
  onboard(@Body() dto: OnboardEmployeeDto, @CurrentUser() actor: AuthUser) {
    return this.service.onboard(dto, actor);
  }

  @Post()
  create(@Body() dto: CreateEmployeeDto) {
    return this.service.create(dto);
  }

  @Get()
  findAll(@Query() query: PaginationQueryDto) {
    return this.service.findAll(query);
  }

  @Get(":id")
  findOne(@Param("id", ParseIntPipe) id: number) {
    return this.service.findOne(id);
  }

  @Patch(":id")
  update(@Param("id", ParseIntPipe) id: number, @Body() dto: UpdateEmployeeDto) {
    return this.service.update(id, dto);
  }

  @Delete(":id")
  remove(@Param("id", ParseIntPipe) id: number) {
    return this.service.remove(id);
  }
}
