import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateWorkExperienceDto } from "./dto/create-work-experience.dto";
import { UpdateWorkExperienceDto } from "./dto/update-work-experience.dto";

@Injectable()
export class WorkExperiencesService {
  constructor(private readonly prisma: PrismaService) {}

  create(dto: CreateWorkExperienceDto) {
    return this.prisma.workExperience.create({
      data: {
        employee_id: BigInt(dto.employee_id),
        company: dto.company,
        role: dto.role,
        start_date: dto.start_date ? new Date(dto.start_date) : undefined,
        end_date: dto.end_date ? new Date(dto.end_date) : undefined,
        description: dto.description ?? "",
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
                company: {
                  contains: query.search,
                  mode: "insensitive" as const,
                },
              },
              {
                role: {
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
      this.prisma.workExperience.findMany({
        where,
        skip,
        take,
        include: { employee: true },
        orderBy: { id: "desc" },
      }),
      this.prisma.workExperience.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const experience = await this.prisma.workExperience.findUnique({
      where: { id: BigInt(id) },
      include: { employee: true },
    });

    if (!experience) {
      throw new NotFoundException("Work experience not found");
    }

    return experience;
  }

  update(id: number, dto: UpdateWorkExperienceDto) {
    const data: any = { ...dto };

    if (dto.employee_id) data.employee_id = BigInt(dto.employee_id);
    if (dto.start_date) data.start_date = new Date(dto.start_date);
    if (dto.end_date) data.end_date = new Date(dto.end_date);

    return this.prisma.workExperience.update({
      where: { id: BigInt(id) },
      data,
      include: { employee: true },
    });
  }

  remove(id: number) {
    return this.prisma.workExperience.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
