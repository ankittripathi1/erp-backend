import { Type } from "class-transformer";
import { IsDateString, IsInt, IsOptional, IsString } from "class-validator";

export class CreateWorkExperienceDto {
  @Type(() => Number)
  @IsInt()
  employee_id!: number;

  @IsString()
  company!: string;

  @IsString()
  role!: string;

  @IsOptional()
  @IsDateString()
  start_date?: string;

  @IsOptional()
  @IsDateString()
  end_date?: string;

  @IsOptional()
  @IsString()
  description?: string;
}
