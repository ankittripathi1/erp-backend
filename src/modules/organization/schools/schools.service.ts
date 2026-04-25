import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateSchoolDto } from './dto/create-school.dto';
import { UpdateSchoolDto } from './dto/update-school.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class SchoolsService {
  constructor(private readonly prisma: PrismaService) { }

  create(createSchoolDto: CreateSchoolDto) {
    const data: any = {
      name: createSchoolDto.name,
      code: createSchoolDto.code,
      campus_id: createSchoolDto.campus_id,
    };

    if (createSchoolDto.dean_id) {
      data.dean_id = createSchoolDto.dean_id
    }

    return this.prisma.school.create({ data })
  }

  findAll() {
    return this.prisma.school.findMany({
      where: { is_active: true },
      include: { campus: true, dean: true }
    });
  }

  async findOne(id: number) {
    const school = await this.prisma.school.findUnique({
      where: { id: BigInt(id) },
      include: { campus: true, dean: true }
    })

    if (!school) {
      throw new NotFoundException('School not found');
    }

    return school
  }

  update(id: number, updateSchoolDto: UpdateSchoolDto) {
    const data: any = { ...updateSchoolDto };

    if (updateSchoolDto.campus_id) data.campus_id = BigInt(updateSchoolDto.campus_id);
    if (updateSchoolDto.dean_id) data.dean_id = BigInt(updateSchoolDto.dean_id);

    return this.prisma.school.update({
      where: { id: BigInt(id) },
      data,
    });
  }

  remove(id: number) {
    return this.prisma.school.update({
      where: { id: BigInt(id) },
      data: { is_active: false }
    })
  }
}
