import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  ParseIntPipe,
  Query,
} from "@nestjs/common";
import { AcademicTermsService } from "./academic-terms.service";
import { CreateAcademicTermDto } from "./dto/create-academic-term.dto";
import { UpdateAcademicTermDto } from "./dto/update-academic-term.dto";
import { JwtAuthGuard } from "src/common/guards/jwt-auth.guard";
import { RolesGuard } from "src/common/guards/roles.guard";
import { Roles } from "src/common/decorators/roles.decorator";
import { AppRole } from "src/common/constants/role.constants";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";

@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(AppRole.SUPER_ADMIN, AppRole.ADMIN)
@Controller("academic-terms")
export class AcademicTermsController {
  constructor(private readonly academicTermsService: AcademicTermsService) {}

  @Post()
  create(@Body() createAcademicTermDto: CreateAcademicTermDto) {
    return this.academicTermsService.create(createAcademicTermDto);
  }

  @Get()
  findAll(@Query() query: PaginationQueryDto) {
    return this.academicTermsService.findAll(query);
  }

  @Get(":id")
  findOne(@Param("id", ParseIntPipe) id: number) {
    return this.academicTermsService.findOne(id);
  }

  @Patch(":id")
  update(
    @Param("id", ParseIntPipe) id: number,
    @Body() updateAcademicTermDto: UpdateAcademicTermDto,
  ) {
    return this.academicTermsService.update(id, updateAcademicTermDto);
  }

  @Delete(":id")
  remove(@Param("id", ParseIntPipe) id: number) {
    return this.academicTermsService.remove(id);
  }
}
