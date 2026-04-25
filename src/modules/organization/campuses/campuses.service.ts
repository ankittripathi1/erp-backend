import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateCampusDto } from './dto/create-campus.dto';
import { UpdateCampusDto } from './dto/update-campus.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class CampusesService {
  constructor(private readonly prisma: PrismaService) { }

  create(createCampusDto: CreateCampusDto) {
    return this.prisma.campus.create({
      data: {
        name: createCampusDto.name,
        code: createCampusDto.code,
        institute_id: BigInt(createCampusDto.institute_id)
      }
    })
  }

  findAll() {
    return this.prisma.campus.findMany({
      where: { is_active: true },
      include: { institute: true }
    });
  }

  async findOne(id: number) {
    const campus = await this.prisma.campus.findUnique({
      where: { id: BigInt(id) },
      include: { institute: true }
    })

    if (!campus) {
      throw new NotFoundException("Campus not found")
    }

    return campus
  }

  update(id: number, updateCampusDto: UpdateCampusDto) {
    const data: any = { ...updateCampusDto };

    if (updateCampusDto.institute_id) {
      data.institute_id = BigInt(updateCampusDto.institute_id)
    }

    return this.prisma.campus.update({
      where: { id: BigInt(id) },
      data,
    })
  }

  remove(id: number) {
    return this.prisma.campus.update({
      where: { id: BigInt(id) },
      data: { is_active: false }
    })
  }
}
