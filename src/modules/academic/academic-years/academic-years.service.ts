import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateAcademicYearDto } from "./dto/create-academic-year.dto";
import { UpdateAcademicYearDto } from "./dto/update-academic-year.dto";

@Injectable()
export class AcademicYearsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createAcademicYearDto: CreateAcademicYearDto) {
    if (createAcademicYearDto.is_current) {
      await this.prisma.academicYear.updateMany({
        where: { is_current: true },
        data: { is_current: false },
      });
    }

    return this.prisma.academicYear.create({
      data: {
        name: createAcademicYearDto.name,
        start_date: new Date(createAcademicYearDto.start_date),
        end_date: new Date(createAcademicYearDto.end_date),
        is_current: createAcademicYearDto.is_current ?? false,
      },
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
      this.prisma.academicYear.findMany({
        where,
        skip,
        take,
        orderBy: { start_date: "desc" },
      }),
      this.prisma.academicYear.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const year = await this.prisma.academicYear.findUnique({
      where: { id: BigInt(id) },
    });

    if (!year) throw new NotFoundException("Academic Year not found");

    return year;
  }

  async update(id: number, updateAcademicYearDto: UpdateAcademicYearDto) {
    const data: any = { ...updateAcademicYearDto };

    if (updateAcademicYearDto.start_date)
      data.start_date = new Date(updateAcademicYearDto.start_date);
    if (updateAcademicYearDto.end_date)
      data.end_date = new Date(updateAcademicYearDto.end_date);

    if (updateAcademicYearDto.is_current) {
      await this.prisma.academicYear.updateMany({
        where: { is_current: true, id: { not: BigInt(id) } },
        data: { is_current: false },
      });
    }

    return this.prisma.academicYear.update({
      where: { id: BigInt(id) },
      data,
    });
  }

  remove(id: number) {
    return this.prisma.academicYear.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
