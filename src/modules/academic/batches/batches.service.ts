import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateBatchDto } from './dto/create-batch.dto';
import { UpdateBatchDto } from './dto/update-batch.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class BatchesService {
  constructor(private readonly prisma: PrismaService) { }

  create(dto: CreateBatchDto) {
    const data: any = { ...dto, program_id: BigInt(dto.program_id) }
    return this.prisma.batch.create({ data })
  }

  findAll() {
    return this.prisma.batch.findMany({
      where: { is_active: true },
      include: { program: true }
    })
  }

  async findOne(id: number) {
    const batch = await this.prisma.batch.findUnique({
      where: { id: BigInt(id) },
      include: { program: true }
    });
    if (!batch) throw new NotFoundException('Batch not found')
    return batch;
  }

  update(id: number, dto: UpdateBatchDto) {
    const data: any = { ...dto };
    if (dto.program_id) data.program_id = BigInt(dto.program_id)
    return this.prisma.batch.update({
      where: { id: BigInt(id) },
      data,
    })
  }

  remove(id: number) {
    return this.prisma.batch.update({
      where: { id: BigInt(id) },
      data: { is_active: false }
    })
  }
}
