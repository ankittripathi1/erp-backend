import { Type } from "class-transformer";
import { IsDateString, IsInt, IsOptional, IsString } from "class-validator";

export class CreateEmployeeDto {
  @Type(() => Number)
  @IsInt()
  user_id!: number;

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

  @IsOptional()
  @IsDateString()
  confirmation_date?: string;

  @IsOptional()
  @IsDateString()
  exit_date?: string;

  @IsString()
  status!: string;

  @IsOptional()
  @IsString()
  pan_no?: string;

  @IsOptional()
  @IsString()
  aadhaar_no?: string;

  @IsOptional()
  @IsString()
  pf_no?: string;

  @IsOptional()
  @IsString()
  uan_no?: string;

  @IsOptional()
  @IsString()
  bank_account_no?: string;

  @IsOptional()
  @IsString()
  bank_ifsc?: string;
}
