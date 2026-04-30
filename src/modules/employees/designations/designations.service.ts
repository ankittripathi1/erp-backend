import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateDesignationDto } from "./dto/create-designation.dto";
import { UpdateDesignationDto } from "./dto/update-designation.dto";

@Injectable()
export class DesignationsService {
  constructor(private readonly prisma: PrismaService) {}

  create(dto: CreateDesignationDto) {
    return this.prisma.designation.create({
      data: dto,
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
                name: { contains: query.search, mode: "insensitive" as const },
              },
              {
                category: {
                  contains: query.search,
                  mode: "insensitive" as const,
                },
              },
            ],
          }
        : {}),
    };

    const [data, total] = await this.prisma.$transaction([
      this.prisma.designation.findMany({
        where,
        skip,
        take,
        orderBy: { id: "desc" },
      }),
      this.prisma.designation.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const designation = await this.prisma.designation.findUnique({
      where: { id: BigInt(id) },
    });

    if (!designation) {
      throw new NotFoundException("Designation not found");
    }

    return designation;
  }

  update(id: number, dto: UpdateDesignationDto) {
    return this.prisma.designation.update({
      where: { id: BigInt(id) },
      data: dto,
    });
  }

  remove(id: number) {
    return this.prisma.designation.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
