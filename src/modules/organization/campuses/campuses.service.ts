import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateCampusDto } from "./dto/create-campus.dto";
import { UpdateCampusDto } from "./dto/update-campus.dto";

@Injectable()
export class CampusesService {
  constructor(private readonly prisma: PrismaService) {}

  create(createCampusDto: CreateCampusDto) {
    return this.prisma.campus.create({
      data: {
        name: createCampusDto.name,
        code: createCampusDto.code,
        institute_id: BigInt(createCampusDto.institute_id),
      },
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
      this.prisma.campus.findMany({
        where,
        skip,
        take,
        include: { institute: true },
        orderBy: { id: "desc" },
      }),
      this.prisma.campus.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const campus = await this.prisma.campus.findUnique({
      where: { id: BigInt(id) },
      include: { institute: true },
    });

    if (!campus) {
      throw new NotFoundException("Campus not found");
    }

    return campus;
  }

  update(id: number, updateCampusDto: UpdateCampusDto) {
    const data: any = { ...updateCampusDto };

    if (updateCampusDto.institute_id) {
      data.institute_id = BigInt(updateCampusDto.institute_id);
    }

    return this.prisma.campus.update({
      where: { id: BigInt(id) },
      data,
    });
  }

  remove(id: number) {
    return this.prisma.campus.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
