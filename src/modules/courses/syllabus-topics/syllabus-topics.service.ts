import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateSyllabusTopicDto } from "./dto/create-syllabus-topic.dto";
import { UpdateSyllabusTopicDto } from "./dto/update-syllabus-topic.dto";

@Injectable()
export class SyllabusTopicsService {
  constructor(private readonly prisma: PrismaService) {}

  create(dto: CreateSyllabusTopicDto) {
    return this.prisma.syllabusTopic.create({
      data: {
        course_id: BigInt(dto.course_id),
        unit_number: dto.unit_number,
        title: dto.title,
        description: dto.description ?? "",
        expected_hours: dto.expected_hours,
      },
      include: { course: true },
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
                title: {
                  contains: query.search,
                  mode: "insensitive" as const,
                },
              },
              {
                description: {
                  contains: query.search,
                  mode: "insensitive" as const,
                },
              },
            ],
          }
        : {}),
    };

    const [data, total] = await this.prisma.$transaction([
      this.prisma.syllabusTopic.findMany({
        where,
        skip,
        take,
        include: { course: true },
        orderBy: [{ course_id: "asc" }, { unit_number: "asc" }, { id: "asc" }],
      }),
      this.prisma.syllabusTopic.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const topic = await this.prisma.syllabusTopic.findUnique({
      where: { id: BigInt(id) },
      include: { course: true },
    });

    if (!topic) {
      throw new NotFoundException("Syllabus topic not found");
    }

    return topic;
  }

  update(id: number, dto: UpdateSyllabusTopicDto) {
    const data: any = { ...dto };

    if (dto.course_id) data.course_id = BigInt(dto.course_id);

    return this.prisma.syllabusTopic.update({
      where: { id: BigInt(id) },
      data,
      include: { course: true },
    });
  }

  remove(id: number) {
    return this.prisma.syllabusTopic.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
