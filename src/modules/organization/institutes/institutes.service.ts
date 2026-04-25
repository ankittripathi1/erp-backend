import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateInstituteDto } from './dto/create-institute.dto';
import { UpdateInstituteDto } from './dto/update-institute.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class InstitutesService {
  constructor(private readonly prisma: PrismaService) { }

  create(createInstituteDto: CreateInstituteDto) {
    return this.prisma.institute.create({
      data: createInstituteDto
    })
  }

  findAll() {
    return this.prisma.institute.findMany({
      where: { is_active: true }
    })
  }

  async findOne(id: number) {
    const institute = await this.prisma.institute.findUnique({
      where: { id: BigInt(id) }
    })

    if (!institute) {
      throw new NotFoundException("Institute not found");
    }

    return institute;
  }

  async update(id: number, updateInstituteDto: UpdateInstituteDto) {
    return this.prisma.institute.update({
      where: { id: BigInt(id) },
      data: updateInstituteDto,
    })
  }

  async remove(id: number) {
    return this.prisma.institute.update({
      where: { id: BigInt(id) },
      data: { is_active: false }
    })
  }
}
