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
import { CreateDesignationDto } from "./dto/create-designation.dto";
import { UpdateDesignationDto } from "./dto/update-designation.dto";
import { DesignationsService } from "./designations.service";

@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(AppRole.SUPER_ADMIN, AppRole.ADMIN, AppRole.HR)
@Controller("designations")
export class DesignationsController {
  constructor(private readonly service: DesignationsService) {}

  @Post()
  create(@Body() dto: CreateDesignationDto) {
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
  update(
    @Param("id", ParseIntPipe) id: number,
    @Body() dto: UpdateDesignationDto,
  ) {
    return this.service.update(id, dto);
  }

  @Delete(":id")
  remove(@Param("id", ParseIntPipe) id: number) {
    return this.service.remove(id);
  }
}
