import { Type } from "class-transformer";
import {
  IsDateString,
  IsEmail,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  MinLength,
} from "class-validator";

export class OnboardEmployeeDto {
  @IsString()
  @MinLength(3)
  username!: string;

  @IsString()
  @MinLength(6)
  password!: string;

  @IsOptional()
  @IsEmail()
  email?: string;

  @IsString()
  first_name!: string;

  @IsOptional()
  @IsString()
  middle_name?: string;

  @IsString()
  last_name!: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsString()
  @IsIn([
    "SUPER_ADMIN",
    "ADMIN",
    "FACULTY",
    "STAFF",
    "HR",
    "ACCOUNTANT",
    "LIBRARIAN",
  ])
  role_code!: string;

  @IsString()
  employee_no!: string;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  department_id?: number;

  @Type(() => Number)
  @IsInt()
  designation_id!: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  reports_to_id?: number;

  @IsString()
  employment_type!: string;

  @IsDateString()
  joining_date!: string;

  @IsString()
  status!: string;
}
