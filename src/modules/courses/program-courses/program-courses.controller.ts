import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  ParseIntPipe,
} from "@nestjs/common";
import { ProgramCoursesService } from "./program-courses.service";
import { CreateProgramCourseDto } from "./dto/create-program-course.dto";
import { UpdateProgramCourseDto } from "./dto/update-program-course.dto";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";

@Controller("program-courses")
export class ProgramCoursesController {
  constructor(private readonly programCoursesService: ProgramCoursesService) {}

  @Post()
  create(@Body() createProgramCourseDto: CreateProgramCourseDto) {
    return this.programCoursesService.create(createProgramCourseDto);
  }

  @Get()
  findAll(@Query() query: PaginationQueryDto) {
    return this.programCoursesService.findAll(query);
  }

  @Get(":id")
  findOne(@Param("id", ParseIntPipe) id: number) {
    return this.programCoursesService.findOne(id);
  }

  @Patch(":id")
  update(
    @Param("id", ParseIntPipe) id: number,
    @Body() updateProgramCourseDto: UpdateProgramCourseDto,
  ) {
    return this.programCoursesService.update(id, updateProgramCourseDto);
  }

  @Delete(":id")
  remove(@Param("id", ParseIntPipe) id: number) {
    return this.programCoursesService.remove(id);
  }
}
