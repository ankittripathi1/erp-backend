import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { CreateStudentDto } from "./dto/create-student.dto";
import { UpdateStudentDto } from "./dto/update-student.dto";

@Injectable()
export class StudentsService {
  constructor(private readonly prisma: PrismaService) {}

  create(dto: CreateStudentDto) {
    return this.prisma.student.create({
      data: {
        user_id: BigInt(dto.user_id),
        enrollment_no: dto.enrollment_no,
        roll_no: dto.roll_no,
        program_id: BigInt(dto.program_id),
        batch_id: BigInt(dto.batch_id),
        current_term_id: dto.current_term_id ? BigInt(dto.current_term_id) : undefined,
        current_section_id: dto.current_section_id
          ? BigInt(dto.current_section_id)
          : undefined,
        admission_date: new Date(dto.admission_date),
        admission_type: dto.admission_type,
        category: dto.category ?? "",
        religion: dto.religion ?? "",
        nationality: dto.nationality ?? "Indian",
        blood_group: dto.blood_group ?? "",
        aadhaar_no: dto.aadhaar_no ?? "",
        pan_no: dto.pan_no ?? "",
        status: dto.status,
      },
      include: this.includeRelations(),
    });
  }

  async findAll(query: PaginationQueryDto) {
    const { page, limit, skip, take } = getPagination(query);
    const where = {
      is_active: true,
      ...(query.search
        ? {
            OR: [
              { enrollment_no: { contains: query.search, mode: "insensitive" as const } },
              { roll_no: { contains: query.search, mode: "insensitive" as const } },
              { admission_type: { contains: query.search, mode: "insensitive" as const } },
              { status: { contains: query.search, mode: "insensitive" as const } },
            ],
          }
        : {}),
    };

    const [data, total] = await this.prisma.$transaction([
      this.prisma.student.findMany({
        where,
        skip,
        take,
        include: this.includeRelations(),
        orderBy: { id: "desc" },
      }),
      this.prisma.student.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const student = await this.prisma.student.findUnique({
      where: { id: BigInt(id) },
      include: this.includeRelations(),
    });

    if (!student) throw new NotFoundException("Student not found");
    return student;
  }

  update(id: number, dto: UpdateStudentDto) {
    const data: any = { ...dto };
    if (dto.user_id) data.user_id = BigInt(dto.user_id);
    if (dto.program_id) data.program_id = BigInt(dto.program_id);
    if (dto.batch_id) data.batch_id = BigInt(dto.batch_id);
    if (dto.current_term_id) data.current_term_id = BigInt(dto.current_term_id);
    if (dto.current_section_id)
      data.current_section_id = BigInt(dto.current_section_id);
    if (dto.admission_date) data.admission_date = new Date(dto.admission_date);

    return this.prisma.student.update({
      where: { id: BigInt(id) },
      data,
      include: this.includeRelations(),
    });
  }

  remove(id: number) {
    return this.prisma.student.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }

  private includeRelations() {
    return {
      user: true,
      program: true,
      batch: true,
      current_term: true,
      current_section: true,
    };
  }
}
