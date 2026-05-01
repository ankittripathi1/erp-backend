import bcrypt from "bcrypt";
import { Injectable, NotFoundException } from "@nestjs/common";
import { PaginationQueryDto } from "src/common/dto/pagination-query.dto";
import {
  createPaginationResponse,
  getPagination,
} from "src/common/utils/pagination.util";
import { PrismaService } from "src/prisma/prisma.service";
import { AuthUser } from "src/common/types/auth-user.type";
import { CreateEmployeeDto } from "./dto/create-employee.dto";
import { OnboardEmployeeDto } from "./dto/onboard-employee.dto";
import { UpdateEmployeeDto } from "./dto/update-employee.dto";
import { contains } from "class-validator";

@Injectable()
export class EmployeesService {
  constructor(private readonly prisma: PrismaService) {}

  async onboard(dto: OnboardEmployeeDto, actor: AuthUser) {
    const role = await this.prisma.role.findUnique({
      where: { code: dto.role_code },
    });

    if (!role) {
      throw new NotFoundException(`Role ${dto.role_code} not found`);
    }

    const passwordHash = await bcrypt.hash(dto.password, 12);
    const assignedById = actor?.id ? BigInt(actor.id) : null;

    return this.prisma.$transaction(async (tx) => {
      const user = await tx.user.create({
        data: {
          username: dto.username,
          password: passwordHash,
          email: dto.email,
          first_name: dto.first_name,
          middle_name: dto.middle_name ?? "",
          last_name: dto.last_name,
          phone: dto.phone ?? "",
          user_type: "employee",
          account_status: "active",
        },
      });

      await tx.userRole.create({
        data: {
          user_id: user.id,
          role_id: role.id,
          assigned_at: new Date(),
          assigned_by_id: assignedById ?? undefined,
          is_active: true,
        },
      });

      return tx.employee.create({
        data: {
          user_id: user.id,
          employee_no: dto.employee_no,
          department_id: dto.department_id
            ? BigInt(dto.department_id)
            : undefined,
          designation_id: BigInt(dto.designation_id),
          reports_to_id: dto.reports_to_id
            ? BigInt(dto.reports_to_id)
            : undefined,
          employment_type: dto.employment_type,
          joining_date: new Date(dto.joining_date),
          status: dto.status,
        },
        include: this.includeRelations(),
      });
    });
  }

  create(dto: CreateEmployeeDto) {
    return this.prisma.employee.create({
      data: {
        user_id: BigInt(dto.user_id),
        employee_no: dto.employee_no,
        department_id: dto.department_id
          ? BigInt(dto.department_id)
          : undefined,
        designation_id: BigInt(dto.designation_id),
        reports_to_id: dto.reports_to_id
          ? BigInt(dto.reports_to_id)
          : undefined,
        employment_type: dto.employment_type,
        joining_date: new Date(dto.joining_date),
        confirmation_date: dto.confirmation_date
          ? new Date(dto.confirmation_date)
          : undefined,
        exit_date: dto.exit_date ? new Date(dto.exit_date) : undefined,
        status: dto.status,
        pan_no: dto.pan_no ?? "",
        aadhaar_no: dto.aadhaar_no ?? "",
        pf_no: dto.pf_no ?? "",
        uan_no: dto.uan_no ?? "",
        bank_account_no: dto.bank_account_no ?? "",
        bank_ifsc: dto.bank_ifsc ?? "",
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
              {
                employee_no: {
                  contains: query.search,
                  mode: "insensitive" as const,
                },
              },
              {
                employment_type: {
                  contains: query.search,
                  mode: "insensitive" as const,
                },
              },
              {
                status: {
                  contains: query.search,
                  mode: "insensitive" as const,
                },
              },
              {
                user: {
                  OR: [
                    {
                      first_name: {
                        contains: query.search,
                        mode: "insensitive" as const,
                      },
                    },
                    {
                      last_name: {
                        contains: query.search,
                        mode: "insensitive" as const,
                      },
                    },
                    {
                      username: {
                        contains: query.search,
                        mode: "insensitive" as const,
                      },
                    },
                    {
                      email: {
                        contains: query.search,
                        mode: "insensitive" as const,
                      },
                    },
                  ],
                },
              },
            ],
          }
        : {}),
    };

    const [data, total] = await this.prisma.$transaction([
      this.prisma.employee.findMany({
        where,
        skip,
        take,
        include: this.includeRelations(),
        orderBy: { id: "desc" },
      }),
      this.prisma.employee.count({ where }),
    ]);

    return createPaginationResponse(data, total, page, limit);
  }

  async findOne(id: number) {
    const employee = await this.prisma.employee.findUnique({
      where: { id: BigInt(id) },
      include: this.includeRelations(),
    });

    if (!employee) {
      throw new NotFoundException("Employee not found");
    }

    return employee;
  }

  update(id: number, dto: UpdateEmployeeDto) {
    const data: any = { ...dto };

    if (dto.user_id) data.user_id = BigInt(dto.user_id);
    if (dto.department_id) data.department_id = BigInt(dto.department_id);
    if (dto.designation_id) data.designation_id = BigInt(dto.designation_id);
    if (dto.reports_to_id) data.reports_to_id = BigInt(dto.reports_to_id);
    if (dto.joining_date) data.joining_date = new Date(dto.joining_date);
    if (dto.confirmation_date)
      data.confirmation_date = new Date(dto.confirmation_date);
    if (dto.exit_date) data.exit_date = new Date(dto.exit_date);

    return this.prisma.employee.update({
      where: { id: BigInt(id) },
      data,
      include: this.includeRelations(),
    });
  }

  remove(id: number) {
    return this.prisma.employee.update({
      where: { id: BigInt(id) },
      data: { is_active: false },
    });
  }

  private includeRelations() {
    return {
      user: true,
      department: true,
      designation: true,
      reports_to: true,
    };
  }
}
