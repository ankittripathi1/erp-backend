import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreateStudentEnrollmentDto } from './dto/create-student-enrollment.dto';
import { UpdateStudentEnrollmentDto } from './dto/update-student-enrollment.dto';
import { PaginationQueryDto } from 'src/common/dto/pagination-query.dto';
import {
  createPaginationResponse,
  getPagination,
} from 'src/common/utils/pagination.util';
import { Prisma } from 'generated/prisma/client';

@Injectable()
export class StudentEnrollmentsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createDto: CreateStudentEnrollmentDto) {
    return this.prisma.studentEnrollment.create({
      data: {
        student_id: BigInt(createDto.student_id),
        offering_id: BigInt(createDto.offering_id),
        enrolled_on: new Date(createDto.enrolled_on),
        status: createDto.status,
      },
      include: {
        student: {
          include: {
            user: true,
          },
        },
        offering: {
          include: {
            course: true,
            term: true,
          },
        },
      },
    });
  }

  async findAll(query: PaginationQueryDto) {
    const { page, limit, skip, take } = getPagination(query);

    const where: Prisma.StudentEnrollmentWhereInput = {
      is_active: true,
      ...(query.search
        ? {
            OR: [
              {
                status: { contains: query.search, mode: 'insensitive' as const },
              },
              {
                student: {
                  user: {
                    OR: [
                      { first_name: { contains: query.search, mode: 'insensitive' as const } },
                      { last_name: { contains: query.search, mode: 'insensitive' as const } },
                      { username: { contains: query.search, mode: 'insensitive' as const } },
                    ],
                  },
                },
              },
              {
                offering: {
                  course: {
                    title: { contains: query.search, mode: 'insensitive' as const },
                  },
                },
              },
            ],
          }
        : {}),
    };

    const [data, total] = await this.prisma.$transaction([
      this.prisma.studentEnrollment.findMany({
        where,
        skip,
        take,
        include: {
          student: {
            include: {
              user: true,
            },
          },
          offering: {
            include: {
              course: true,
              term: true,
            },
          },
        },
        orderBy: { id: 'desc' },
      }),
      this.prisma.studentEnrollment.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const enrollment = await this.prisma.studentEnrollment.findUnique({
      where: { id: BigInt(id) },
      include: {
        student: {
          include: {
            user: true,
          },
        },
        offering: {
          include: {
            course: true,
            term: true,
          },
        },
      },
    });

    if (!enrollment) {
      throw new NotFoundException(`Student enrollment with ID ${id} not found`);
    }

    return enrollment;
  }

  async update(id: number, updateDto: UpdateStudentEnrollmentDto) {
    const data: any = { ...updateDto };

    if (updateDto.student_id) {
      data.student_id = BigInt(updateDto.student_id);
    }
    if (updateDto.offering_id) {
      data.offering_id = BigInt(updateDto.offering_id);
    }
    if (updateDto.enrolled_on) {
      data.enrolled_on = new Date(updateDto.enrolled_on);
    }

    return this.prisma.studentEnrollment.update({
      where: { id: BigInt(id) },
      data,
      include: {
        student: {
          include: {
            user: true,
          },
        },
        offering: {
          include: {
            course: true,
            term: true,
          },
        },
      },
    });
  }

  async remove(id: number) {
    return this.prisma.studentEnrollment.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }
}
