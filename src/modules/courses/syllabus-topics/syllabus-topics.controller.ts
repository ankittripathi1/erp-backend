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
import { CreateSyllabusTopicDto } from "./dto/create-syllabus-topic.dto";
import { UpdateSyllabusTopicDto } from "./dto/update-syllabus-topic.dto";
import { SyllabusTopicsService } from "./syllabus-topics.service";

@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(AppRole.SUPER_ADMIN, AppRole.ADMIN)
@Controller("syllabus-topics")
export class SyllabusTopicsController {
  constructor(private readonly service: SyllabusTopicsService) {}

  @Post()
  create(@Body() dto: CreateSyllabusTopicDto) {
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
    @Body() dto: UpdateSyllabusTopicDto,
  ) {
    return this.service.update(id, dto);
  }

  @Delete(":id")
  remove(@Param("id", ParseIntPipe) id: number) {
    return this.service.remove(id);
  }
}
