import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateDepartmentDto } from "./dto/create-department.dto";
import { UpdateDepartmentDto } from "./dto/update-department.dto";

@Injectable()
export class DepartmentsService {
  constructor(private readonly prisma: PrismaService) {}

  create(createDepartmentDto: CreateDepartmentDto) {
    const data: any = {
      name: createDepartmentDto.name,
      code: createDepartmentDto.code,
      school_id: BigInt(createDepartmentDto.school_id),
    };

    if (createDepartmentDto.hod_id) {
      data.hod_id = BigInt(createDepartmentDto.hod_id);
    }

    return this.prisma.department.create({ data });
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
      this.prisma.department.findMany({
        where,
        skip,
        take,
        include: { school: true, hod: true },
        orderBy: { id: "desc" },
      }),
      this.prisma.department.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const department = await this.prisma.department.findUnique({
      where: { id: BigInt(id) },
      include: { school: true, hod: true },
    });

    if (!department) {
      throw new NotFoundException("Department not found");
    }

    return department;
  }

  update(id: number, updateDepartmentDto: UpdateDepartmentDto) {
    const data: any = { ...updateDepartmentDto };

    if (updateDepartmentDto.school_id)
      data.school_id = BigInt(updateDepartmentDto.school_id);
    if (updateDepartmentDto.hod_id) data.hod_id = BigInt(updateDepartmentDto.hod_id);

    return this.prisma.department.update({
      where: { id: BigInt(id) },
      data,
    });
  }

  remove(id: number) {
    return this.prisma.department.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
