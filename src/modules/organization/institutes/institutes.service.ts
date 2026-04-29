import { Injectable, NotFoundException } from "@nestjs/common";
import { CreateInstituteDto } from "./dto/create-institute.dto";
import { UpdateInstituteDto } from "./dto/update-institute.dto";
import { PrismaService } from "src/prisma/prisma.service";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";

@Injectable()
export class InstitutesService {
  constructor(private readonly prisma: PrismaService) {}

  create(createInstituteDto: CreateInstituteDto) {
    return this.prisma.institute.create({
      data: createInstituteDto,
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
                code: { contains: query.search, mode: "insensitive" as const },
              },
            ],
          }
        : {}),
    };
    const [data, total] = await this.prisma.$transaction([
      this.prisma.institute.findMany({
        where,
        skip,
        take,
        orderBy: { id: "desc" },
      }),
      this.prisma.institute.count({ where }),
    ]);
    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const institute = await this.prisma.institute.findUnique({
      where: { id: BigInt(id) },
    });

    if (!institute) {
      throw new NotFoundException("Institute not found");
    }

    return institute;
  }

  async update(id: number, updateInstituteDto: UpdateInstituteDto) {
    return this.prisma.institute.update({
      where: { id: BigInt(id) },
      data: updateInstituteDto,
    });
  }

  async remove(id: number) {
    return this.prisma.institute.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
