import { Injectable, NotFoundException } from "@nestjs/common";
import { CreateCourseOfferingDto } from "./dto/create-course-offering.dto";
import { UpdateCourseOfferingDto } from "./dto/update-course-offering.dto";
import { PrismaService } from "src/prisma/prisma.service";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";

@Injectable()
export class CourseOfferingsService {
  constructor(private readonly prisma: PrismaService) {}

  create(createCourseOfferingDto: CreateCourseOfferingDto) {
    return this.prisma.courseOffering.create({
      data: {
        course_id: BigInt(createCourseOfferingDto.course_id),
        term_id: BigInt(createCourseOfferingDto.term_id),
        section_id: createCourseOfferingDto.section_id
          ? BigInt(createCourseOfferingDto.section_id)
          : undefined,
        primary_teacher_id: createCourseOfferingDto.primary_teacher_id
          ? BigInt(createCourseOfferingDto.primary_teacher_id)
          : undefined,
        room_id: createCourseOfferingDto.room_id
          ? BigInt(createCourseOfferingDto.room_id)
          : undefined,
        capacity: createCourseOfferingDto.capacity,
      },
      include: {
        course: true,
        term: true,
        section: true,
        primary_teacher: true,
        room: true,
      },
    });
  }

  async findAll(query: PaginationQueryDto) {
    const { page, limit, skip, take } = getPagination(query);

    const where = {
      is_active: true,
    };

    const [data, total] = await this.prisma.$transaction([
      this.prisma.courseOffering.findMany({
        where,
        skip,
        take,
        include: {
          course: true,
          term: true,
          section: true,
          primary_teacher: true,
          room: true,
        },
      }),
      this.prisma.courseOffering.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const offering = await this.prisma.courseOffering.findUnique({
      where: { id: BigInt(id) },
      include: {
        course: true,
        term: true,
        section: true,
        primary_teacher: true,
        room: true,
      },
    });

    if (!offering) {
      throw new NotFoundException("Course offering not found");
    }

    return offering;
  }

  update(id: number, dto: UpdateCourseOfferingDto) {
    const data: any = { ...dto };

    if (dto.course_id) data.course_id = BigInt(dto.course_id);
    if (dto.term_id) data.term_id = BigInt(dto.term_id);
    if (dto.section_id) data.section_id = BigInt(dto.section_id);
    if (dto.primary_teacher_id)
      data.primary_teacher_id = BigInt(dto.primary_teacher_id);
    if (dto.room_id) data.room_id = BigInt(dto.room_id);

    return this.prisma.courseOffering.update({
      where: { id: BigInt(id) },
      data,
      include: {
        course: true,
        term: true,
        section: true,
        primary_teacher: true,
        room: true,
      },
    });
  }

  remove(id: number) {
    return this.prisma.courseOffering.update({
      where: { id: BigInt(id) },
      data: { is_active: true },
    });
  }
}
