import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateTeachingAssignmentDto } from "./dto/create-teaching-assignment.dto";
import { UpdateTeachingAssignmentDto } from "./dto/update-teaching-assignment.dto";

@Injectable()
export class TeachingAssignmentsService {
  constructor(private readonly prisma: PrismaService) {}

  create(dto: CreateTeachingAssignmentDto) {
    return this.prisma.teachingAssignment.create({
      data: {
        offering_id: BigInt(dto.offering_id),
        employee_id: BigInt(dto.employee_id),
        role: dto.role,
      },
      include: {
        offering: { include: { course: true, term: true, section: true } },
        employee: true,
      },
    });
  }

  async findAll(query: PaginationQueryDto) {
    const { page, limit, skip, take } = getPagination(query);

    const where = {
      is_active: true,
      ...(query.search
        ? {
            role: {
              contains: query.search,
              mode: "insensitive" as const,
            },
          }
        : {}),
    };

    const [data, total] = await this.prisma.$transaction([
      this.prisma.teachingAssignment.findMany({
        where,
        skip,
        take,
        include: {
          offering: { include: { course: true, term: true, section: true } },
          employee: true,
        },
        orderBy: { id: "desc" },
      }),
      this.prisma.teachingAssignment.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const assignment = await this.prisma.teachingAssignment.findUnique({
      where: { id: BigInt(id) },
      include: {
        offering: { include: { course: true, term: true, section: true } },
        employee: true,
      },
    });

    if (!assignment) {
      throw new NotFoundException("Teaching assignment not found");
    }

    return assignment;
  }

  update(id: number, dto: UpdateTeachingAssignmentDto) {
    const data: any = { ...dto };

    if (dto.offering_id) data.offering_id = BigInt(dto.offering_id);
    if (dto.employee_id) data.employee_id = BigInt(dto.employee_id);

    return this.prisma.teachingAssignment.update({
      where: { id: BigInt(id) },
      data,
      include: {
        offering: { include: { course: true, term: true, section: true } },
        employee: true,
      },
    });
  }

  remove(id: number) {
    return this.prisma.teachingAssignment.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
