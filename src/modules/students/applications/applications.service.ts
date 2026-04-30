import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateApplicationDto } from "./dto/create-application.dto";
import { UpdateApplicationDto } from "./dto/update-application.dto";

@Injectable()
export class ApplicationsService {
  constructor(private readonly prisma: PrismaService) {}

  create(dto: CreateApplicationDto) {
    return this.prisma.application.create({
      data: {
        application_no: dto.application_no,
        program_id: BigInt(dto.program_id),
        first_name: dto.first_name,
        last_name: dto.last_name,
        email: dto.email,
        phone: dto.phone,
        date_of_birth: dto.date_of_birth ? new Date(dto.date_of_birth) : undefined,
        gender: dto.gender ?? "",
        previous_qualification: dto.previous_qualification ?? "",
        previous_percentage: dto.previous_percentage,
        entrance_exam: dto.entrance_exam ?? "",
        entrance_score: dto.entrance_score,
        status: dto.status,
        applied_on: new Date(dto.applied_on),
        decision_on: dto.decision_on ? new Date(dto.decision_on) : undefined,
      },
      include: { program: true },
    });
  }

  async findAll(query: PaginationQueryDto) {
    const { page, limit, skip, take } = getPagination(query);
    const where = {
      is_active: true,
      ...(query.search
        ? {
            OR: [
              { application_no: { contains: query.search, mode: "insensitive" as const } },
              { first_name: { contains: query.search, mode: "insensitive" as const } },
              { last_name: { contains: query.search, mode: "insensitive" as const } },
              { email: { contains: query.search, mode: "insensitive" as const } },
              { phone: { contains: query.search, mode: "insensitive" as const } },
              { status: { contains: query.search, mode: "insensitive" as const } },
            ],
          }
        : {}),
    };

    const [data, total] = await this.prisma.$transaction([
      this.prisma.application.findMany({
        where,
        skip,
        take,
        include: { program: true },
        orderBy: { id: "desc" },
      }),
      this.prisma.application.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const application = await this.prisma.application.findUnique({
      where: { id: BigInt(id) },
      include: { program: true },
    });

    if (!application) throw new NotFoundException("Application not found");
    return application;
  }

  update(id: number, dto: UpdateApplicationDto) {
    const data: any = { ...dto };
    if (dto.program_id) data.program_id = BigInt(dto.program_id);
    if (dto.date_of_birth) data.date_of_birth = new Date(dto.date_of_birth);
    if (dto.applied_on) data.applied_on = new Date(dto.applied_on);
    if (dto.decision_on) data.decision_on = new Date(dto.decision_on);

    return this.prisma.application.update({
      where: { id: BigInt(id) },
      data,
      include: { program: true },
    });
  }

  remove(id: number) {
    return this.prisma.application.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
