import { Injectable, NotFoundException } from "@nestjs/common";
import { CreateProgramCourseDto } from "./dto/create-program-course.dto";
import { UpdateProgramCourseDto } from "./dto/update-program-course.dto";
import { PrismaService } from "src/prisma/prisma.service";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import { getPagination } from "src/common/utils/pagination.util";

@Injectable()
export class ProgramCoursesService {
  constructor(private readonly prisma: PrismaService) {}

  create(createProgramCourseDto: CreateProgramCourseDto) {
    return this.prisma.programCourse.create({
      data: {
        program_id: BigInt(createProgramCourseDto.program_id),
        course_id: BigInt(createProgramCourseDto.course_id),
        term_number: createProgramCourseDto.term_number,
        is_mandatory: createProgramCourseDto.is_mandatory ?? true,
      },
      include: { program: true, course: true },
    });
  }

  async findAll(query: PaginationQueryDto) {
    const { page, limit, skip, take } = getPagination(query);

    const where = {
      is_active: true,
    };
    const [data, total] = await this.prisma.$transaction([
      this.prisma.programCourse.findMany({
        where,
        skip,
        take,
        include: { program: true, course: true },
        orderBy: { id: "desc" },
      }),
      this.prisma.programCourse.count({
        where,
      }),
    ]);
  }

  async findOne(id: number) {
    const item = await this.prisma.programCourse.findUnique({
      where: { id: BigInt(id) },
      include: { program: true, course: true },
    });

    if (!item) {
      throw new NotFoundException("Program course not found");
    }

    return item;
  }

  update(id: number, updateProgramCourseDto: UpdateProgramCourseDto) {
    const data: any = { ...updateProgramCourseDto };

    if (updateProgramCourseDto.program_id) {
      data.program_id = BigInt(updateProgramCourseDto.program_id);
    }
    if (updateProgramCourseDto.course_id) {
      data.course_id = BigInt(updateProgramCourseDto.course_id);
    }

    return this.prisma.programCourse.update({
      where: { id: BigInt(id) },
      data,
      include: { program: true, course: true },
    });
  }

  remove(id: number) {
    return this.prisma.programCourse.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
