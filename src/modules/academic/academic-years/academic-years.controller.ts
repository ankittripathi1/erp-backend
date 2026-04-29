import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
} from "@nestjs/common";
import { AcademicYearsService } from "./academic-years.service";
import { CreateAcademicYearDto } from "./dto/create-academic-year.dto";
import { UpdateAcademicYearDto } from "./dto/update-academic-year.dto";
import { Roles } from "src/common/decorators/roles.decorator";
import { AppRole } from "src/common/constants/role.constants";
import { JwtAuthGuard } from "src/common/guards/jwt-auth.guard";
import { RolesGuard } from "src/common/guards/roles.guard";

@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(AppRole.SUPER_ADMIN, AppRole.ADMIN)
@Controller("academic-years")
export class AcademicYearsController {
  constructor(private readonly academicYearsService: AcademicYearsService) {}

  @Post()
  create(@Body() createAcademicYearDto: CreateAcademicYearDto) {
    return this.academicYearsService.create(createAcademicYearDto);
  }

  @Get()
  findAll() {
    return this.academicYearsService.findAll();
  }

  @Get(":id")
  findOne(@Param("id") id: string) {
    return this.academicYearsService.findOne(+id);
  }

  @Patch(":id")
  update(
    @Param("id") id: string,
    @Body() updateAcademicYearDto: UpdateAcademicYearDto,
  ) {
    return this.academicYearsService.update(+id, updateAcademicYearDto);
  }

  @Delete(":id")
  remove(@Param("id") id: string) {
    return this.academicYearsService.remove(+id);
  }
}
