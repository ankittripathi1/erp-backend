import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateGuardianDto } from "./dto/create-guardian.dto";
import { UpdateGuardianDto } from "./dto/update-guardian.dto";

@Injectable()
export class GuardiansService {
  constructor(private readonly prisma: PrismaService) {}

  create(dto: CreateGuardianDto) {
    return this.prisma.guardian.create({
      data: {
        user_id: dto.user_id ? BigInt(dto.user_id) : undefined,
        name: dto.name,
        relation: dto.relation,
        occupation: dto.occupation ?? "",
        annual_income: dto.annual_income,
        phone: dto.phone ?? "",
        email: dto.email ?? "",
        address_id: dto.address_id ? BigInt(dto.address_id) : undefined,
      },
      include: { user: true, address: true },
    });
  }

  async findAll(query: PaginationQueryDto) {
    const { page, limit, skip, take } = getPagination(query);
    const where = {
      is_active: true,
      ...(query.search
        ? {
            OR: [
              { name: { contains: query.search, mode: "insensitive" as const } },
              { relation: { contains: query.search, mode: "insensitive" as const } },
              { phone: { contains: query.search, mode: "insensitive" as const } },
              { email: { contains: query.search, mode: "insensitive" as const } },
            ],
          }
        : {}),
    };

    const [data, total] = await this.prisma.$transaction([
      this.prisma.guardian.findMany({
        where,
        skip,
        take,
        include: { user: true, address: true },
        orderBy: { id: "desc" },
      }),
      this.prisma.guardian.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const guardian = await this.prisma.guardian.findUnique({
      where: { id: BigInt(id) },
      include: { user: true, address: true },
    });

    if (!guardian) throw new NotFoundException("Guardian not found");
    return guardian;
  }

  update(id: number, dto: UpdateGuardianDto) {
    const data: any = { ...dto };
    if (dto.user_id) data.user_id = BigInt(dto.user_id);
    if (dto.address_id) data.address_id = BigInt(dto.address_id);

    return this.prisma.guardian.update({
      where: { id: BigInt(id) },
      data,
      include: { user: true, address: true },
    });
  }

  remove(id: number) {
    return this.prisma.guardian.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
