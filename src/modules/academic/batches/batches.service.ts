import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateBatchDto } from "./dto/create-batch.dto";
import { UpdateBatchDto } from "./dto/update-batch.dto";

@Injectable()
export class BatchesService {
  constructor(private readonly prisma: PrismaService) {}

  create(dto: CreateBatchDto) {
    const data: any = { ...dto, program_id: BigInt(dto.program_id) };
    return this.prisma.batch.create({ data });
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
      this.prisma.batch.findMany({
        where,
        skip,
        take,
        include: { program: true },
        orderBy: { id: "desc" },
      }),
      this.prisma.batch.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const batch = await this.prisma.batch.findUnique({
      where: { id: BigInt(id) },
      include: { program: true },
    });
    if (!batch) throw new NotFoundException("Batch not found");
    return batch;
  }

  update(id: number, dto: UpdateBatchDto) {
    const data: any = { ...dto };
    if (dto.program_id) data.program_id = BigInt(dto.program_id);
    return this.prisma.batch.update({
      where: { id: BigInt(id) },
      data,
    });
  }

  remove(id: number) {
    return this.prisma.batch.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
