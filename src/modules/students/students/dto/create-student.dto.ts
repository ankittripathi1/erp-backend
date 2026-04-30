import { Type } from "class-transformer";
import { IsDateString, IsInt, IsOptional, IsString } from "class-validator";

export class CreateStudentDto {
  @Type(() => Number)
  @IsInt()
  user_id!: number;

  @IsString()
  enrollment_no!: string;

  @IsString()
  roll_no!: string;

  @Type(() => Number)
  @IsInt()
  program_id!: number;

  @Type(() => Number)
  @IsInt()
  batch_id!: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  current_term_id?: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  current_section_id?: number;

  @IsDateString()
  admission_date!: string;

  @IsString()
  admission_type!: string;

  @IsOptional()
  @IsString()
  category?: string;

  @IsOptional()
  @IsString()
  religion?: string;

  @IsOptional()
  @IsString()
  nationality?: string;

  @IsOptional()
  @IsString()
  blood_group?: string;

  @IsOptional()
  @IsString()
  aadhaar_no?: string;

  @IsOptional()
  @IsString()
  pan_no?: string;

  @IsString()
  status!: string;
}
