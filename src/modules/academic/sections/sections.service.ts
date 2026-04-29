import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateSectionDto } from "./dto/create-section.dto";
import { UpdateSectionDto } from "./dto/update-section.dto";

@Injectable()
export class SectionsService {
  constructor(private readonly prisma: PrismaService) {}

  create(dto: CreateSectionDto) {
    const data: any = {
      ...dto,
      batch_id: BigInt(dto.batch_id),
      term_id: BigInt(dto.term_id),
    };
    if (dto.class_teacher_id)
      data.class_teacher_id = BigInt(dto.class_teacher_id);
    return this.prisma.section.create({
      data,
    });
  }

  async findAll(query: PaginationQueryDto) {
    const { page, limit, skip, take } = getPagination(query);
    const where = {
      is_active: true,
      ...(query.search
        ? {
            name: { contains: query.search, mode: "insensitive" as const },
          }
        : {}),
    };

    const [data, total] = await this.prisma.$transaction([
      this.prisma.section.findMany({
        where,
        skip,
        take,
        include: { batch: true, term: true, class_teacher: true },
        orderBy: { id: "desc" },
      }),
      this.prisma.section.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const section = await this.prisma.section.findUnique({
      where: { id: BigInt(id) },
      include: { batch: true, term: true, class_teacher: true },
    });

    if (!section) throw new NotFoundException("Section not found");
    return section;
  }

  update(id: number, dto: UpdateSectionDto) {
    const data: any = { ...dto };
    if (dto.batch_id) data.batch_id = BigInt(dto.batch_id);
    if (dto.term_id) data.term_id = BigInt(dto.term_id);
    if (dto.class_teacher_id)
      data.class_teacher_id = BigInt(dto.class_teacher_id);
    return this.prisma.section.update({
      where: { id: BigInt(id) },
      data,
    });
  }

  remove(id: number) {
    return this.prisma.section.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
