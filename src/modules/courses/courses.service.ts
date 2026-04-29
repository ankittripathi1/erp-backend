import { Injectable, NotFoundException } from "@nestjs/common";
import { CreateCourseDto } from "./dto/create-course.dto";
import { UpdateCourseDto } from "./dto/update-course.dto";
import { PrismaService } from "src/prisma/prisma.service";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { contains } from "class-validator";
import { title } from "node:process";
import { describe } from "node:test";
import { NotFoundError } from "rxjs";

@Injectable()
export class CoursesService {
  constructor(private readonly prisma: PrismaService) {}

  create(createCourseDto: CreateCourseDto) {
    return this.prisma.course.create({
      data: {
        department_id: BigInt(createCourseDto.department_id),
        code: createCourseDto.code,
        title: createCourseDto.title,
        credits: createCourseDto.credits,
        course_type: createCourseDto.course_type,
        theory_hours: createCourseDto.theory_hours ?? 0,
        practical_hours: createCourseDto.practical_hourse ?? 0,
        description: createCourseDto.description ?? "",
      },
      include: { department: true },
    });
  }

  async findAll(query: PaginationQueryDto) {
    const { page, limit, skip, take } = getPagination(query);

    const where = {
      is_active: true,
      ...(query.search
        ? {
            OR: [
              {
                code: { contains: query.search, mode: "insensitive" as const },
              },
              {
                title: { contains: query.search, mode: "insensitive" as const },
              },
              {
                descritpion: {
                  contains: query.search,
                  mode: "insensitive" as const,
                },
              },
            ],
          }
        : {}),
    };

    const [data, total] = await this.prisma.$transaction([
      this.prisma.course.findMany({
        where,
        skip,
        take,
        include: { department: true },
        orderBy: { id: "desc" },
      }),
      this.prisma.course.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const course = await this.prisma.course.findUnique({
      where: { id: BigInt(id) },
      include: { department: true },
    });

    if (!course) {
      throw new NotFoundException("Course not found");
    }

    return course;
  }

  update(id: number, updateCourseDto: UpdateCourseDto) {
    const data: any = { ...updateCourseDto };

    if (updateCourseDto.department_id) {
      data.department_id = BigInt(updateCourseDto.department_id);
    }

    return this.prisma.course.update({
      where: { id: BigInt(id) },
      data,
      include: { department: true },
    });
  }

  remove(id: number) {
    return this.prisma.course.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
