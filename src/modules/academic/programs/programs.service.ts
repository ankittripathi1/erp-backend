import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateProgramDto } from "./dto/create-program.dto";
import { UpdateProgramDto } from "./dto/update-program.dto";

@Injectable()
export class ProgramsService {
  constructor(private readonly prisma: PrismaService) {}

  create(dto: CreateProgramDto) {
    const data: any = { ...dto, department_id: BigInt(dto.department_id) };

    if (dto.grading_scheme_id)
      data.grading_scheme_id = BigInt(dto.grading_scheme_id);
    return this.prisma.program.create({
      data,
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
      this.prisma.program.findMany({
        where,
        skip,
        take,
        include: { department: true, grading_scheme: true },
        orderBy: { id: "desc" },
      }),
      this.prisma.program.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const program = await this.prisma.program.findUnique({
      where: { id: BigInt(id) },
      include: { department: true, grading_scheme: true },
    });
    if (!program) throw new NotFoundException("Program not found");
    return program;
  }

  update(id: number, dto: UpdateProgramDto) {
    const data: any = { ...dto };
    if (dto.department_id) data.department_id = BigInt(dto.department_id);
    if (dto.grading_scheme_id)
      data.grading_scheme_id = BigInt(dto.grading_scheme_id);

    return this.prisma.program.update({
      where: { id: BigInt(id) },
      data,
    });
  }

  remove(id: number) {
    return this.prisma.program.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
