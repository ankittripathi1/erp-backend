import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateQualificationDto } from "./dto/create-qualification.dto";
import { UpdateQualificationDto } from "./dto/update-qualification.dto";

@Injectable()
export class QualificationsService {
  constructor(private readonly prisma: PrismaService) {}

  create(dto: CreateQualificationDto) {
    return this.prisma.qualification.create({
      data: {
        employee_id: BigInt(dto.employee_id),
        degree: dto.degree,
        institution: dto.institution,
        year: dto.year,
        percentage: dto.percentage,
        specialization: dto.specialization ?? "",
      },
      include: { employee: true },
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
                degree: {
                  contains: query.search,
                  mode: "insensitive" as const,
                },
              },
              {
                institution: {
                  contains: query.search,
                  mode: "insensitive" as const,
                },
              },
              {
                specialization: {
                  contains: query.search,
                  mode: "insensitive" as const,
                },
              },
            ],
          }
        : {}),
    };

    const [data, total] = await this.prisma.$transaction([
      this.prisma.qualification.findMany({
        where,
        skip,
        take,
        include: { employee: true },
        orderBy: { id: "desc" },
      }),
      this.prisma.qualification.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const qualification = await this.prisma.qualification.findUnique({
      where: { id: BigInt(id) },
      include: { employee: true },
    });

    if (!qualification) {
      throw new NotFoundException("Qualification not found");
    }

    return qualification;
  }

  update(id: number, dto: UpdateQualificationDto) {
    const data: any = { ...dto };

    if (dto.employee_id) data.employee_id = BigInt(dto.employee_id);

    return this.prisma.qualification.update({
      where: { id: BigInt(id) },
      data,
      include: { employee: true },
    });
  }

  remove(id: number) {
    return this.prisma.qualification.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
