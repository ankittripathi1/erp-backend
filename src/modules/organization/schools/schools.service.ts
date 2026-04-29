import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateSchoolDto } from "./dto/create-school.dto";
import { UpdateSchoolDto } from "./dto/update-school.dto";

@Injectable()
export class SchoolsService {
  constructor(private readonly prisma: PrismaService) {}

  create(createSchoolDto: CreateSchoolDto) {
    const data: any = {
      name: createSchoolDto.name,
      code: createSchoolDto.code,
      campus_id: createSchoolDto.campus_id,
    };

    if (createSchoolDto.dean_id) {
      data.dean_id = createSchoolDto.dean_id;
    }

    return this.prisma.school.create({ data });
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
      this.prisma.school.findMany({
        where,
        skip,
        take,
        include: { campus: true, dean: true },
        orderBy: { id: "desc" },
      }),
      this.prisma.school.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const school = await this.prisma.school.findUnique({
      where: { id: BigInt(id) },
      include: { campus: true, dean: true },
    });

    if (!school) {
      throw new NotFoundException("School not found");
    }

    return school;
  }

  update(id: number, updateSchoolDto: UpdateSchoolDto) {
    const data: any = { ...updateSchoolDto };

    if (updateSchoolDto.campus_id)
      data.campus_id = BigInt(updateSchoolDto.campus_id);
    if (updateSchoolDto.dean_id) data.dean_id = BigInt(updateSchoolDto.dean_id);

    return this.prisma.school.update({
      where: { id: BigInt(id) },
      data,
    });
  }

  remove(id: number) {
    return this.prisma.school.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
