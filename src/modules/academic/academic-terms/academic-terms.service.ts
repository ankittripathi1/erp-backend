import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateAcademicTermDto } from './dto/create-academic-term.dto';
import { UpdateAcademicTermDto } from './dto/update-academic-term.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class AcademicTermsService {
  constructor(private readonly prisma: PrismaService) { }

  async create(createAcademicTermDto: CreateAcademicTermDto) {
    if (createAcademicTermDto.is_current) {
      await this.prisma.academicTerm.updateMany({
        where: { is_current: true },
        data: { is_current: false }
      })
    }

    const data: any = {
      name: createAcademicTermDto.name,
      term_type: createAcademicTermDto.term_type,
      academic_year_id: BigInt(createAcademicTermDto.academic_year_id),
      is_current: createAcademicTermDto.is_current ?? false,
    }

    if (createAcademicTermDto.start_date) data.start_date = new Date(createAcademicTermDto.start_date)
    if (createAcademicTermDto.end_date) data.end_date = new Date(createAcademicTermDto.end_date)

    return this.prisma.academicTerm.create({ data })

  }

  findAll() {
    return this.prisma.academicTerm.findMany({
      where: { is_active: true },
      include: { academic_year: true }
    })
  }

  async findOne(id: number) {
    const term = await this.prisma.academicTerm.findUnique({
      where: { id: BigInt(id) },
      include: { academic_year: true }
    })

    if (!term) throw new NotFoundException('Academic Term not found');
    return term;
  }

  async update(id: number, dto: UpdateAcademicTermDto) {
    const data: any = { ...dto };
    if (dto.academic_year_id) data.academic_year_id = BigInt(dto.academic_year_id)
    if (dto.start_date) data.start_date = new Date(dto.start_date)
    if (dto.end_date) data.end_date = new Date(dto.end_date)

    if (dto.is_current) {
      await this.prisma.academicTerm.updateMany({
        where: { is_current: true, id: { not: BigInt(id) } },
        data: { is_current: false }
      })
    }

    return this.prisma.academicTerm.update({
      where: { id: BigInt(id) },
      data,
    })
  }

  remove(id: number) {
    return this.prisma.academicTerm.update({
      where: { id: BigInt(id) },
      data: { is_active: false }
    })
  }
}
