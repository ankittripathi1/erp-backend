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
import { CourseOfferingsService } from "./course-offerings.service";
import { CreateCourseOfferingDto } from "./dto/create-course-offering.dto";
import { UpdateCourseOfferingDto } from "./dto/update-course-offering.dto";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";

@Controller("course-offerings")
export class CourseOfferingsController {
  constructor(
    private readonly courseOfferingsService: CourseOfferingsService,
  ) {}

  @Post()
  create(@Body() createCourseOfferingDto: CreateCourseOfferingDto) {
    return this.courseOfferingsService.create(createCourseOfferingDto);
  }

  @Get()
  findAll(@Query() query: PaginationQueryDto) {
    return this.courseOfferingsService.findAll(query);
  }

  @Get(":id")
  findOne(@Param("id", ParseIntPipe) id: number) {
    return this.courseOfferingsService.findOne(id);
  }

  @Patch(":id")
  update(
    @Param("id", ParseIntPipe) id: number,
    @Body() updateCourseOfferingDto: UpdateCourseOfferingDto,
  ) {
    return this.courseOfferingsService.update(id, updateCourseOfferingDto);
  }

  @Delete(":id")
  remove(@Param("id", ParseIntPipe) id: number) {
    return this.courseOfferingsService.remove(id);
  }
}
