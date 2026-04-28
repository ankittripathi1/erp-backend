import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateProgramDto } from './dto/create-program.dto';
import { UpdateProgramDto } from './dto/update-program.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class ProgramsService {
  constructor(private readonly prisma: PrismaService) { }

  create(dto: CreateProgramDto) {
    const data: any = { ...dto, department_id: BigInt(dto.department_id) };

    if (dto.grading_scheme_id) data.grading_scheme_id = BigInt(dto.grading_scheme_id)
    return this.prisma.program.create({
      data
    })
  }

  findAll() {
    return this.prisma.program.findMany({
      where: { is_active: true },
      include: { department: true, grading_scheme: true }
    })
  }

  async findOne(id: number) {
    const program = await this.prisma.program.findUnique({
      where: { id: BigInt(id) },
      include: { department: true, grading_scheme: true }
    })
    if (!program) throw new NotFoundException('Program not found');
    return program;
  }

  update(id: number, dto: UpdateProgramDto) {
    const data: any = { ...dto };
    if (dto.department_id) data.department_id = BigInt(dto.department_id)
    if (dto.grading_scheme_id) data.grading_scheme_id = BigInt(dto.grading_scheme_id)

    return this.prisma.program.update({
      where: { id: BigInt(id) },
      data,
    })
  }

  remove(id: number) {
    return this.prisma.program.update({
      where: { id: BigInt(id) },
      data: { is_active: false }
    })
  }
}
