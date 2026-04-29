import { Type } from "class-transformer";
import { IsInt, IsOptional, IsString, Min } from "class-validator";

export class CreateCourseDto {
  @Type(() => Number)
  @IsInt()
  department_id!: number;

  @IsString()
  code!: string;

  @IsString()
  title!: string;

  @Type(() => Number)
  @IsInt()
  @Min(0)
  credits!: number;

  @IsString()
  course_type!: string;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  theory_hours?: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  practical_hourse?: number;

  @IsOptional()
  @IsString()
  description?: string;
}
