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
import { AcademicTermsService } from "./academic-terms.service";
import { CreateAcademicTermDto } from "./dto/create-academic-term.dto";
import { UpdateAcademicTermDto } from "./dto/update-academic-term.dto";
import { JwtAuthGuard } from "src/common/guards/jwt-auth.guard";
import { RolesGuard } from "src/common/guards/roles.guard";
import { Roles } from "src/common/decorators/roles.decorator";
import { AppRole } from "src/common/constants/role.constants";

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
  findAll() {
    return this.academicTermsService.findAll();
  }

  @Get(":id")
  findOne(@Param("id") id: string) {
    return this.academicTermsService.findOne(+id);
  }

  @Patch(":id")
  update(
    @Param("id") id: string,
    @Body() updateAcademicTermDto: UpdateAcademicTermDto,
  ) {
    return this.academicTermsService.update(+id, updateAcademicTermDto);
  }

  @Delete(":id")
  remove(@Param("id") id: string) {
    return this.academicTermsService.remove(+id);
  }
}
